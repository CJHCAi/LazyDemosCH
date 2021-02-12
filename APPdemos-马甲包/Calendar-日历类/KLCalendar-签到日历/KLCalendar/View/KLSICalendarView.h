//
//  KLSICalendarView.h
//  KLCalendar
//
//  Created by kai lee on 16/7/26.
//  Copyright © 2016年 kai lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLSignInTool.h"

typedef void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);
@interface KLSICalendarView : UIView
/**
 *  日期
 */
@property (nonatomic, strong) NSDate *date;
/**
 *  calendarBlock 传递 年、月、日
 */
@property (nonatomic, copy) calendarBlock calendarBlock;
/**
 *  签到数组
 */
@property (nonatomic,strong)  NSMutableArray *signArray;

// 日期按钮
@property (nonatomic,strong)  UIButton *dayButton;
// 标志
@property (nonatomic, assign) NSInteger falg;

//设置不是本月的日期字体颜色 - 不可见
- (void)setStyleNotThisMonth:(UIButton *)btn;

//这个月 今日之前的日期style
- (void)setStyleBeforeToday:(UIButton *)btn;


//今日已签到
- (void)setStyleTodaySigned:(UIButton *)btn;

//今日没签到
- (void)setStyleTodayUnSigned:(UIButton *)btn;

//这个月 今天之后的日期style
- (void)setStyleAfterToday:(UIButton *)btn;

//已经签过的 日期style
- (void)setStyleSigned:(UIButton *)btn;

@end
