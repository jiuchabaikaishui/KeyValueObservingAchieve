//
//  ViewController.m
//  KeyValueObservingAchieve
//
//  Created by apple on 17/2/26.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    CGFloat W = 50;
    CGFloat H = 30;
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    button.frame = CGRectMake((screenWith - W)/2, (screenHeight - H)/2, W, H);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonAction:(UIButton *)sender
{
    
}

@end
