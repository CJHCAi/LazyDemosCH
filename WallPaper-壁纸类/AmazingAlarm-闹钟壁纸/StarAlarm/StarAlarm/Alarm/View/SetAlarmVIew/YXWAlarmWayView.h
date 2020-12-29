//
//  YXWAlarmWayView.h
//  StarAlarm
//
//  Created by dllo on 16/3/31.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXWAlarmModel.h"

@protocol YXWAlarmWayViewDelegate <NSObject>

- (void)pushToChooseVc;

@end

@interface YXWAlarmWayView : UIView
/**
 *  闹钟模式的标题
 */
@property (nonatomic, strong) UILabel *alarmWayTitle;
/**
 *  闹钟模式的图片
 */
@property (nonatomic, strong) UIImageView * alarmWayImageView;
/**
 *  选择模式
 */
@property (nonatomic, strong) UIButton *chosebutton;

@property (nonatomic, assign) id<YXWAlarmWayViewDelegate>delegate;

@property (nonatomic, strong) YXWAlarmModel *alarmModel;


@end
