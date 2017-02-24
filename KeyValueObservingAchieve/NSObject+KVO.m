//
//  NSObject+KVO.m
//  KeyValueObservingAchieve
//
//  Created by 綦 on 17/2/24.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/objc.h>
#import <objc/objc-class.h>

@implementation NSObject (KVO)

- (void)QSP_addObserver:(NSObject *)observer forkey:(NSString *)key withBlock:(void (^)(id *observer, NSString *key, id oldValue, id newValue))block
{
    //1.检查对象的类有没有相应的 setter 方法。如果没有抛出异常；
    //2.检查对象 isa 指向的类是不是一个 KVO 类。如果不是，新建一个继承原来类的子类，并把 isa 指向这个新建的子类；
    //3.检查对象的 KVO 类重写过没有这个 setter 方法。如果没有，添加重写的 setter 方法；
    //4.添加这个观察者
}
- (void)QSP_removeObserver:(NSObject *)observer forkey:(NSString *)key
{
    Class class = [self class];
//    SEL setSel = NSSelectorFromString(setterForGetter(key));
}

@end
