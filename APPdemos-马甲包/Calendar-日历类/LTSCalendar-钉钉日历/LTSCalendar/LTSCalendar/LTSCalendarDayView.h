//
//  LTSCalendarDayView.h
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTSCalendarManager;
@interface LTSCalendarDayView : UIView

@property (nonatomic,weak)LTSCalendarManager *calendarManager;
@property (nonatomic,strong)NSDate *date;
@property (nonatomic,assign)BOOL isOtherMonth;

/// 重新加载数据
- (void)reloadData;
/// 重新加载外观
- (void)reloadAppearance;
@end
