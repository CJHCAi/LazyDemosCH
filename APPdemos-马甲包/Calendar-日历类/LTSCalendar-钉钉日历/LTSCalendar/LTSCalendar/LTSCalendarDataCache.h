//
//  LTSCalendarDataCache.h
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LTSCalendarManager;

@interface LTSCalendarDataCache : NSObject

@property (weak, nonatomic) LTSCalendarManager *calendarManager;

- (void)reloadData;
- (BOOL)haveEvent:(NSDate *)date;

@end
