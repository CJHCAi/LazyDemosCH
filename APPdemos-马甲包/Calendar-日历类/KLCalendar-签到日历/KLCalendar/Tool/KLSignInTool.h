//
//  KLSignInTool.h
//  KLCalendar
//
//  Created by kai lee on 16/7/26.
//  Copyright © 2016年 kai lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLSignInTool : NSObject
/**
 *  NSInteger 类型的天数
 */
+ (NSInteger)day:(NSDate *)date;
/**
 *  NSInteger 类型的月数
 */
+ (NSInteger)month:(NSDate *)date;
/**
 *  NSInteger 类型的年
 */
+ (NSInteger)year:(NSDate *)date;
/**
 *  NSInteger 类型的当月第一天是星期几
 */
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
/**
 *  当月总共的天数
 */
+ (NSInteger)totaldaysInMonth:(NSDate *)date;
/**
 *  上个月
 */
+ (NSDate *)lastMonth:(NSDate *)date;
/**
 *  下个月
 */
+ (NSDate*)nextMonth:(NSDate *)date;
@end
