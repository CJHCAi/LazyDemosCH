//
//  CFDayEntity.m
//  CFCalendar
//
//  Created by MountainCao on 2017/8/22.
//  Copyright © 2017年 深圳中业兴融互联网金融服务有限公司. All rights reserved.
//

#import "CFDayEntity.h"

@implementation CFDayEntity

- (NSInteger)week {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",self.year,self.month,self.day];
    NSDate * date = [formatter dateFromString:dateStr];
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal fromDate:date];
    //0对应周日，1--6对应周一到周六
    return comps.weekday-1;
}

- (BOOL)currentDay {
   
    NSDate * date = [NSDate date];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal fromDate:date];
    
    if (comps.year == self.year && comps.month == self.month && comps.day == self.day) {
        return YES;
    }
    return NO;
}

@end
