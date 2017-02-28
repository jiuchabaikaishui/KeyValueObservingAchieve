//
//  NSObject+KVO.m
//  KeyValueObservingAchieve
//
//  Created by 綦 on 17/2/24.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/Object.h>
#import <objc/objc-class.h>

#define KVOClassPrefix                          @"KVOClassPrefix"
#define KVOInfoDictionaryName                   @"KVOInfoDictionaryName"

@interface QSPKVOInfo : NSObject

@property (weak, nonatomic) id observer;
@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) KVOBlock block;

@end

@implementation QSPKVOInfo

+ (instancetype)QSPKVOInfo:(id)observer key:(NSString *)key block:(KVOBlock)block
{
    return [[self alloc] initWithObserver:observer key:key block:block];
}
- (instancetype)initWithObserver:(id)observer key:(NSString *)key block:(KVOBlock)block
{
    if (self = [super init]) {
        self.observer = observer;
        self.key = key;
        self.block = block;
    }
    
    return self;
}

@end


@implementation NSObject (KVO)

/**
 根据getter方法名获取setter方法名

 @param key getter方法名
 @return setter方法名
 */
NSString * setterForGeter(NSString *key)
{
    if (key && key.length > 0) {
        NSString *upperKey = [key uppercaseString];
        return [NSString stringWithFormat:@"set%@%@", [upperKey substringToIndex:1], [key substringFromIndex:1]];
    }
    
    return nil;
}

/**
 根据setter方法名获取getter方法名

 @param setter setter方法名
 @return getter方法名
 */
NSString * getterForSetter(NSString *setter)
{
    if ([setter hasPrefix:@"set"] && [setter hasSuffix:@":"]) {
        NSString *lowerKey = [setter lowercaseString];
        return [NSString stringWithFormat:@"%@%@", [lowerKey substringWithRange:NSMakeRange(3, 1)], [setter substringFromIndex:4]];
    }
    
    return nil;
}

/**
 kvo类class方法的IMP
 */
Class kvo_class(id self, SEL _cmd)
{
    return class_getSuperclass(self);
}

/**
 根据类名创建kvo类

 @param originalClazzName 类名
 @return kvo类
 */
- (Class)makeKvoClassWithOriginalClassName:(NSString *)originalClazzName
{
    NSString *kvoClassName = [KVOClassPrefix stringByAppendingString:originalClazzName];
    Class kvoClass = NSClassFromString(kvoClassName);
    if (kvoClass) {
        return kvoClass;
    }
    
    Class originalClass = [self class];
    kvoClass = objc_allocateClassPair(originalClass, kvoClassName.UTF8String, 0);
    class_addMethod(kvoClass, @selector(class), (IMP)kvo_class, method_getTypeEncoding(class_getClassMethod(originalClass, @selector(class))));
    objc_registerClassPair(kvoClass);
    
    return kvoClass;
}

/**
 判断类中是否存在某个方法

 @param selector SLE
 */
- (BOOL)hasSelector:(SEL)selector
{
    unsigned int methodListCount = 0;
    Method *methodList = class_copyMethodList([self class], &methodListCount);
    for (int index = 0; index < methodListCount; index++) {
        if (selector == method_getName(methodList[index])) {
            return YES;
        }
    }
    
    return NO;
}

/**
 kvo类的setter方法的IMP
 */
void kvo_setter(id self, SEL _cmd, id value)
{
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
    
    if (!getterName) {
        NSLog(@"不存在此属性!");
    }
    
    id oldValue = [self valueForKey:getterName];
    objc_msgSendSuper((__bridge struct objc_super *)(class_getSuperclass(object_getClass(self))), _cmd, value);
    
    NSMutableDictionary *infoDic = objc_getAssociatedObject(self, KVOInfoDictionaryName.UTF8String);
    QSPKVOInfo *info = infoDic[getterName];
    if (info.block) {
        info.block(self, info.observer, info.key, oldValue, value);
    }
}
- (void)QSP_addObserver:(NSObject *)observer forkey:(NSString *)key withBlock:(KVOBlock)block
{
    //1.检查对象的类有没有相应的 setter 方法。如果没有抛出异常；
    Class class = [self class];
    SEL setterSelector = NSSelectorFromString(setterForGeter(key));
    Method setterMethod = class_getInstanceMethod(class, setterSelector);
    
    if (!setterMethod) {
        NSLog(@"此属性不存在！");
    }
    
    //2.检查对象 isa 指向的类是不是一个 KVO 类。如果不是，新建一个继承原来类的子类，并把 isa 指向这个新建的子类；
    NSString *className = NSStringFromClass(class);
    if (![className hasPrefix:KVOClassPrefix]) {
        class = [self makeKvoClassWithOriginalClassName:className];
        object_setClass(self, class);
    }
    
    //3.检查对象的 KVO 类重写过没有这个 setter 方法。如果没有，添加重写的 setter 方法；
    if (![self hasSelector:setterSelector]) {
        BOOL success = class_addMethod(class, setterSelector, (IMP)kvo_setter, method_getTypeEncoding(class_getInstanceMethod(class, setterSelector)));
        if (success) {
            NSLog(@"方法添加成功！");
        }
        else
        {
            NSLog(@"方法添加失败！");
        }
    }
    
    //4.添加这个观察者
    NSMutableDictionary *infoDic = objc_getAssociatedObject(self, KVOInfoDictionaryName.UTF8String);
    if (infoDic == nil) {
        infoDic = [NSMutableDictionary dictionaryWithCapacity:1];
        objc_setAssociatedObject(self, KVOInfoDictionaryName.UTF8String, infoDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    QSPKVOInfo *info = [QSPKVOInfo QSPKVOInfo:observer key:key block:block];
    infoDic[key] = info;
}
- (void)QSP_removeObserver:(NSObject *)observer forkey:(NSString *)key
{
    NSMutableDictionary *infoDic = objc_getAssociatedObject(self, KVOInfoDictionaryName.UTF8String);
    QSPKVOInfo *info = infoDic[key];
    
    if ([info.key isEqualToString:key] && info.observer == observer) {
        [infoDic removeObjectForKey:key];
    }
}

@end
