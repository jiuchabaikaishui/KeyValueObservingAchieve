//
//  ViewController.m
//  KeyValueObservingAchieve
//
//  Created by 綦 on 17/2/24.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import "ViewController.h"
#import "TimeTableViewCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [timer fire];
    self.timer = timer;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}
- (void)timerAction:(NSTimer *)timer
{
    for (TimeModel *timeModel in self.dataArr) {
        timeModel.time--;
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
