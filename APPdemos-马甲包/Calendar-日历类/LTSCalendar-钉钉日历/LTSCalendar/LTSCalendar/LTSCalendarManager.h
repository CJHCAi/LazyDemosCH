//
//  LTSCalendarManager.h
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSCalendarAppearance.h"
#import "LTSCalendarDataCache.h"
#import "LTSCalendarEventSource.h"
#import "LTSCalendarContentView.h"
#import "LTSCalendarWeekView.h"
#import "LTSCalendarMonthView.h"

#import "LTSCalendarWeekDayView.h"
#import "LTSCalendarSelectedWeekView.h"
#define WEEK_DAY_VIEW_HEIGHT 30
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define DarkText RGBCOLOR(23, 23, 23)
#define PrimaryText  RGBCOLOR(102, 102, 102)
#define lineBGColor RGBCOLOR(188, 186, 193);

@interface LTSCalendarManager : NSObject<UIScrollViewDelegate>


@property (nonatomic,strong)LTSCalendarContentView *contentView;

@property (nonatomic,weak) LTSCalendarWeekDayView *weekDayView;

@property (weak, nonatomic) id<LTSCalendarEventSource> eventSource;
//设置currentDate 用于 日历的显示
@property (strong, nonatomic) NSDate *currentDate;

@property (strong, nonatomic) NSDate *currentDateSelected;


/// 事件缓存
@property (strong, nonatomic, readonly) LTSCalendarDataCache *dataCache;
@property (nonatomic,strong,readonly) LTSCalendarAppearance *calendarAppearance;

//用于weekView 悬浮的属性
// 开始悬浮的 OriginY 根据上一个选中的日期而定
@property (nonatomic,assign)CGFloat startFrontViewOriginY;
//上一个选中的周  在 该月的位置
@property (assign,nonatomic) NSInteger lastSelectedWeekOfMonth;
//当前选中的周 在 该月的 位置
@property (assign,nonatomic) NSInteger currentSelectedWeekOfMonth;
//装载悬浮的容器   它的frame 根据 contentView 的frame 变化而变化   在 contentView的 setFrame 方法里
@property (nonatomic,weak) LTSCalendarSelectedWeekView *selectedWeekView;

/// 重新加载数据
- (void)reloadData;
/// 重新加载外观
- (void)reloadAppearance;

///  前一页。上个月
- (void)loadPreviousPage;
///   下一页 下一个月

- (void)loadNextPage;
///  重置位置
- (void)repositionViews;


- (NSInteger)getWeekFromDate:(NSDate *)date;

/// 将序号为多少的WeekView 放到SelectedWeekView 的里面
- (void)sendSubviewToSelectedWeekViewWithIndex:(NSInteger)index;

/// 将序号为多少的WeekView 放到回到monthView 的里面
- (void)sendSubviewToMonthViewWithIndex:(NSInteger)index;


- (void)setWeekViewHidden:(BOOL)hidden toIndex:(NSInteger)index;



@end
