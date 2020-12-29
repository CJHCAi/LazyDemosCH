//
//  YXWAlartTimeTool.m
//  StarAlarm
//
//  Created by dllo on 16/4/9.
//  Copyright © 2016年 YYL. All rights reserved.
//

#import "YXWAlartTimeTool.h"

@implementation YXWAlartTimeTool


+ (NSArray *)timeWithWeek:(NSString *)dayStr withTme:(NSString *)time {
    NSMutableArray *timeArray = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *clockTimeArray = [time componentsSeparatedByString:@":"];
    
    NSDate *dateNow = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags =  NSCalendarUnitEra |
    NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond |
    NSWeekCalendarUnit |
    NSCalendarUnitWeekday |
    NSCalendarUnitWeekday |
    NSCalendarUnitQuarter;
    
    comps = [calendar components:unitFlags fromDate:dateNow];
    [comps setHour:[[clockTimeArray objectAtIndex:0] integerValue]];
    [comps setMinute:[[clockTimeArray objectAtIndex:1] integerValue]];
    [comps setSecond:0];
    
    NSInteger weekday = [comps weekday];
    
    NSArray *dayArray = [self timeArrayWithString:dayStr];
    int days = 0;
    int temp = 0;
    for (int i = 0; i < dayArray.count; i++) {
        temp = [dayArray[i] intValue] - (int)weekday;
        days = (temp >= 0 ? temp : temp + 7);
        
        NSDate *newFireDate = [[calendar dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
        
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[newFireDate timeIntervalSinceNow]];
        [timeArray addObject:timeSp];
    }
    
    NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:0];
    for (NSString *time in timeArray) {
        if (time.integerValue < 0) {
            NSString *str = [NSString stringWithFormat:@"%ld", time.integerValue + 3600 * 24 * 7];
            [arr1 addObject:str];
        } else {
            [arr1 addObject:time];
        }
    }
    timeArray = [NSMutableArray arrayWithArray:arr1];
    
    for (int i = 0; i < timeArray.count - 1; i++) {
        for (int j = 0; j < timeArray.count - 1 - i; j++) {
            if ([timeArray[j] integerValue] > [timeArray[j + 1] integerValue]) {
                NSString *tempa = timeArray[j + 1];
                timeArray[j + 1] = timeArray[j];
                timeArray[j] = tempa;
            }
        }
    }
    
    
    return timeArray;
}

+ (NSMutableArray *)timeArrayWithString:(NSString *)dayStr {
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    NSString *str1 = @"一";
    NSString *str2 = @"二";
    NSString *str3 = @"三";
    NSString *str4 = @"四";
    NSString *str5 = @"五";
    NSString *str6 = @"六";
    NSString *str7 = @"日";
    NSRange range7 = [dayStr rangeOfString:str7];
    NSRange range1 = [dayStr rangeOfString:str1];
    NSRange range2 = [dayStr rangeOfString:str2];
    NSRange range3 = [dayStr rangeOfString:str3];
    NSRange range4 = [dayStr rangeOfString:str4];
    NSRange range5 = [dayStr rangeOfString:str5];
    NSRange range6 = [dayStr rangeOfString:str6];
    
    if (range1.length != 0) {
        [arr addObject:@2];
    }
    if (range2.length != 0) {
        [arr addObject:@3];
    }
    if (range3.length != 0) {
        [arr addObject:@4];
    }
    if (range4.length != 0) {
        [arr addObject:@5];
    }
    if (range5.length != 0) {
        [arr addObject:@6];
    }
    if (range6.length != 0) {
        [arr addObject:@7];
    }
    if (range7.length != 0) {
        [arr addObject:@1];
    }
    
    
    return arr;
}



@end
