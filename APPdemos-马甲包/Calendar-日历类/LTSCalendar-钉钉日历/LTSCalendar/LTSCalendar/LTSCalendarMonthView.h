//
//  LTSCalendarMonthView.h
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WEEKS_TO_DISPLAY 6
@class LTSCalendarManager;

@interface LTSCalendarMonthView : UIView

@property (nonatomic,strong)NSArray *weeksViews;

@property (weak, nonatomic) LTSCalendarManager *calendarManager;



- (void)setBeginningOfMonth:(NSDate *)date;
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
