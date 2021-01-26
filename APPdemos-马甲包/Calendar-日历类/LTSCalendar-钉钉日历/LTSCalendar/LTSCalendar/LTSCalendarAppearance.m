//
//  LTSCalendarAppearance.m
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//  日历外观样式

#import "LTSCalendarAppearance.h"
#import "LTSCalendarManager.h"

@implementation LTSCalendarAppearance

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}
- (void)setFirstWeekday:(NSInteger)firstWeekday{
    _firstWeekday = firstWeekday;
    self.calendar.firstWeekday = firstWeekday;
}

- (void)setDefaultValues{
    self.dayCircleSize = 40;
    self.dayDotSize= self.dayCircleSize*1. / 9. ;
    self.weekDayFormat = LTSCalendarWeekDayFormatSingle;
    self.weekDayTextFont = [UIFont systemFontOfSize:11];
     self.weekDayTextColor = [UIColor colorWithRed:200./256. green:200./256. blue:200./256. alpha:1.];
    
    self.weekDayHeight = 50;
    
    self.dayTextFont = [UIFont systemFontOfSize:16];
    self.lunarDayTextFont =[UIFont systemFontOfSize:10];
    
    [self setDayDotColorForAll:[UIColor colorWithRed:43./256. green:88./256. blue:134./256. alpha:1.]];
    [self setDayTextColorForAll:[UIColor whiteColor]];
    
   
    self.dayTextColor = [UIColor whiteColor];
    self.lunarDayTextColor = [UIColor whiteColor];
    
    self.dayTextColorOtherMonth  = [UIColor colorWithRed:152./256. green:147./256. blue:157./256. alpha:1.];
    self.lunarDayTextColorOtherMonth = [UIColor colorWithRed:152./256. green:147./256. blue:157./256. alpha:1.];
    
    self.dayTextColorSelected = [UIColor whiteColor];
    self.lunarDayTextColorSelected = [UIColor whiteColor];
    
    
    self.dayBorderColorToday = [UIColor colorWithRed:133./256. green:205./256. blue:243./256. alpha:1.];
    self.dayCircleColorSelected  = [UIColor colorWithRed:133./256. green:205./256. blue:243./256. alpha:1.];
    
    self.dayTextColorToday = [UIColor whiteColor];
    self.dayDotColor = [UIColor whiteColor];
  
    self.dayDotColorSelected = [UIColor whiteColor];
    
    
    
    self.backgroundColor = [UIColor grayColor];
    self.isShowLunarCalender = YES;
}

- (NSCalendar *)calendar
{
    static NSCalendar *calendar;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
#ifdef __IPHONE_8_0
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
        calendar.timeZone = [NSTimeZone localTimeZone];
    });
    
    return calendar;
}
- (NSCalendar *)chineseCalendar{
    static NSCalendar *calendar;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
#ifdef __IPHONE_8_0
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
#else
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
#endif
        calendar.timeZone = [NSTimeZone localTimeZone];
    });
    
    return calendar;
}

- (void)setDayDotColorForAll:(UIColor *)dotColor
{
    self.dayDotColor = dotColor;
//    self.dayDotColorSelected = dotColor;
    
//    self.dayDotColorOtherMonth = dotColor;
//    self.dayDotColorSelectedOtherMonth = dotColor;
    
    
//    self.dayDotColorTodayOtherMonth = dotColor;
}

- (void)setDayTextColorForAll:(UIColor *)textColor
{
    self.dayTextColor = textColor;
    self.dayTextColorSelected = textColor;
    self.lunarDayTextColor = textColor;
    self.lunarDayTextColorSelected = textColor;
    
    self.dayTextColorOtherMonth = textColor;
    self.lunarDayTextColorOtherMonth = textColor;
//    self.dayTextColorSelectedOtherMonth = textColor;
    
    self.dayTextColorToday = textColor;
//    self.dayTextColorTodayOtherMonth = textColor;
}

@end
