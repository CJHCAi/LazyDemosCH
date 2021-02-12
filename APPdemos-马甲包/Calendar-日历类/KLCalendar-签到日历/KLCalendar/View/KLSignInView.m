//
//  KLSignInView.m
//  KLCalendar
//
//  Created by kai lee on 16/7/26.
//  Copyright © 2016年 kai lee. All rights reserved.
//

#import "KLSignInView.h"
#import "KLSignInModel.h"
#import "KLConst.h"

@interface KLSignInView ()
/* 积分 */
@property (weak, nonatomic) IBOutlet UIView *integrationsView;
/* 积分label */
@property (weak, nonatomic) IBOutlet UILabel *integrationsLb;

/* 当天 */
@property (weak, nonatomic) IBOutlet UILabel *currentDayLb;
/* 年月 */
@property (weak, nonatomic) IBOutlet UILabel *currentyearMonthLb;
/* 周几 */
@property (weak, nonatomic) IBOutlet UILabel *currentWeekLb;

/* 连续签到天数 */
@property (weak, nonatomic) IBOutlet UILabel *continuousDayLb;
/* 连续签到天数 */
@property (nonatomic, copy) NSString *continuous;
/* 用户日历上的当天 */
@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, assign, getter=isYesterdaySign) BOOL yesterdaySign;

@end


@implementation KLSignInView
- (void)setSignModel:(KLSignInModel *)signModel {
    _signModel = signModel;
    for (KLMonthSign *monthSignModel in signModel.monthSignArray) {
        NSDate *currentDate = [NSDate date]; // 当前时间
        NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:GTMzone];
        [dateFormat setLocale:[NSLocale currentLocale]];
        [dateFormat setDateFormat:@"yyyy-MM-d"];
        NSString *currentDateStr = [dateFormat stringFromDate:currentDate];
        
        //再获取的时间date减去24小时的时间（昨天的这个时候）
        NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
        NSString *yesterdayDateStr = [dateFormat stringFromDate:yesterdayDate];
        
        
        if ([monthSignModel.day isEqualToString:yesterdayDateStr]) {
            if ([monthSignModel.sign isEqualToString:@"1"]) {
                self.yesterdaySign = YES;
            } else {
                self.yesterdaySign = NO;
            }
        }
        if ([monthSignModel.day isEqualToString:currentDateStr]) {
            if ([monthSignModel.sign isEqualToString:@"1"]) {
                self.signInBtn.enabled  = NO;
                self.signInBtn.titleLabel.textColor = [UIColor whiteColor];
                self.signInBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:97/255.0 blue:96/255.0 alpha:1.0];
            }
        }
    }
    
    self.integrationsLb.text = [NSString stringWithFormat:@"积分：%@", signModel.integral];
    if (signModel.continuous.length >0) {
        self.continuousDayLb.text = [NSString stringWithFormat:@"已连续签到%@天", signModel.continuous];
        self.continuous = signModel.continuous;
    } else {
        self.continuousDayLb.text = nil;
    }
    
}
// 从xib加载初始化
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.frame = CGRectMake(0, 20, kUISCREENWIDTH, 136);
    // 适配
    CGRect r = CGRectZero;
    if (kUISCREENWIDTH == 320) {
        r = self.frame;
        r.size.width = 320;
        self.frame = r;
        
    } else if (kUISCREENWIDTH == 375) {
        r = self.frame;
        r.size.width = 375;
        self.frame = r;
    } else if (kUISCREENWIDTH == 414) {
        r = self.frame;
        r.size.width = 414;
        self.frame = r;
    }
    self.currentDate = [NSDate date];
    NSDateComponents *c = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.currentDate];
    // 显示当天
    self.currentDayLb.text = [NSString stringWithFormat:@"%ld", (long)c.day];
    // 显示当年月
    self.currentyearMonthLb.text = [NSString stringWithFormat:@"%ld-0%ld", (long)c.year, (long)c.month];
    // 显示当周
    self.currentWeekLb.text = [self weekdayStringFromDate:self.currentDate];
    // 连续签到天数
    self.continuousDayLb.text = [NSString stringWithFormat:@"已连续签到%@天", @"2"];
    
    // 签到按钮
    [self.signInBtn.layer setMasksToBounds:YES];
    [self.signInBtn.layer setCornerRadius:4.0]; //设置矩圆角半径
    [self.signInBtn.layer setBorderWidth:0.5];   //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    [self.signInBtn.layer setBorderColor:colorref];//边框颜色
    [self.signInBtn addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
    
    // 积分
    self.integrationsLb.text = [NSString stringWithFormat:@"积分：%@", @"200000"];
    
}
#pragma mark - privarte
- (NSString *)weekdayStringFromDate:(NSDate *)date {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/beijing"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
// 签到按钮
- (void)signIn {
    [self.signInBtn setEnabled:NO];
    self.signInBtn.titleLabel.textColor = [UIColor whiteColor];
    self.signInBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:97/255.0 blue:96/255.0 alpha:1.0];
    if ([self isYesterdaySign]) {
        self.continuousDayLb.text = [NSString stringWithFormat:@"已连续签到%d天", [self.continuous intValue]+1];
    } else {
        self.continuousDayLb.text = [NSString stringWithFormat:@"已连续签到%d天", 1];
    }
    
    !self.signInBlock ? NULL : self.signInBlock();
}
@end
