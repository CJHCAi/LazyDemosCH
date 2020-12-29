//
//  JTCalendarMenuView.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

@class JTCalendar;

@interface JTCalendarMenuView : UIScrollView

@property (weak, nonatomic) JTCalendar *calendarManager;
//@property (weak, nonatomic) NSMutableArray *monthsViews;
@property (strong, nonatomic) NSDate *currentDate;
-(NSMutableArray *)getViews;
- (void)reloadAppearance;

@end
