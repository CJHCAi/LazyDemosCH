//
//  LTSCalendarWeekView.m
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import "LTSCalendarWeekView.h"
#import "LTSCalendarDayView.h"
#import "LTSCalendarManager.h"


@interface LTSCalendarWeekView(){
    NSArray *daysViews;
    
}

@end
@implementation LTSCalendarWeekView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
        
        
    }
    return self;
}
- (void)commonInit{
    self.weekViewPlace = 0;
    
    NSMutableArray *views = [NSMutableArray new];
    
    for(int i = 0; i < 7; ++i){
        UIView *view = [LTSCalendarDayView new];
        
        [views addObject:view];
        [self addSubview:view];
    }
    
    daysViews = views;
}

- (void)layoutSubviews
{
   
    
    
        CGFloat x = 0;
        CGFloat width = self.frame.size.width / 7.;
        CGFloat height = self.frame.size.height;
        
        
        for(UIView *view in self.subviews){
            view.frame = CGRectMake(x, 0, width, height);
            x = CGRectGetMaxX(view.frame);
        }

    
    self.backgroundColor = self.calendarManager.calendarAppearance.backgroundColor;
    [super layoutSubviews];
    
    
}

- (void)setBeginningOfWeek:(NSDate *)date
{
    NSDate *currentDate = date;
    
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    
    for(LTSCalendarDayView *view in daysViews){
        
        NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:currentDate];
        NSInteger monthIndex = comps.month;
        
        [view setIsOtherMonth:monthIndex != self.currentMonthIndex];
        
        
        [view setDate:currentDate];
        
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.day = 1;
        
        currentDate = [calendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
    }
}

#pragma mark - LTSCalendarManager

- (void)setCalendarManager:(LTSCalendarManager *)calendarManager
{
    _calendarManager = calendarManager;
    
    for(LTSCalendarDayView *view in daysViews){
        [view setCalendarManager:calendarManager];
    }
}

- (void)reloadData
{
    for(LTSCalendarDayView *view in daysViews){
        [view reloadData];
    }
}

- (void)reloadAppearance
{
    for(LTSCalendarDayView *view in daysViews){
        [view reloadAppearance];
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *result = [super hitTest:point withEvent:event];
    self.calendarManager.contentView.scrollEnabled = YES;
    
    return result;
}






@end
