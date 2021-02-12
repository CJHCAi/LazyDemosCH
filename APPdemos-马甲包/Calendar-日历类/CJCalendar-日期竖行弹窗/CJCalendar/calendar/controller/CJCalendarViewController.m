//
//  CJMainViewController.m
//  CJCalendar
//
//  Created by chjsun on 16/5/23.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import "CJCalendarViewController.h"

#import "CJShowTimeView.h"
#import "CJSelectTimeScrollView.h"
#import "CJDecisionView.h"

#import "CJUseTime.h"

#define CJColor(r, g, b) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1])

#define CJEdgeWidth 40
#define CJEdgeHeight 50

/**
 概览：
 总共整个控件分为四个部分  1，a:头部，主要显示全部时间内容，通常显示阳历对应的中国农历时间
                       2，b:年月日板 主要显示年月日和控制选择年月日的视图
                       3，c:选择板，用来选择年或者月日
                       4，d:控制板，主要是将选择的数据返回给调用者，基本有三个按钮(今日), (取消), (确定)
 计算：
    注：h是需要显示的大小，一般是整个屏幕去掉自定义的edge，即h = width - 2 * CJEdgeHeight
        1: 22 p
        2: 3/8 * h - 33 + 22 p
        3: h/2
        4: h/8 - 11
    计算思路: 1, 头部固定大小22
            2, 选择板占整个可视界面的1/2
            3, 三个控制板＋一个头部＝年月日板
 
 */

@interface CJCalendarViewController ()<ShowTimeViewDelegate, DecisionDelegate, SelectTimeScrollViewDelegate>

/** 记录高度 */
@property (nonatomic, assign) CGFloat viewHeight;

/** timeView */
@property (nonatomic, strong) CJShowTimeView *timeView;
/** selectController */
@property (nonatomic, strong) CJSelectTimeScrollView *selectScrollView;
/** 操作时间 */
@property (nonatomic, strong) CJUseTime *useTime;
/** 背景 */
@property (nonatomic, weak) UIView *bgView;

@end

@implementation CJCalendarViewController

-(instancetype)init{

    if (self = [super init]) {
        self.view.frame = [UIScreen mainScreen].bounds;
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        self.Date = [NSDate dateWithTimeIntervalSinceNow:zone.secondsFromGMT];
    }
    
    return self;
}

-(CJShowTimeView *)timeView{
    if (!_timeView) {
        CGFloat timeRectWidth = self.view.bounds.size.width - 2 * CJEdgeWidth;
        // (3/8 * h - 33 + 22) + (22) === (a+b)
        
        CGFloat timeRectHeight = (self.view.bounds.size.height - 2 * CJEdgeHeight) * 3 / 8 + 11;
        self.viewHeight += timeRectHeight;
        
        CGRect rect = CGRectMake(CJEdgeWidth, CJEdgeHeight, timeRectWidth, timeRectHeight);
        _timeView = [[CJShowTimeView alloc] initWithFrame:rect];
        _timeView.delegate = self;
    }
    return _timeView;
}

-(CJSelectTimeScrollView *)selectScrollView{
    if (!_selectScrollView) {
        _selectScrollView = [[CJSelectTimeScrollView alloc] init];
        _selectScrollView.delegates = self;
        _selectScrollView.scrollEnabled = NO;
    }
    return _selectScrollView;
}

-(CJUseTime *)useTime{
    if (!_useTime) {
//        _useTime = [[CJUseTime alloc] init];
        _useTime = [CJUseTime sharedInstance];
    }
    return _useTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置半透明背景
    [self setBackgroundView];
    // 设置showTime
    [self setShowTimeView];
    // 设置选择板
    [self setSelectTime];
    // 设置控制板
    [self setDecision];
    
}

// 即将显示的时候，做一下初始化操作
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 初始化时将控制器跳转到指定时间
    self.selectScrollView.year = self.timeView.yearText;
}

// set background alpha
// 设置背景
-(void) setBackgroundView{
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
    self.bgView = bgView;
    // 默认颜色及透明度
    bgView.backgroundColor = CJColor(29, 29, 29);
    bgView.alpha = 0.8;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }else{
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [self.view addSubview:bgView];
}

// ser showTimeView
// 设置在日历上方的头部显示面板
-(void) setShowTimeView{
    [self.timeView generateView];
    
    [self.view addSubview:self.timeView];
}

// set selectView
// 设置日历选择面板
-(void) setSelectTime{
    
    CGFloat selectWidth = self.view.bounds.size.width - 2 * CJEdgeWidth;
    // (h - 2*edge)/2
    CGFloat selectHeight = (self.view.bounds.size.height - 2 * CJEdgeHeight)/2;
    CGRect selectRect = CGRectMake(CJEdgeWidth, CJEdgeHeight + self.viewHeight, selectWidth, selectHeight);
    self.viewHeight += selectHeight;
    
    self.selectScrollView.frame = selectRect;
    //设置scrollview的属性
    self.selectScrollView.contentSize = CGSizeMake(selectWidth * 2, selectHeight);
    self.selectScrollView.pagingEnabled = YES;
    self.selectScrollView.showsHorizontalScrollIndicator = FALSE;
    //设置所有的子控制器
    [self.selectScrollView setUpAllControllerWithSuperControll:self];
    
    [self.view addSubview:self.selectScrollView];
    
}

// set decisionView
// 设置最后的按钮
-(void) setDecision{
    CGFloat selectWidth = self.view.bounds.size.width - 2 * CJEdgeWidth;
    // h/8 - 11
    CGFloat selectHeight = (self.view.bounds.size.height - 2 * CJEdgeHeight) / 8 - 11;
    CGRect rect = CGRectMake(CJEdgeWidth, CJEdgeHeight + self.viewHeight, selectWidth, selectHeight);
    
    CJDecisionView *decisionView = [[CJDecisionView alloc] initWithFrame:rect];
    decisionView.backgroundColor = [UIColor whiteColor];
    [decisionView generateDecision];
    decisionView.delegate = self;
    
    [self.view addSubview:decisionView];
}


#pragma mark - showViewDelegate 具体日历上方的时间显示区代理
// 头部 月 日 -- 代理
-(void)ShowTimeView:(CJShowTimeView *)timeView didSelectYear:(NSString *)year Month:(NSString *)month day:(NSString *)day{
    [self.selectScrollView refreshControlWithYear:year month:month day:day];
    [self setBoundsToScrollView:0];
}
// 头部 年 -- 代理
-(void)ShowTimeView:(CJShowTimeView *)timeView didSelectYear:(NSString *)year{
    self.selectScrollView.year = year;
    [self setBoundsToScrollView:1];
}

-(void) setBoundsToScrollView:(CGFloat)tag{

    CGFloat selectWidth = self.view.bounds.size.width - 2 * CJEdgeWidth;
    // (h - 2*edge)/2
    CGFloat selectHeight = (self.view.bounds.size.height - 2 * CJEdgeHeight)/2;
    self.selectScrollView.bounds = CGRectMake(selectWidth * tag, 0, selectWidth, selectHeight);

}
#pragma mark - 选择日历面板控制器的代理
// 年份选择
-(void)selectTimeView:(CJSelectTimeScrollView *)timeScroll didSelectYearAtIndexPath:(NSIndexPath *)indexPath cellText:(NSString *)cellText{
    
    NSString *gregorainToChinese;
    
    // 判断是不是2月29号   初步将2/29 转换为2/28
    BOOL is2M29D = (([self.timeView.monthText isEqualToString:@"02"] || [self.timeView.monthText isEqualToString:@"2"]) && [self.timeView.dayText isEqualToString:@"29"]);
    
    if (is2M29D) {
        gregorainToChinese = [self.useTime timeChineseCalendarWithString:[NSString stringWithFormat:@"%@-%@-%li",cellText, self.timeView.monthText, [self.timeView.dayText integerValue] - 1]];
        self.timeView.dayText = @"28";
        
    }else{
        gregorainToChinese = [self.useTime timeChineseCalendarWithString:[NSString stringWithFormat:@"%@-%@-%@",cellText, self.timeView.monthText, self.timeView.dayText]];
    }
    
    self.timeView.headerName = gregorainToChinese;
    self.timeView.yearText = cellText;
    
}

// 月份选择
-(void)selectTimeView:(CJSelectTimeScrollView *)timeScroll didSelectMonthAndDayAtIndexPath:(NSIndexPath *)indexPath GregoiainCalendar:(NSString *)gregoiainCalendar chineseCalendar:(NSString *)chineseCalendar{
    
    NSArray *calendar = [gregoiainCalendar componentsSeparatedByString:@"-"];
    
    self.timeView.headerName = chineseCalendar;
    self.timeView.monthText = calendar[1];
    self.timeView.dayText = calendar[2];
    self.timeView.yearText = calendar[0];

}


#pragma mark - 控制板按钮
// 确定
-(void)DecisionDidSelectAction:(CJDecisionView *)decision{
    if ([self.delegate respondsToSelector:@selector(CalendarViewController:didSelectActionYear:month:day:)]) {
        // 代理传值， 将年月日信息传递给调用者
        [self.delegate CalendarViewController:self didSelectActionYear:self.timeView.yearText month:self.timeView.monthText day:self.timeView.dayText];
        
        // dismiss 该控制器
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
// 取消
-(void)DecisionDidSelectCancel:(CJDecisionView *)decision{
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 今日
-(void)DecisionDidSelectNow:(CJDecisionView *)decision{
    self.Date = [NSDate dateWithTimeIntervalSinceNow:[NSTimeZone systemTimeZone].secondsFromGMT];
}

#pragma mark - 本类对外的操作

// 设置指定时间

-(void)setDate:(NSDate *)Date{
    _Date = Date;
    [self setCustomDate:Date];
}

-(void)setCustomDate:(NSDate *)Date{
    NSArray *calendar = [[self.useTime dataToString:Date] componentsSeparatedByString:@"-"];
    
    self.timeView.headerName = [self.useTime timeChineseCalendarWithDate:Date];
    self.timeView.monthText = calendar[1];
    self.timeView.dayText = calendar[2];
    self.timeView.yearText = calendar[0];
    [self.selectScrollView refreshControlWithYear:calendar[0] month:calendar[1] day:calendar[2]];
    

}
// 设置指定年月日
-(void)setYear:(NSString *)year month:(NSString *)month day:(NSString *)day{
    NSDate *date = [self.useTime strToDate:[NSString stringWithFormat:@"%@-%@-%@", year? year: @1970, month? month: @1970, day? day: @1970]];

    self.Date = date;
}

#pragma mark - 设置扩展属性  颜色

- (void)setHeaderColor:(UIColor *)headerColor{
    _headerColor = headerColor;
    self.timeView.headerColor = headerColor;
}

-(void)setHeaderBackgroundColor:(UIColor *)headerBackgroundColor{
    _headerBackgroundColor = headerBackgroundColor;
    self.timeView.headerBackgroundColor = headerBackgroundColor;
}

- (void)setContentColor:(UIColor *)contentColor{
    _contentColor = contentColor;
    self.timeView.contentColor = contentColor;

}

- (void)setContentBackgroundColor:(UIColor *)contentBackgroundColor{
    _contentBackgroundColor = contentBackgroundColor;
    self.timeView.contentBackgroundColor = contentBackgroundColor;
    self.selectScrollView.selectYearColor = contentBackgroundColor;
    self.selectScrollView.selectMonthDayColor = contentBackgroundColor;
}

-(void)setBgAlpha:(CGFloat)alpha color:(UIColor *)bgColor{
    self.bgView.alpha = alpha;
    self.bgView.backgroundColor = bgColor;
}

@end
