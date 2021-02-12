//
//  KLSICalendarViewController.m
//  KLCalendar
//
//  Created by kai lee on 16/7/26.
//  Copyright © 2016年 kai lee. All rights reserved.
//

#import "KLSICalendarViewController.h"
#import "KLSignInView.h"
#import "KLSICalendarView.h"
#import "KLSignInTool.h"
#import "KLConst.h"
#import "KLSignInModel.h"


@interface KLSICalendarViewController ()

@end


@interface KLSICalendarViewController ()
@property (nonatomic, strong) KLSignInView *signInView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) KLSICalendarView *calendarView;
@property (nonatomic, strong) NSMutableArray *signedArray;
// 日历
@end

@implementation KLSICalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 从xib加载视图
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"KLSignInView" owner:nil options:nil];
    KLSignInView *signInView = [nibView firstObject];
    signInView.backgroundColor = [UIColor orangeColor];
    
    self.signInView = signInView;
    [self.scrollView addSubview:self.signInView];
    
    // 日历
    [self loadCalendar];
    
    //网络请求数据
    [self requestData];
    
    WEAKSELF
    self.signInView.signInBlock = ^ {
        @try {
            //设置已经签到的天数日期
            NSDate *currentDate = [NSDate date]; // 当前时间
            NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setTimeZone:GTMzone];
            [dateFormat setLocale:[NSLocale currentLocale]];
            [dateFormat setDateFormat:@"yyyy-MM-d"];
            NSString *currentDateStr = [dateFormat stringFromDate:currentDate];
            int signedNum = [[currentDateStr substringFromIndex:8] intValue];
            
            [weakSelf.signedArray addObject:[NSNumber numberWithInt:signedNum]];
            weakSelf.calendarView.signArray = weakSelf.signedArray;
            weakSelf.calendarView.date = [NSDate date];
        } @catch (NSException *exception) {
            KLog(@"查看崩溃日志");
        } @finally {
            
        }
    };
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)loadCalendar {
    // 日历
    NSDate *currentDate = [NSDate date]; // 当前时间
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:GTMzone];
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setDateFormat:@"yyyy-MM-d"];
    NSInteger firstWeekday = [KLSignInTool firstWeekdayInThisMonth:currentDate];
    if (firstWeekday > 4) {
        self.calendarView.frame = CGRectMake(0, CGRectGetMaxY(self.signInView.frame), kUISCREENWIDTH, 414);
        self.calendarView.backgroundColor = [UIColor purpleColor];
        [self.scrollView addSubview:self.calendarView];
    } else {
        self.calendarView.frame = CGRectMake(0, CGRectGetMaxY(self.signInView.frame), kUISCREENWIDTH, 356);
        self.calendarView.backgroundColor = [UIColor systemPinkColor];
        [self.scrollView addSubview:self.calendarView];
    }
    
    
}
// 网络请求数据
- (void)requestData
{
    NSDictionary *data = @{
            @"weekday":@"2",
            @"monthSign":@[
                          @{
                              @"day":@"2016-07-01",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-02",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-03",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-04",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-05",
                              @"sig":@"0"
                          },
                          @{
                              @"day":@"2016-07-06",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-07",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-08",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-09",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-10",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-11",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-12",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-13",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-14",
                              @"sign":@"1"
                          },
                          @{
                              @"day":@"2016-07-15",
                              @"sign":@"1"
                          },
                          @{
                              @"day":@"2016-07-16",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-17",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-18",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-19",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-20",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-21",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-22",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-23",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-24",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-25",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-26",
                              @"sign":@"1"
                          },
                          @{
                              @"day":@"2016-07-27",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-28",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-29",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-30",
                              @"sign":@"0"
                          },
                          @{
                              @"day":@"2016-07-31",
                              @"sign":@"0"
                          }
                          ],
        @"continuous":@"1",
        @"month":@"2016-07",
        @"integral":@"1",
        @"currentDay":@"27"
        };
    @try {
        KLSignInModel *signInModel= [KLSignInModel dataWithSignInDict:data];
        
        // 上部
        _signInView.signModel = signInModel;
        self.signedArray = [NSMutableArray arrayWithCapacity:31];
        // 日历
        KLMonthSign *monthSignModel = [[KLMonthSign alloc] init];
        for (int i = 0; i<signInModel.monthSignArray.count; i++) {
            monthSignModel = signInModel.monthSignArray[i];
            
            NSString *numberStr = [monthSignModel.day substringFromIndex:8];
            int signedNum = [numberStr intValue];
            
            if ([monthSignModel.sign isEqualToString:@"1"]) {
                [self.signedArray addObject:[NSNumber numberWithInt:signedNum]];
            }
        }
        //设置已经签到的天数日期
        self.calendarView.signArray = self.signedArray;
        self.calendarView.date = [NSDate date];
        
    } @catch (NSException *exception) {
        KLog(@"查看崩溃日志");
    } @finally {
        
    }
}
#pragma mark - lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        [_scrollView setContentSize:CGSizeMake(kUISCREENWIDTH, kUISCREENHEIGHT + 64 +50+20)];
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, 1, 0)];
        _scrollView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}
- (KLSICalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[KLSICalendarView alloc] init];
    }
    return _calendarView;
}

@end
