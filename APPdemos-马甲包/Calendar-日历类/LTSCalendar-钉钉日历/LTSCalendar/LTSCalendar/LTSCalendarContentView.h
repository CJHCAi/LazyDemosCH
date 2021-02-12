//
//  LTSCalendarContentView.h
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//  日历容器

#import <UIKit/UIKit.h>

@class  LTSCalendarManager;

@interface LTSCalendarContentView : UIScrollView
@property (nonatomic,strong)NSMutableArray *monthsViews; 

@property (weak, nonatomic) LTSCalendarManager *calendarManager;



@property (strong, nonatomic) NSDate *currentDate;

/// 重新加载数据
- (void)reloadData;
/// 重新加载外观
- (void)reloadAppearance;

/// 将序号为多少的WeekView 放到SelectedWeekView 的里面
- (void)sendSubviewToSelectedWeekViewWithIndex:(NSInteger)index;

/// 将序号为多少的WeekView 放到回到monthView 的里面
- (void)sendSubviewToMonthViewWithIndex:(NSInteger)index;

- (void)setWeekViewHidden:(BOOL)hidden toIndex:(NSInteger)index;

@end
