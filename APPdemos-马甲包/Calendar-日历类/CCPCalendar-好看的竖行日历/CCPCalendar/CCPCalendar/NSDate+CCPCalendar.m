//
//  NSDate+CCPCalendar.m
//  CCPCalendar
//
//  Created by 储诚鹏 on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "NSDate+CCPCalendar.h"
#import <objc/runtime.h>

static const void *ccp_calendar = &ccp_calendar;

@implementation NSDate (CCPCalendar)

/*------private--------*/

- (NSCalendar *)cld {
    return objc_getAssociatedObject(self, ccp_calendar);
}

- (void)setCld:(NSCalendar *)cld {
    objc_setAssociatedObject(self, ccp_calendar, cld, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSCalendar *)calendar {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone localTimeZone];
    calendar.locale = [NSLocale currentLocale];
    return calendar;
}

- (NSDateComponents *)compts:(NSDate *)date {
    NSDateComponents *compts = [[self calendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    compts.timeZone = [NSTimeZone localTimeZone];
    return compts;
}

- (NSDate *)firstDay {
    NSCalendar *clendar = [self calendar];
    NSDateComponents *compts = [self compts:self];
    compts.day = 2;
    NSDate *date = [clendar dateFromComponents:compts];
    return date;
}

- (NSDate *)lastDay {
    NSCalendar *calendar = [self calendar];
    NSDateComponents *compts = [self compts:self];
    compts.day = 0;
    compts.month += 1;
    NSDate *date = [calendar dateFromComponents:compts];
    return date;
}

- (NSInteger)getMonth:(NSDate *)date {
    NSDateComponents *copmts = [self compts:date];
    return copmts.month;
}

- (NSInteger)getDay:(NSDate *)date {
    NSDateComponents *copmts = [self compts:date];
    return copmts.day;
}

- (NSInteger)getYear:(NSDate *)date {
    NSDateComponents *copmts = [self compts:date];
    return copmts.year;
}

/*-------public-----*/

- (NSInteger)firstDay_week {
    NSDate *firstDate = [self firstDay];
    NSDateComponents *compts = [self compts:firstDate];
    NSArray *arr = @[@1,@6,@0,@1,@2,@3,@4,@5];
    return [arr[compts.weekday] integerValue];
}

- (NSInteger)lastDay_week {
    NSDate *lastDate = [self lastDay];
    NSDateComponents *compts = [self compts:lastDate];
    NSInteger week = compts.weekday;
    return week - 1;
}

- (NSDate *)addMonth:(NSInteger)month {
    NSCalendar *clendar = [self calendar];
    NSDateComponents *compts = [self compts:self];
    compts.month += month;
    //必须 不然有bug
    compts.day = 1;
    return [clendar dateFromComponents:compts];
}

- (NSDate *)addYear:(NSInteger)year {
    NSCalendar *clendar = [self calendar];
    NSDateComponents *compts = [self compts:self];
    compts.year += 1;
    return [clendar dateFromComponents:compts];
}

- (NSDate *)addDay:(NSInteger)day {
    NSCalendar *clendar = [self calendar];
    NSDateComponents *compts = [self compts:self];
    compts.day += day;
    return [clendar dateFromComponents:compts];
}

- (NSInteger)dayOfMonth {
    NSCalendar *clendar = [self calendar];
    NSRange days = [clendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return days.length;
}

- (NSInteger)getYear {
    NSDateComponents *copmts = [self compts:self];
    return copmts.year;
}

- (NSInteger)getMonth {
    NSDateComponents *copmts = [self compts:self];
    return copmts.month;
}

//当前日期日
- (NSInteger)getDay {
    NSDateComponents *copmts = [self compts:self];
    return copmts.day;
}
//是否相等 精确到日
- (BOOL)isSameTo:(NSDate *)date {
    if ([self getDay] == [self getDay:date] && [self getYear] == [self getYear:date] && [self getMonth] == [self getMonth:date]) {
        return YES;
    }
    return NO;
}

- (NSDate *)changToDay:(NSInteger)day {
    NSDateComponents *copmts = [self compts:self];
    copmts.day = day;
    return [[self calendar] dateFromComponents:copmts];
}

//是否早于当前日期 精确到日
- (BOOL)earlyThan:(NSDate *)date {
    NSString *str1 = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)[self getYear],(long)[self getMonth],(long)[self getDay]];
    NSString *str2 = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)[date getYear:date],(long)[date getMonth:date],(long)[date getDay:date]];
    if ([str1 compare:str2] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}


- (NSString *)weekString {
    NSDateComponents *compts = [self compts:self];
    NSArray *weeks = @[@"SUN", @"Mon", @"TUE", @"WED", @"THU", @"FRI", @"SAT"];
    return weeks[compts.weekday - 1];
}

- (NSInteger)getWeek {
    NSDateComponents *compts = [self compts:self];
    return compts.weekday - 1;
}

@end
