//
//  CJUseTime.h
//  CJCalendar
//
//  Created by chjsun on 16/5/26.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJUseTime : NSObject


+ (CJUseTime *)sharedInstance;
/**
 *  根据给定字符串返回字符串代表月的天数
 *
 *  @param dateStr @"xxxx-xx-xx"
 *
 *  @return 28 or 29 or 30 or 31
 */
-(NSInteger) timeNumberOfDaysInString:(NSString *) dateStr;
-(NSInteger) timeNumberOfDaysInDate:(NSDate *) date;

/**
 *  根据给定字字符串返回字符串代表天是星期几
 *
 *  @param dateStr @"xxxx-xx-xx"
 *
 *  @return 0-周日 or 1－周一 or 2－周二 or 3－周三 or 4－周四 or 5－周五 or 6－周六
 */
-(NSInteger) timeMonthWeekDayOfFirstDay:(NSString *)dateStr;
/**
 * 获得一个月“占”几个星期
 *
 *  @param dateStr @"xxxx-xx-xx"
 *
 *  @return 4 or 5 or 6
 */
-(NSInteger)timeFewWeekInMonth:(NSString *)dateStr;
/**
 *  根据给定字符串返回字符串代表的农历的日
 *
 *  @param dateStr @"xxxx-xx-xx"
 *
 *  @return 1～30
 */
-(NSString *)timeChineseDaysWithDate:(NSString *)dateStr;
/**
 *  根据给定字符串返回字符串代表的农历的日期
 *
 *  @param dateStr @"xxxx-xx-xx"
 *
 *  @return 丙寅虎年 四月廿四 星期三
 */
- (NSString *) timeChineseCalendarWithString:(NSString *)dateStr;
- (NSString *) timeChineseCalendarWithDate:(NSDate *)date;

// 字符串转日期
- (NSDate *) strToDate:(NSString *)dateStr;
// 日期转字符串
- (NSString *) dataToString:(NSDate *)date;
@end
