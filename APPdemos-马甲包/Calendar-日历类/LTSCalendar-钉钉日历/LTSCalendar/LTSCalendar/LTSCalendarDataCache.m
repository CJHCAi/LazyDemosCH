//
//  LTSCalendarDataCache.m
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//  事件 缓存类

#import "LTSCalendarDataCache.h"
#import "LTSCalendarManager.h"

@interface LTSCalendarDataCache(){
    NSMutableDictionary *events;
    NSDateFormatter *dateFormatter;
};

@end

@implementation LTSCalendarDataCache

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    events = [NSMutableDictionary new];
    
    return self;
}

- (void)reloadData
{
    [events removeAllObjects];
}

- (BOOL)haveEvent:(NSDate *)date
{
    if(!self.calendarManager.eventSource){
        return NO;
    }
    
    
   return [self.calendarManager.eventSource calendarHaveEvent:self.calendarManager date:date];
    
    
    
}
@end
