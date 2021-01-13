//
//  YCLockView.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/4.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCLockView.h"

@interface YCLockView ()

@end
@implementation YCLockView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    NSArray *arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDateComponents *comps = [self nowDateComponents];
    NSString *dateStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)comps.hour, (long)comps.minute];
    CGSize dateSize = [dateStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:75]}];
    NSString *monthStr = [NSString stringWithFormat:@"%ld月%ld日 %@",(long)comps.month,(long)comps.day,arrWeek[comps.weekday]];
    CGSize monthSize = [monthStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:20]}];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 1.0f);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    [dateStr drawAtPoint:CGPointMake((KSCREEN_WIDTH-dateSize.width)/2.f, 63) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:75],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [monthStr drawAtPoint:CGPointMake((KSCREEN_WIDTH-monthSize.width)/2.f, 159) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:20],NSForegroundColorAttributeName:[UIColor blackColor]}];
    CGContextSetTextDrawingMode(c, kCGTextFill);
    [dateStr drawAtPoint:CGPointMake((KSCREEN_WIDTH-dateSize.width)/2.f, 63) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:75],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [monthStr drawAtPoint:CGPointMake((KSCREEN_WIDTH-monthSize.width)/2.f, 159) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
#pragma mark - 获取年月日
- (NSDateComponents *)nowDateComponents
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:now];
    return comps;
}
@end
