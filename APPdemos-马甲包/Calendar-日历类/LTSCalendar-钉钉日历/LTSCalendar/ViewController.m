//
//  ViewController.m
//  LTSCalendar
//
//  Created by 李棠松 on 2016/12/26.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import "ViewController.h"
#import "LTSCalendarView.h"
@interface ViewController ()<LTSCalendarEventSource,UITableViewDataSource,UITableViewDataSource>{
    NSMutableDictionary *eventsByDate;
}
@property (weak, nonatomic) IBOutlet UILabel *label;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRandomEvents];
    
  
}
- (void)lts_InitUI{
    [super lts_InitUI];
    self.calendarView.frame = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height-200);
}

// 该日期是否有事件
- (BOOL)calendarHaveEvent:(LTSCalendarManager *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    //
    return NO;
}
//当前 选中的日期  执行的方法
- (void)calendarDidDateSelected:(LTSCalendarManager *)calendar date:(NSDate *)date
{
    
    
    
    NSString *key = [[self dateFormatter] stringFromDate:date];
    self.label.text =  key;
    NSArray *events = eventsByDate[key];
    //    self.title = key;
    
    if (events.count>0) {
        
        //该日期有事件    tableView 加载数据
    }
    
}



- (IBAction)isShowLunar:(id)sender {
    self.calendarView.calendar.calendarAppearance.isShowLunarCalender = !self.calendarView.calendar.calendarAppearance.isShowLunarCalender;
   //重新加载外观
    
    [self.calendarView.calendar reloadAppearance];
    
}
- (IBAction)nextMonth:(id)sender {
    [self.calendarView.calendar loadNextPage];
}

- (IBAction)previousMonth:(id)sender {
    [self.calendarView.calendar loadPreviousPage];
}
- (IBAction)monday:(id)sender {
    self.calendarView.calendar.calendarAppearance.firstWeekday = 2;
    [self.calendarView.calendar reloadAppearance];
}
- (IBAction)sunday:(id)sender {
    self.calendarView.calendar.calendarAppearance.firstWeekday = 1;
    
    [self.calendarView.calendar reloadAppearance];
}
- (IBAction)full:(id)sender {
    self.calendarView.calendar.calendarAppearance.weekDayFormat = LTSCalendarWeekDayFormatFull;
    [self.calendarView.calendar reloadAppearance];
}
- (IBAction)fullShort:(id)sender {
    self.calendarView.calendar.calendarAppearance.weekDayFormat = LTSCalendarWeekDayFormatShort;
    [self.calendarView.calendar reloadAppearance];
}
- (IBAction)single:(id)sender {
    self.calendarView.calendar.calendarAppearance.weekDayFormat = LTSCalendarWeekDayFormatSingle;
    [self.calendarView.calendar reloadAppearance];
}


- (void)createRandomEvents
{
    eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        [eventsByDate[key] addObject:randomDate];
    }
    
}



@end
