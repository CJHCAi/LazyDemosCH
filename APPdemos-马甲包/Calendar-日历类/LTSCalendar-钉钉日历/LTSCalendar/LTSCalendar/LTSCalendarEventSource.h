//
//  LTSCalendarEventSource.h
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//  点击有事件日期。。。

#import <Foundation/Foundation.h>
@class LTSCalendarManager;
@protocol LTSCalendarEventSource <NSObject>

/**
 该日期是否有事件

 @param calendar calendar
 @param date  NSDate
 @return BOOL
 */
- (BOOL)calendarHaveEvent:(LTSCalendarManager *)calendar date:(NSDate *)date;


/**
 点击 日期后的执行的操作

 @param calendar LTSCalendarManager
 @param date 选中的日期
 */
- (void)calendarDidDateSelected:(LTSCalendarManager *)calendar date:(NSDate *)date;


/**
 翻页完成后的操作

 @param calendar <#calendar description#>
 */
- (void)calendarDidLoadPage:(LTSCalendarManager *)calendar;

@end
