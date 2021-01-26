//
//  KLSICalendarView.m
//  KLCalendar
//
//  Created by kai lee on 16/7/26.
//  Copyright © 2016年 kai lee. All rights reserved.
//

#import "KLSICalendarView.h"
#import "KLSignInTool.h"
#import "KLConst.h"

@interface KLSICalendarView ()

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) NSMutableArray *daysArray;

@end

@implementation KLSICalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            UIButton *button = [[UIButton alloc] init];
            [self addSubview:button];
            [_daysArray addObject:button];
            self.backgroundColor = [UIColor whiteColor];
        }
        
        for (int i = 0; i<6; i++) {
            UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, i*64+35, kUISCREENWIDTH, 0.5)];
            
            separateLine.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
            [self addSubview:separateLine];
        }
    }
    return self;
}

#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    
    [self createCalendarViewWith:date];
}

- (void)createCalendarViewWith:(NSDate *)date{
    
    CGFloat itemW     = self.frame.size.width / 7;
    CGFloat itemH     = 64;
    
    // 周
    NSArray *array = @[@"S", @"M", @"T", @"W", @"T", @"F", @"S"];
    UIView *weekBg = [[UIView alloc] init];
    weekBg.backgroundColor = [UIColor whiteColor];
    weekBg.frame = CGRectMake(0, 0, self.frame.size.width, 35);
    [self addSubview:weekBg];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:10];
        week.textColor = [UIColor blackColor];
        week.frame    = CGRectMake(itemW * i, 20, itemW, 10);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        if (i == 0 || i == 6) {
            week.textColor = [UIColor colorWithRed:255/255.0 green:97/255.0 blue:96/255.0 alpha:1.0];
        }
        [weekBg addSubview:week];
    }
    
    // 天 (1-31)
    CGFloat btnW = 30;
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW + (itemW-btnW)*0.5;
        int y = (i / 7) * itemH + CGRectGetMaxY(weekBg.frame) + (64-btnW)*0.5;
        
        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x, y, btnW, btnW);
        dayButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dayButton.layer.cornerRadius = btnW*0.5;
        
        NSInteger daysInLastMonth = [KLSignInTool totaldaysInMonth:[KLSignInTool lastMonth:date]];
        NSInteger daysInThisMonth = [KLSignInTool totaldaysInMonth:date];
        NSInteger firstWeekday    = [KLSignInTool firstWeekdayInThisMonth:date];
        self.falg = firstWeekday;
        NSInteger day = 0;
        
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyleNotThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyleNotThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyleAfterToday:dayButton];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%ld", (long)day] forState:UIControlStateNormal];
        
        // 当月
        if ([KLSignInTool month:date] == [KLSignInTool month:[NSDate date]]) {
            
            NSInteger todayIndex = [KLSignInTool day:date] + firstWeekday - 1;
            
            if (i <= todayIndex && i >= firstWeekday) {
                [self setStyleBeforeToday:dayButton];
                [self setSign:i andBtn:dayButton];
            }
        }
    }
}


#pragma mark 设置已经签到
- (void)setSign:(int)i andBtn:(UIButton*)dayButton{
    WEAKSELF;
    [_signArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int now = i-(int)weakSelf.falg+1;
        int now2 = [obj intValue];
        if (now2 == now) {
            [weakSelf setStyleSigned:dayButton];
            *stop = YES;
            
        }
    }];
}

#pragma mark - 设置按钮style
//设置不是本月的日期字体颜色 - 不可见
- (void)setStyleNotThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

//这个月 今日之前的日期style
- (void)setStyleBeforeToday:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


//今日已签到
- (void)setStyleTodaySigned:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:96/255.0 alpha:1.0]];
}

//今日没签到
- (void)setStyleTodayUnSigned:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
}

//这个月 今天之后的日期style
- (void)setStyleAfterToday:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


//已经签过的 日期style
- (void)setStyleSigned:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [btn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:96/255.0 alpha:1.0]];
}

@end
