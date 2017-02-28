//
//  QSPKVOViewController.m
//  KeyValueObservingAchieve
//
//  Created by 綦 on 17/2/27.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import "QSPKVOViewController.h"
#import "TimeTableViewCell.h"
#import "AnimationView.h"
#import "NSObject+KVO.h"

static void *QSPKVOContext_ContentOffset = 0;

@interface QSPKVOViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSTimer *timer;
@property (weak,nonatomic) AnimationView *animationView;
@property (weak, nonatomic) UIView *navBackView;

@end

@implementation QSPKVOViewController
#pragma mark - 属性方法
- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray arrayWithCapacity:1];
        
        TimeModel *timeModel;
        for (int index = 0; index < 100; index++) {
            timeModel = [[TimeModel alloc] init];
            timeModel.title = [NSString stringWithFormat:@"第%i行", index];
            timeModel.time = arc4random()%30 + 30;
            [_dataArr addObject:timeModel];
        }
    }
    
    return _dataArr;
}

#pragma mark - 控制器周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUi];
}

#pragma mark - 自定义方法
- (void)settingUi
{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.height = rect.size.height - 49;
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 264)];
    AnimationView *animationView = [[AnimationView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200)];
    animationView.percent = 0;
    [headerView addSubview:animationView];
    self.animationView = animationView;
    self.tableView.tableHeaderView = headerView;
    [self.tableView QSP_addObserver:self forkey:@"contentOffset" withBlock:^(id object, id observer, NSString *key, id oldValue, id newValue) {
        if (self.navBackView == nil) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
            view.backgroundColor = [UIColor orangeColor];
            [self.navigationController.navigationBar insertSubview:view atIndex:0];
            self.navBackView = view;
        }
        
        CGPoint contentOffset = [newValue CGPointValue];
        CGFloat alpha = (contentOffset.y - 64)*(1/136.0);
        
        if (alpha >= 1) {
            self.navBackView.alpha = 1;
        }
        else if (alpha > 0 && alpha < 1)
        {
            self.navBackView.alpha = alpha;
        }
        else
        {
            self.navBackView.alpha = 0;
        }
    }];
//    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:QSPKVOContext_ContentOffset];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkAction:)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    if (context == QSPKVOContext_ContentOffset) {
//        if ([keyPath isEqualToString:@"contentOffset"]) {
//            if (self.navBackView == nil) {
//                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
//                view.backgroundColor = [UIColor orangeColor];
//                [self.navigationController.navigationBar insertSubview:view atIndex:0];
//                self.navBackView = view;
//            }
//            
//            CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
//            CGFloat alpha = (contentOffset.y - 64)*(1/136.0);
//            
//            if (alpha >= 1) {
//                self.navBackView.alpha = 1;
//            }
//            else if (alpha > 0 && alpha < 1)
//            {
//                self.navBackView.alpha = alpha;
//            }
//            else
//            {
//                self.navBackView.alpha = 0;
//            }
//        }
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}
- (void)timerAction:(NSTimer *)timer
{
    for (TimeModel *timeModel in self.dataArr) {
        if (timeModel.time > 0) {
            timeModel.time--;
        }
    }
}
- (void)linkAction:(CADisplayLink *)link
{
    static BOOL direction = YES;
    CGFloat difference = 1.0/10/60;
    if (direction) {
        if (self.animationView.percent < 1) {
            self.animationView.percent += difference;
        }
        else
        {
            self.animationView.percent -= difference;
            direction = NO;
        }
    }
    else
    {
        if (self.animationView.percent > 0) {
            self.animationView.percent -= difference;
        }
        else
        {
            self.animationView.percent += difference;
            direction = YES;
        }
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    TimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    TimeModel *timeModel = self.dataArr[indexPath.row];
    cell.timeModel = timeModel;
    
    return cell;
}

@end
