//
//  NSObject+KVO.h
//  KeyValueObservingAchieve
//
//  Created by 綦 on 17/2/24.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVO)

- (void)QSP_addObserver:(NSObject *)observer forkey:(NSString *)key withBlock:(void (^)(id *observer, NSString *key, id oldValue, id newValue))block;
- (void)QSP_removeObserver:(NSObject *)observer forkey:(NSString *)key;

@end
