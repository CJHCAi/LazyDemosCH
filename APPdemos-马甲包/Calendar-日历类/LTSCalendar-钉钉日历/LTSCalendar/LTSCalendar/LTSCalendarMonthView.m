//
//  LTSCalendarMonthView.m
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import "LTSCalendarMonthView.h"
#import "LTSCalendarWeekView.h"
#import "LTSCalendarManager.h"



@interface LTSCalendarMonthView(){
    
    
    NSUInteger currentMonthIndex;
    
}
@end
@implementation LTSCalendarMonthView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
        
        
       
    }
    return self;
}
- (void)commonInit{
    NSMutableArray *views = [NSMutableArray new];
    
    
    
    for(int i = 0; i < WEEKS_TO_DISPLAY; i++){
        UIView *view = [LTSCalendarWeekView new];
       
        
        [views addObject:view];
        [self addSubview:view];
        
        
    }
    _weeksViews = views;
}
- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    
    [super layoutSubviews];
    

    
}
- (void)configureConstraintsForSubviews
{    
    
    
    
    CGFloat width = self.frame.size.width;
    
//    CGFloat height = (self.frame.size.height) / WEEKS_TO_DISPLAY;
    CGFloat height = self.calendarManager.calendarAppearance.weekDayHeight;
    
    for(int i = 0; i < _weeksViews.count; i++){
        LTSCalendarWeekView *view = _weeksViews[i];
        view.frameInSelectedWeekView = CGRectMake(CGRectGetMinX(self.frame), i*height, width, height);
        
        view.frame = CGRectMake(0, i*height, width, height);
        
        view.frameInMonthView = view.frame;
        
        if (view.weekViewPlace == 1) {
            
            view.frame = view.frameInSelectedWeekView;
        }
        else if (view.weekViewPlace == 2) {
            view.frame = view.frameInMonthView;
        }
        
    }
    
    
    
    
}

- (void)setBeginningOfMonth:(NSDate *)date
{
    NSDate *currentDate = date;
   
   NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    
    
    {
        NSDateComponents *comps = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        
        currentMonthIndex = comps.month;
        
        //每月开始的第一天不是 1   则是上一个月的
        if(comps.day > 1){
            currentMonthIndex = (currentMonthIndex % 12) + 1;
            
        }
    }
    
    for(LTSCalendarWeekView *view in _weeksViews){
        view.currentMonthIndex = currentMonthIndex;
        [view setBeginningOfWeek:currentDate];
        
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.day = 7;
        
        currentDate = [calendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
        
        
    }
}
#pragma mark - LTSCalendarManager

- (void)setCalendarManager:(LTSCalendarManager *)calendarManager
{
    _calendarManager = calendarManager;
    
    for(LTSCalendarWeekView *view in _weeksViews){
        [view setCalendarManager:calendarManager];
    }
}

- (void)reloadData
{
    for(LTSCalendarWeekView *view in _weeksViews){
        [view reloadData];
        
    }
}

- (void)reloadAppearance
{
    
    for(LTSCalendarWeekView *view in _weeksViews){
        [view reloadAppearance];
    }
}





/// 将序号为多少的WeekView 放到SelectedWeekView 的里面
- (void)sendSubviewToSelectedWeekViewWithIndex:(NSInteger)index{
    for (NSInteger i = 0; i< index; i++) {
        LTSCalendarWeekView *weekView = self.weeksViews[i];
        
        self.calendarManager.startFrontViewOriginY = weekView.frame.origin.y;
        
        weekView.weekViewPlace = 1;
       
       [self.calendarManager.selectedWeekView insertSubview:weekView atIndex:999];
        
    }
   
}

/// 将序号为多少的WeekView 放到回到monthView 的里面
- (void)sendSubviewToMonthViewWithIndex:(NSInteger)index{
    for (NSInteger i = 0; i< index; i++) {
        LTSCalendarWeekView *weekView = self.weeksViews[i];
        
       
        weekView.weekViewPlace = 2;
        
        [self insertSubview:weekView atIndex:999];
        
    }

}

- (void)setWeekViewHidden:(BOOL)hidden toIndex:(NSInteger)index{
    
    for (NSInteger i = 0; i< index; i++) {
        LTSCalendarWeekView *weekView = self.weeksViews[i];
         weekView.hidden = hidden;
    }
    
}

@end
