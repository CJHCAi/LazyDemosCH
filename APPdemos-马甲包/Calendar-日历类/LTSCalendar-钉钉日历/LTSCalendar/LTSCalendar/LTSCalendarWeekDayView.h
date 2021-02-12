//
//  LTSCalendarWeekDayView.h
//  scrollTest
//
//  Created by leetangsong_macbk on 16/5/27.
//  Copyright © 2016年 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  LTSCalendarManager;
@interface LTSCalendarWeekDayView : UIView

@property (weak, nonatomic) LTSCalendarManager *calendarManager;


+ (void)beforeReloadAppearance;
- (void)reloadAppearance;
@end
