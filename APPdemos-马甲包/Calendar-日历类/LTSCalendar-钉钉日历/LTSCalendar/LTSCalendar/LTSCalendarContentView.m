//
//  LTSCalendarContentView.m
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import "LTSCalendarContentView.h"
#import "LTSCalendarWeekView.h"
#import "LTSCalendarMonthView.h"
#import "LTSCalendarManager.h"

#define NUMBER_PAGES_LOADED 5
@implementation LTSCalendarContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit
{
    _monthsViews = [NSMutableArray new];
    self.userInteractionEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.clipsToBounds = YES;
    
    for(int i = 0; i < NUMBER_PAGES_LOADED; ++i){
        LTSCalendarMonthView *monthView = [LTSCalendarMonthView new];
        [self addSubview:monthView];
       
        
        [_monthsViews addObject:monthView];
    }

    self.contentSize = CGSizeMake(self.frame.size.width*NUMBER_PAGES_LOADED, self.frame.size.height);

}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGRect selectedWeekViewFrame = self.calendarManager.selectedWeekView.frame;
    selectedWeekViewFrame.origin.y = frame.origin.y;
    self.calendarManager.selectedWeekView.frame = selectedWeekViewFrame;
    
}
- (void)layoutSubviews

{
    
    [self configureConstraintsForSubviews];
    
    [super layoutSubviews];
    self.contentSize = CGSizeMake(self.frame.size.width*NUMBER_PAGES_LOADED, self.frame.size.height);

    
    
}

- (void)configureConstraintsForSubviews
{
    self.contentOffset = CGPointMake(self.contentOffset.x, 0);
    
    CGFloat x = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    
    
    for(UIView *view in _monthsViews){
        
       
        
        view.frame = CGRectMake(x, 0, width, height);
        x = CGRectGetMaxX(view.frame);
    }
    self.contentSize = CGSizeMake(width * NUMBER_PAGES_LOADED, height);
}

- (void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;

    for(int i = 0; i < NUMBER_PAGES_LOADED; i++){
        LTSCalendarMonthView *monthView = _monthsViews[i];
        
        NSDateComponents *dayComponent = [NSDateComponents new];
        
        
        dayComponent.month = i - (NUMBER_PAGES_LOADED / 2);
        //当前日期前两个月  与  后两个月
        NSDate *monthDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
        
        monthDate = [self beginningOfMonth:monthDate];
        [monthView setBeginningOfMonth:monthDate];
    
    }
    
}
/**
 *  返回该日期月数第一周开始的第一天
 *
 *  @param date  date
 *
 *  @return date
 */
- (NSDate *)beginningOfMonth:(NSDate *)date{
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    
    NSDateComponents *componentsCurrentDate =[calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = 1;
    componentsNewDate.weekday = calendar.firstWeekday;
    
    return [calendar dateFromComponents:componentsNewDate];
    
}

#pragma mark - LTSCalendarManager

- (void)setCalendarManager:(LTSCalendarManager *)calendarManager
{
    _calendarManager = calendarManager;
    
    for(LTSCalendarMonthView *view in _monthsViews){
        [view setCalendarManager:calendarManager];
    }
}
- (void)reloadData
{
    for(LTSCalendarMonthView *monthView in _monthsViews){
        [monthView reloadData];
    }
}




/// 将序号为多少的WeekView 放到SelectedWeekView 的里面
- (void)sendSubviewToSelectedWeekViewWithIndex:(NSInteger)index{
    for(LTSCalendarMonthView *monthView in _monthsViews){
        [monthView sendSubviewToSelectedWeekViewWithIndex:index];
    }
}

/// 将序号为多少的WeekView 放到回到monthView 的里面
- (void)sendSubviewToMonthViewWithIndex:(NSInteger)index{
    for(LTSCalendarMonthView *monthView in _monthsViews){
        [monthView sendSubviewToMonthViewWithIndex:index];
    }
}

- (void)setWeekViewHidden:(BOOL)hidden toIndex:(NSInteger)index{
    
    for(LTSCalendarMonthView *monthView in _monthsViews){
        [monthView setWeekViewHidden:hidden toIndex:index];
    }

    
}

- (void)reloadAppearance
{
    // Fix when change mode during scroll
    self.scrollEnabled = YES;
    
    for(LTSCalendarMonthView *monthView in _monthsViews){
        [monthView reloadAppearance];
    }
}














@end
