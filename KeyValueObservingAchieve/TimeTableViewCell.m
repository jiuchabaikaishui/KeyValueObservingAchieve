//
//  TimeTableViewCell.m
//  KeyValueObservingAchieve
//
//  Created by 綦 on 17/2/24.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import "TimeTableViewCell.h"

static void *KVOContext = 0;
@implementation TimeTableViewCell

- (void)dealloc
{
    [self.timeModel removeObserver:self forKeyPath:@"time"];
}
- (void)setTimeModel:(TimeModel *)timeModel
{
    if (timeModel) {
        [timeModel addObserver:self forKeyPath:@"time" options:NSKeyValueObservingOptionNew context:KVOContext];
        self.textLabel.text = [NSString stringWithFormat:@"%@倒计时：%i", timeModel.title, (int)timeModel.time];
        
        if (_timeModel) {
            [_timeModel removeObserver:self forKeyPath:@"time"];
        }
        _timeModel = timeModel;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == KVOContext) {
        if ([keyPath isEqualToString:@"time"]) {
            self.textLabel.text = [NSString stringWithFormat:@"%@倒计时：%i", self.timeModel.title, [change[NSKeyValueChangeNewKey] intValue]];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
