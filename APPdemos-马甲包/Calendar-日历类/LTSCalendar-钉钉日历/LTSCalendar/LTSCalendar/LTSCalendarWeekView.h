//
//  LTSCalendarWeekView.h
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,LTSCalendarWeekViewPlace){
    LTSCalendarWeekViewPlaceNormal = 0,
    LTSCalendarWeekViewPlaceSelectedWeekView,
    LTSCalendarWeekViewPlaceMonthView
};

@class LTSCalendarManager;
@interface LTSCalendarWeekView : UIView<NSCopying>


@property (nonatomic,assign)LTSCalendarWeekViewPlace weekViewPlace;

@property (nonatomic,weak)LTSCalendarManager *calendarManager;
@property (assign, nonatomic) NSUInteger currentMonthIndex;

@property (nonatomic,assign) CGRect frameInSelectedWeekView;

@property (nonatomic,assign) CGRect frameInMonthView;
- (void)setBeginningOfWeek:(NSDate *)date;
/// 重新加载数据
- (void)reloadData;
/// 重新加载外观
- (void)reloadAppearance;


@end
