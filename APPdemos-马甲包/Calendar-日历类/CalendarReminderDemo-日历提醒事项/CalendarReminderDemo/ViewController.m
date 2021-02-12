//
//  ViewController.m
//  CalendarReminderDemo
//
//  Created by Mr.Tai on 16/6/16.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//  日历提醒

#import "ViewController.h"
#import <EventKit/EventKit.h>

@interface ViewController ()
{
    EKEventStore *eventStore;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 150, 60);
    btn.layer.cornerRadius = 5;
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"提醒" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //事件库对象需要相对较大量的时间来初始化和释放,因此,应该在应用加载时,初始化一个事件库,然后反复地使用这一个来确保连接一直可用。
    eventStore = [[EKEventStore alloc] init];
}

- (void)saveEventStartDate:(NSDate*)startDate
                   endDate:(NSDate*)endDate
                     alarm:(float)alarm
                eventTitle:(NSString*)eventTitle
                  location:(NSString*)location
                isReminder:(BOOL)isReminder
{
    //写⼊入事件
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        __weak typeof(self)WeakSelf = self;
        /*
         等待用户授权访问:
         @param:EKEntityTypeEvent  日历
         @param:EKEntityTypeReminder  提醒事项
         */
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                if (error)
                                {
                                    NSLog(@"%@",error.localizedDescription);
                                }
                                else
                                    if (!granted)
                                    {
                                        //被⽤户拒绝,不允许访问日历
                                        NSLog(@"用户不允许访问日历");
                                    }
                                    else
                                    {
                                        //是否写入提醒事项，提醒事项为iOS原生自带的，但是模拟器没有
                                        if (isReminder)
                                        {
                                            EKCalendar * iDefaultCalendar = [eventStore defaultCalendarForNewReminders];
                                            EKReminder *reminder=[EKReminder reminderWithEventStore:eventStore];
                                            reminder.calendar=[eventStore defaultCalendarForNewReminders];
                                            reminder.title=eventTitle;
                                            reminder.calendar = iDefaultCalendar;
                                            EKAlarm *alarm=[EKAlarm alarmWithAbsoluteDate:[NSDate dateWithTimeIntervalSinceNow:-10]];
                                            [reminder addAlarm:alarm];
                                            
                                            NSError *error=nil;
                                            [eventStore saveReminder:reminder commit:YES error:&error];
                                            if (!error)
                                            {
                                                NSLog(@"error=%@",error.localizedDescription);
                                            }
                                        }
                                        else
                                        {
                                            if(startDate && endDate)
                                            {
                                                [WeakSelf deleteInsertedEvent];
                                                //根据开始时间和结束时间创建谓词
                                                NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
                                                if(predicate)
                                                {
                                                    //根据谓词条件筛选已插入日历的事件
                                                    NSArray *eventsArray = [eventStore eventsMatchingPredicate:predicate];
                                                    if (eventsArray.count)
                                                    {
                                                        for (EKEvent *item in eventsArray)
                                                        {
                                                            //根据事件的某个唯一性，如果已插入日历就不再插入
                                                            if([item.title isEqualToString:eventTitle])
                                                            {
                                                                return ;
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            //创建事件
                                            EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                                            //主标题
                                            event.title = eventTitle;
                                            //副标题
                                            event.location = location;
                                            //事件设定为全天事件
                                            event.allDay = NO;
                                            //设定事件开始时间
                                            event.startDate=startDate;
                                            //设定事件结束时间
                                            event.endDate=endDate;
                                            //设定URL,点击可打开对应的app:AAA为某应用对外访问的入口
                                            event.URL = [NSURL URLWithString:@"AAA://https://www.baidu.com"];
                                            //添加提醒,可以添加多个
                                            //设定事件在开始时间多久前开始提醒
                                            [event addAlarm:[EKAlarm alarmWithRelativeOffset:alarm]];
                                            event.calendar = [eventStore defaultCalendarForNewEvents];
                                            NSError *error;
                                            [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
                                            if (!error)
                                            {
                                                UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示"
                                                                     message:@"设置提醒成功！"
                                                          preferredStyle:UIAlertControllerStyleAlert];
                                                [alertvc addAction:[UIAlertAction
                                                   actionWithTitle:@"确定"
                                                             style:UIAlertActionStyleCancel
                                                           handler:nil]];
                                                [self presentViewController:alertvc animated:YES completion:nil];
                                            }
                                        }
                                    }
                            });
         }];
    }
}

- (void)btnAction:(UIButton *)sender
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:20];
    NSDate *endDate   = [NSDate dateWithTimeIntervalSinceNow:300];
    [self saveEventStartDate:startDate endDate:endDate alarm:-5 eventTitle:@"6元优惠券即将到期" location:@"尊敬的用户，您有一张6元优惠券即将到期！（详情以优惠券中心实际展示为准）" isReminder: NO];
}

//! 删除之前插入的事件
- (void)deleteInsertedEvent
{
    BOOL isClear = [[NSUserDefaults standardUserDefaults]boolForKey:@"CLEAR"];
    if(!isClear)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSDate *startDate = [formatter dateFromString:@"20170101000000"];
        NSDate *endDate = [formatter dateFromString:@"20171231235959"];
        NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
        NSArray *eventsArray = [eventStore eventsMatchingPredicate:predicate];
        if (eventsArray.count)
        {
            for (EKEvent *item in eventsArray)
            {
                NSRange range = [item.title rangeOfString:@"即将到期"];
                if(range.location != NSNotFound)
                {
                    //删除老版本插入的提醒
                    [eventStore removeEvent:item span:EKSpanThisEvent commit:YES error:nil];
                }
            }
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CLEAR"];
        }
    }
}

@end
