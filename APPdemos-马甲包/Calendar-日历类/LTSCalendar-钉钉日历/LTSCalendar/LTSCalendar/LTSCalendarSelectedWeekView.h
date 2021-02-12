//
//  LTSCalendarSelectedWeekView.h
//  scrollTest
//
//  Created by leetangsong_macbk on 16/6/1.
//  Copyright © 2016年 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTSCalendarManager;

@interface LTSCalendarSelectedWeekView : UIScrollView

@property (nonatomic,strong)NSMutableArray *weekViews;

@property (weak, nonatomic) LTSCalendarManager *calendarManager;

@end
