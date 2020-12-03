//
//  CalenderObject.h
//  QianBuXian_V2
//
//  Created by YangTianCi on 2018/4/3.
//  Copyright © 2018年 qbx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WeekName) {
    Sun,
    Mon,
    Thue,
    Wes,
    Thir,
    Fri,
    Thus
};

@interface CalenderObject : NSObject

#pragma mark --- 自定义_月度_数据

//标题 yyyy年MM月
@property (nonatomic, copy) NSString *title;
//天数合计--->含其他月
@property (nonatomic, assign) NSInteger totalDayCountAll;
//天数合计--->只含当月
@property (nonatomic, assign) NSInteger totalDayCount;
//第一天为周几
@property (nonatomic, assign) WeekName weekName;
//需要多少行
@property (nonatomic, assign) NSInteger RowCount;
//上月为多少天
@property (nonatomic, assign) NSInteger lastMonthCount;
//下月为多少天
@property (nonatomic, assign) NSInteger nextMonthCount;
//当页数据数组
@property (nonatomic, strong) NSArray *DayArray;
//数字格式时间数据
@property (nonatomic, assign) NSInteger yearInt;
@property (nonatomic, assign) NSInteger monthInt;
@property (nonatomic, assign) NSInteger dayInt;

#pragma mark --- 自定义_每天_数据

//day 数据
@property (nonatomic, assign) NSInteger DayNumber;
//day String
@property (nonatomic, copy) NSString *DayString;
//是否有事件
@property (nonatomic, assign) BOOL isHaveNotic;
//当天是否为本月日期
@property (nonatomic, assign) BOOL isCurrentMonth;
//如果不是本月日期, 则是上月还是下月日期
@property (nonatomic, assign) BOOL isLastMonth;
//当前日期是否为当日
@property (nonatomic, assign) BOOL isToday;

@end
