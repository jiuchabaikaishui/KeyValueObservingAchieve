//
//  NSObject+KVO.h
//  KeyValueObservingAchieve
//
//  Created by 綦 on 17/2/24.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^KVOBlock)(id object, id observer, NSString *key, CGPoint oldValue, CGPoint newValue);

@interface NSObject (KVO)

- (void)QSP_addObserver:(NSObject *)observer forkey:(NSString *)key withBlock:(KVOBlock)block;
- (void)QSP_removeObserver:(NSObject *)observer forkey:(NSString *)key;

@end
