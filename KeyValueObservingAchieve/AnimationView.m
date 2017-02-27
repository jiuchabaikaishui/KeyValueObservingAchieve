//
//  AnimationView.m
//  KeyValueObservingAchieve
//
//  Created by apple on 17/2/25.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import "AnimationView.h"

#define Default_Spacing             8
#define Default_Distance            40
#define Default_Start_Color         [UIColor cyanColor]
#define Default_End_Color           [UIColor redColor]
#define Default_Line_Color          [UIColor blackColor]
#define Default_Percent             0.8

@implementation AnimationView

#pragma mark - 属性方法
- (void)setSpacing:(CGFloat)spacing
{
    _spacing = spacing;
    [self setNeedsDisplay];
}
- (void)setCircleDistance:(CGFloat)circleDistance
{
    _circleDistance = circleDistance;
    [self setNeedsDisplay];
}
- (void)setStartColor:(UIColor *)startColor
{
    _startColor = startColor;
    [self setNeedsDisplay];
}
- (void)setEndColor:(UIColor *)endColor
{
    _endColor = endColor;
    [self setNeedsDisplay];
}
- (void)setPercent:(CGFloat)percent
{
    _percent = percent;
    [self setNeedsDisplay];
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setting];
    }
    
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setting];
    }
    
    return self;
}
- (void)setting
{
    self.backgroundColor = [UIColor whiteColor];
    self.spacing = Default_Spacing;
    self.circleDistance = Default_Distance;
    self.startColor = Default_Start_Color;
    self.endColor = Default_End_Color;
    self.lineColor = Default_Line_Color;
    self.percent = Default_Percent;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGPoint centerPoint = CGPointMake(rect.size.width/2, rect.size.height - self.spacing);
    CGFloat bigR = centerPoint.x > centerPoint.y ? centerPoint.y - self.spacing : centerPoint.x - self.spacing;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGFloat smollR = bigR - self.circleDistance > 0 ? bigR - self.circleDistance : 0;
    
    CGContextAddArc(contextRef, centerPoint.x, centerPoint.y, bigR, M_PI*2, M_PI, 1);
    CGContextAddLineToPoint(contextRef, centerPoint.x - smollR, rect.size.height - self.spacing);
    CGContextAddArc(contextRef, centerPoint.x, centerPoint.y, smollR, M_PI, M_PI*2, 0);
    CGContextClosePath(contextRef);
    [self.endColor setFill];
    CGContextFillPath(contextRef);
    
    CGContextAddArc(contextRef, centerPoint.x, centerPoint.y, bigR, M_PI*(1 + self.percent), M_PI, 1);
    CGContextAddLineToPoint(contextRef, centerPoint.x - smollR, rect.size.height - self.spacing);
    CGContextAddArc(contextRef, centerPoint.x, centerPoint.y, smollR, M_PI, M_PI*(1 + self.percent), 0);
    CGContextClosePath(contextRef);
    [self.startColor setFill];
    CGContextFillPath(contextRef);
    
    CGFloat X = centerPoint.x - bigR*cos(M_PI*self.percent);
    CGFloat Y = centerPoint.y - bigR*sin(M_PI*self.percent);
    CGContextMoveToPoint(contextRef, X, Y);
    X = centerPoint.x - smollR*cos(M_PI*self.percent);
    Y = centerPoint.y - smollR*sin(M_PI*self.percent);
    CGContextAddLineToPoint(contextRef, X, Y);
    [self.lineColor setStroke];
    CGContextSetLineWidth(contextRef, 5);
    CGContextStrokePath(contextRef);
    
    NSString *str = [NSString stringWithFormat:@"%.1f%%", self.percent*100];
    NSMutableParagraphStyle *alignmentCParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    alignmentCParagraphStyle.alignment = NSTextAlignmentCenter;
    [str drawInRect:CGRectMake(0, (rect.size.height - 30)/2 + 30, rect.size.width, 30) withAttributes:@{NSParagraphStyleAttributeName:alignmentCParagraphStyle, NSFontAttributeName:[UIFont systemFontOfSize:17]}];
}

@end
