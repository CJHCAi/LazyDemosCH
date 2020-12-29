//
//  YXWAlarmWayView.m
//  StarAlarm
//
//  Created by dllo on 16/3/31.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWAlarmWayView.h"
#import "YXWHardView.h"
@interface YXWAlarmWayView ()

@property (nonatomic, strong) UILabel *hardLabel;
@property (nonatomic, strong) YXWHardView *hardView;
@property (nonatomic, strong) UIView *spartView;

@end

@implementation YXWAlarmWayView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatView];
    }
    return self;
}

- (void)creatView {
    //    模式图片
    self.alarmWayImageView = [UIImageView new];
    [self addSubview:self.alarmWayImageView];
    self.alarmWayImageView.image = [UIImage imageNamed:@"wall1"];
    [self.alarmWayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self).offset(-35);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    self.spartView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 30, 220 * myScale - 40)];
    self.spartView.backgroundColor = [UIColor colorWithRed:0.1765 green:0.1765 blue:0.1765 alpha:0.202747844827586];
    [self addSubview:self.spartView];
    //    模式选择
    self.chosebutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.chosebutton setTitle:@"选择任务" forState:UIControlStateNormal];
    [self.chosebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.chosebutton addTarget:self action:@selector(chosebuttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.chosebutton];
    [self.chosebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self.alarmWayImageView.mas_bottom).offset(5);
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self).offset(-5);
        make.centerX.equalTo(self.mas_centerX);
    }];
//    模式名称
    self.alarmWayTitle = [UILabel new];
    self.alarmWayTitle.textAlignment = NSTextAlignmentCenter;
    self.alarmWayTitle.text = @"平静的宇宙";
    self.alarmWayTitle.textColor = [UIColor whiteColor];
    [self.spartView addSubview:self.alarmWayTitle];
    [self.alarmWayTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.left.equalTo(self.alarmWayImageView).offset(0);
        make.right.equalTo(self.alarmWayImageView).offset(0);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.alarmWayImageView.mas_centerY).offset(-20);
    }];
//    难度视图
    self.hardView = [YXWHardView new];
    self.hardView.hard = ONESTAR;
    [self.spartView addSubview:self.hardView];
    [self.hardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alarmWayTitle.mas_bottom).offset(10);
        make.left.equalTo(self.alarmWayImageView).offset(0);
        make.right.equalTo(self.alarmWayImageView).offset(0);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
}

- (void)setAlarmModel:(YXWAlarmModel *)alarmModel {
    _alarmModel = alarmModel;
    _alarmWayTitle.text = _alarmModel.title;
    [_alarmWayImageView setImage:[UIImage imageNamed:_alarmModel.image]];
    _hardView.hard = _alarmModel.hard.integerValue;
}

- (void)chosebuttonAction {
    [self.delegate pushToChooseVc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
