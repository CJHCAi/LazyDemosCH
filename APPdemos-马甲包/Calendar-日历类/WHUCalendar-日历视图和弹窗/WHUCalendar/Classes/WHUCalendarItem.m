//
//  WHUCalendarItem.m
//  TEST_Calendar
//
//  Created by SuperNova(QQ:422596694) on 15/11/5.
//  Copyright (c) 2015年 SuperNova(QQ:422596694). All rights reserved.
//

#import "WHUCalendarItem.h"

@implementation WHUCalendarItem
-(BOOL)isEqual:(WHUCalendarItem*)object{
    return [object.dateStr isEqualToString:self.dateStr];
}

-(NSUInteger) hash{
    return [_dateStr hash];
}
@end
