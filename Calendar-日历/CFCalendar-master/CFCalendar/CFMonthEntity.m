//
//  CFMonthEntity.m
//  CFCalendar
//
//  Created by MountainCao on 2017/8/22.
//  Copyright © 2017年 深圳中业兴融互联网金融服务有限公司. All rights reserved.
//

#import "CFMonthEntity.h"

@implementation CFMonthEntity

- (NSInteger)daysSum {
    
    if((self.month == 1) || (self.month == 3) || (self.month == 5) || (self.month == 7) || (self.month == 8) || (self.month == 10) || (self.month == 12))
        return 31 ;
    
    if((self.month == 4) || (self.month == 6) || (self.month == 9) || (self.month == 11))
        return 30;
    
    if((self.year % 4 == 1) || (self.year % 4 == 2) || (self.year % 4 == 3))
    {
        return 28;
    }
    
    if(self.year % 400 == 0)
        return 29;
    
    if(self.year % 100 == 0)
        return 28;
    
    return 29;
}

@end
