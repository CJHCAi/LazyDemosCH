//
//  LocalTime.m
//  本地时间
//
//  Created by 谢丰泽 on 16/4/9.
//  Copyright © 2016年 Happy. All rights reserved.
//

#import "XFZ_LocalTime.h"

@interface XFZ_LocalTime ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *weerLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) NSString *seconds;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger secondBiao;
@end

@implementation XFZ_LocalTime


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatTime];
        [self timerAction];
        [self creatView];
    }
    return self;
}

- (void)creatTime {
    NSTimer *time = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:time forMode:NSRunLoopCommonModes];

    self.timer = time;
}

- (void)removeTimer {
    //将NSTimer释放
    [self.timer invalidate];
    //置空
    self.timer = nil;
}

- (void)creatView{

    self.label = [[UILabel alloc] init];
    self.label.frame = CGRectMake(10, 30, 70, 35);
    self.label.textColor = [UIColor whiteColor];
    
    self.weerLabel = [[UILabel alloc] init];
    self.weerLabel.frame = CGRectMake(70, 30, 100, 35);
    self.weerLabel.textColor = [UIColor whiteColor];
    
    self.secondLabel = [[UILabel alloc] init];
    self.secondLabel.frame = CGRectMake(20, 50, 100, 65);
    self.secondLabel.textColor = [UIColor whiteColor];
    
    
    self.label.font = [UIFont fontWithName:@"AmericanTypewriter" size:20];
    self.weerLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:20];
    self.secondLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:20];
    
    [self addSubview:self.secondLabel];
    [self addSubview:self.weerLabel];
    [self addSubview:self.label];
    [self timerAction];
    
}



- (void) timerAction {
    
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五", @"星期六", nil];
    NSDate *date = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [cal components:unitFlags fromDate:date];
    
    
    NSInteger month = comps.month;
    NSInteger day = comps.day;
    NSInteger week = comps.weekday;
    NSInteger minute = comps.minute;
    NSInteger hour = comps.hour;
    self.secondBiao = comps.second;
    
    
    NSString *monthDay = [NSString stringWithFormat:@"%ld / %ld",(long)month,(long)day];
    self.label.text = monthDay;
    
    //  星期几
    
    NSString *string=[NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week-1]];
    
    self.weerLabel.text = string;
    
    //时间second
    _seconds = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hour,(long)minute,(long)self.secondBiao];
    self.secondLabel.text = _seconds;
}


@end
