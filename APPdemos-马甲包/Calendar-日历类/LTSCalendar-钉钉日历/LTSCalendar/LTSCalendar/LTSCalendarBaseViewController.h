//
//  LTSCalendarBaseViewController.h
//  LTSCalendar
//
//  Created by 李棠松 on 2016/12/28.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCalendarView.h"
@interface LTSCalendarBaseViewController : UIViewController

@property (nonatomic,strong)LTSCalendarView *calendarView;



- (void)lts_InitUI;
- (NSDateFormatter *)dateFormatter;
@end
