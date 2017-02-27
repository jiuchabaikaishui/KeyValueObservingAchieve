//
//  AnimationView.h
//  KeyValueObservingAchieve
//
//  Created by apple on 17/2/25.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationView : UIView

@property (assign,nonatomic) CGFloat spacing;
@property (assign,nonatomic) CGFloat circleDistance;
@property (strong,nonatomic) UIColor *startColor;
@property (strong,nonatomic) UIColor *endColor;
@property (strong,nonatomic) UIColor *lineColor;

@property (assign,nonatomic) CGFloat percent;

@end
