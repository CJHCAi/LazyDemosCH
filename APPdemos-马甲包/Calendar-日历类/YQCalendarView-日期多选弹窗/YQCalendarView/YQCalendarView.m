//
//  YQCalendarView.m
//  calendarDemo
//
//  Created by problemchild on 16/8/22.
//  Copyright © 2016年 ProblenChild. All rights reserved.
//
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenScaleWidthWith6(x)   (kScreenWidth/375 * x)
#define kScreenScaleHeightWith6(x)  (kScreenHeight/667 * x)
#define kViewWidth(v)            v.frame.size.width
#define kViewHeight(v)           v.frame.size.height
#define kViewX(v)                v.frame.origin.x
#define kViewY(v)                v.frame.origin.y
#define kViewMaxX(v)             (v.frame.origin.x + v.frame.size.width)
#define kViewMaxY(v)             (v.frame.origin.y + v.frame.size.height)
#define kRectX(f)                f.origin.x
#define kRectY(f)                f.origin.y
#define kRectWidth(f)            f.size.width
#define kRectHeight(f)           f.size.height
#define kRectSetWidth(f, w)      CGRectMake(kRectX(f), kRectY(f), w            , kRectHeight(f))
#define kRectSetHeight(f, h)     CGRectMake(kRectX(f), kRectY(f), kRectWidth(f), h             )
#define kRectSetX(f, x)          CGRectMake(x        , kRectY(f), kRectWidth(f), kRectHeight(f))
#define kRectSetY(f, y)          CGRectMake(kRectX(f), y        , kRectWidth(f), kRectHeight(f))
#define kRectSetSize(f, w, h)    CGRectMake(kRectX(f), kRectY(f), w            , h             )
#define kRectSetOrigin(f, x, y)  CGRectMake(x        , y        , kRectWidth(f), kRectHeight(f))
#define kRect(x, y, w, h)        CGRectMake(x        , y        , w            , h             )

#define kBTNsetAction(btn,function) [btn addTarget:self action:@selector(function) forControlEvents:UIControlEventTouchUpInside];

#import "YQCalendarView.h"

#import "YQCalendarEachDay.h"

@interface YQCalendarView ()

/**
 *  往前BTN
 */
@property (nonatomic,strong) UIButton *preBTN;

/**
 *  往后BTN
 */
@property (nonatomic,strong) UIButton *nextBTN;

/**
 *  日期标题Lable
 */
@property (nonatomic,strong) UILabel  *titleLab;

/**
 *  预加载的一页日历
 */
@property (nonatomic,strong) UIView   *preDayView;

/**
 *  当前显示的一页日历
 */
@property (nonatomic,strong) UIView   *dayView;

/**
 *  显示的年
 */
@property int showYear;
/**
 *  显示的月
 */
@property int showMonth;

@end

@implementation YQCalendarView


-(NSMutableArray *)selectedArray{
    if(!_selectedArray){
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
-(void)setSelectedArray:(NSArray *)array{
    _selectedArray = [NSMutableArray arrayWithArray:array];
    [self loadData];
}

-(UIColor *)titleColor{
    return _titleColor?_titleColor:[UIColor colorWithRed:0.208 green:0.643 blue:0.941 alpha:1.000];
}
-(void)setTitleColor:(UIColor *)color{
    _titleColor = color;
    self.titleLab.textColor = color;
}

-(UIFont *)titleFont{
    return _titleFont?_titleFont:[UIFont systemFontOfSize:17];
}
-(void)setTitleFont:(UIFont *)font{
    _titleFont = font;
    self.titleLab.font = font;
}

-(UIColor *)dayColor{
    return _dayColor?_dayColor:[UIColor blackColor];
}
-(void)setDayColor:(UIColor *)color{
    _dayColor = color;
    [self loadData];
}

-(UIFont *)dayFont{
    return _dayFont?_dayFont:[UIFont systemFontOfSize:17];
}
-(void)setDayFont:(UIFont *)font{
    _dayFont = font;
    [self loadData];
}

-(UIColor *)selectedBackColor{
    return _selectedBackColor?_selectedBackColor:[UIColor colorWithRed:0.863 green:0.867 blue:0.875 alpha:1.000];
}
-(void)setSelectedBackColor:(UIColor *)color{
    _selectedBackColor = color;
    [self loadData];
}

-(UIImage *)selectedIcon{
    return _selectedIcon?_selectedIcon:[UIImage imageNamed:@"icon_yiqiandao"];
}
-(void)setSelectedIcon:(UIImage *)img{
    _selectedIcon = img;
    [self loadData];
}

-(UIImage *)nextBTNIcon{
    return _nextBTNIcon?_nextBTNIcon:[UIImage imageNamed:@"icon_hou.png"];
}
-(void)setNextBTNIcon:(UIImage *)img{
    _nextBTNIcon = img;
    [self.nextBTN setImage:self.nextBTNIcon forState:UIControlStateNormal];
}

-(UIImage *)preBTNIcon{
    return _preBTNIcon?_preBTNIcon:[UIImage imageNamed:@"icon_qian.png"];
}
-(void)setPreBTNIcon:(UIImage *)img{
    _preBTNIcon = img;
    [self.preBTN setImage:self.preBTNIcon forState:UIControlStateNormal];
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self SetUp];
    
    return self;
}
/**
 *  初始化
 */
-(void)SetUp{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.masksToBounds = YES;
    
    //--------------------------------------------------
    self.preBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.preBTN setImage:self.preBTNIcon forState:UIControlStateNormal];
    self.preBTN.frame = CGRectMake(kScreenScaleWidthWith6(22),
                                   kScreenScaleWidthWith6(20),
                                   26,
                                   26);
    kBTNsetAction(self.preBTN, preMonth)
    [self addSubview:self.preBTN];
    
    //--------------------------------------------------
    self.nextBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextBTN setImage:self.nextBTNIcon forState:UIControlStateNormal];
    self.nextBTN.frame = CGRectMake(kViewWidth(self)-kScreenScaleWidthWith6(22)-26,
                                    kScreenScaleWidthWith6(20),
                                    26,
                                    26);
    kBTNsetAction(self.nextBTN, nextMonth)
    [self addSubview:self.nextBTN];
    
    //--------------------------------------------------
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(kViewX(self.preBTN)+
                                                             kViewWidth(self.preBTN),
                                                             kViewY(self.preBTN),
                                                             kViewWidth(self)-
                                                             kViewX(self.preBTN)-
                                                             kViewWidth(self.preBTN)-
                                                             (kViewWidth(self)-
                                                              kViewX(self.nextBTN)),
                                                             kViewHeight(self.preBTN))];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.text          = @"2015-12月";
    self.titleLab.textColor     = self.titleColor;
    self.titleLab.font          = self.titleFont;
    [self addSubview:self.titleLab];
    //--------------------------------------------------
    NSDate *date  = [NSDate date];
    NSDateFormatter *Yearformater = [NSDateFormatter new];
    Yearformater.dateFormat = @"yyyy";
    NSString *yearstr = [Yearformater stringFromDate:date];
    
    NSDateFormatter *Monthformater = [NSDateFormatter new];
    Monthformater.dateFormat = @"MM";
    NSString *monthstr = [Monthformater stringFromDate:date];
    
    self.titleLab.text = [NSString stringWithFormat:@"%@-%@月",yearstr,monthstr];
    
    self.showMonth = monthstr.intValue;
    self.showYear = yearstr.intValue;
    
    //--------------------------------------------------
    self.dayView = [[UIView alloc]init];
    self.preDayView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self loadData];
    
    [self addSubview:self.dayView];
    [self addSubview:self.preDayView];
    
    
    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(nextMonth)];
    swipe1.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipe1];
    
    UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(preMonth)];
    swipe2.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipe2];
}

/**
 *  加载某个月的显示
 *
 *  @param dayView 显示的View
 *  @param month   月
 *  @param year    年
 *  @param frame   位置
 */
-(void)setUpTheDayView:(UIView *)dayView
              ForMonth:(int)month
                  Year:(int)year
              andFrame:(CGRect)frame
{
    dayView.frame = frame;
    //--------------------------------------------------
    NSString* string = [NSString stringWithFormat:@"%4d0%1d01010101",year,month];
    if(month>9){
        string = [NSString stringWithFormat:@"%4d%2d01010101",year,month];
    }
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init] ;
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate* inputDate = [inputFormatter dateFromString:string];

    
    //--------------------------------------------------时间格式转换器
    NSDateFormatter *Dayformater = [NSDateFormatter new];
    [Dayformater setLocale:[NSLocale currentLocale]];
    Dayformater.dateFormat = @"dd";
    NSDateFormatter *Monthformater = [NSDateFormatter new];
    [Monthformater setLocale:[NSLocale currentLocale]];
    Monthformater.dateFormat = @"MM";
    NSDateFormatter *EEEformater = [NSDateFormatter new];
    [EEEformater setLocale:[NSLocale currentLocale]];
    EEEformater.dateFormat = @"EEE";
    
    NSDateFormatter *Checkformater = [NSDateFormatter new];
    [Checkformater setLocale:[NSLocale currentLocale]];
    Checkformater.dateFormat = @"yyyy-MM-dd";
    
    //--------------------------------------------------计算位置、间距
    double Ymid   = 5;
    double Xmid   = 0;
    double Height = 0;
    double Width  = 0;
    
    Height = (kRectHeight(frame)-Ymid*4)/5;
    Xmid   = kRectWidth(frame)/(7*1.5+8);
    Width  = Xmid*1.5;
    
    double nowX = Xmid;
    double nowY = 0;
    
    NSString *nowDayEEE = [EEEformater stringFromDate:inputDate];
    
    if([nowDayEEE isEqualToString:@"Mon"]||[nowDayEEE isEqualToString:@"周一"]){
        nowX = Xmid;
    }else if([nowDayEEE isEqualToString:@"Tue"]||[nowDayEEE isEqualToString:@"周二"]){
        nowX = Xmid + Width+Xmid;
    }else if([nowDayEEE isEqualToString:@"Wed"]||[nowDayEEE isEqualToString:@"周三"]){
        nowX = Xmid + (Width+Xmid)*2;
    }else if([nowDayEEE isEqualToString:@"Thu"]||[nowDayEEE isEqualToString:@"周四"]){
        nowX = Xmid + (Width+Xmid)*3;
    }else if([nowDayEEE isEqualToString:@"Fri"]||[nowDayEEE isEqualToString:@"周五"]){
        nowX = Xmid + (Width+Xmid)*4;
    }else if([nowDayEEE isEqualToString:@"Sat"]||[nowDayEEE isEqualToString:@"周六"]){
        nowX = Xmid + (Width+Xmid)*5;
        Height = (kRectHeight(frame)-Ymid*5)/6;
    }else if([nowDayEEE isEqualToString:@"Sun"]||[nowDayEEE isEqualToString:@"周日"]){
        nowX = Xmid + (Width+Xmid)*6;
        Height = (kRectHeight(frame)-Ymid*5)/6;
    }else{
        nowX = Xmid;
    }
    
    //--------------------------------------------------循环加载每一天
    
    while ([Monthformater stringFromDate:inputDate].intValue == month){
        
        NSString *daystr = [Dayformater stringFromDate:inputDate];
        
        //        NSLog(@"%f,%f",nowX,nowY);
        
        YQCalendarEachDay *eachdayView = [[YQCalendarEachDay alloc]
                                            initWithFrame:CGRectMake(nowX,
                                                                     nowY,
                                                                     Width,
                                                                     Height)];
        
        [eachdayView setTheDay:daystr.intValue];
        eachdayView.dayColor = self.dayColor;
        NSString *formatMonthString = [NSString stringWithFormat:@"%d",month];
        if(month<10){formatMonthString = [NSString stringWithFormat:@"0%d",month];}
        NSString *formatDayString = [NSString stringWithFormat:@"%d",daystr.intValue];
        if(daystr.intValue<10){formatDayString = [NSString stringWithFormat:@"0%d",daystr.intValue];}
        eachdayView.dateString = [NSString stringWithFormat:@"%4d-%@-%@",year,formatMonthString,formatDayString];
        [dayView addSubview:eachdayView];
        
        eachdayView.selectedIMG       = self.selectedIcon;
        eachdayView.selectedBackColor = self.selectedBackColor;
        
        NSString *checkString = [Checkformater stringFromDate:inputDate];
        if([self.selectedArray containsObject:checkString]){
            [eachdayView setTheSelectedMode:YES];
        }
        
        //--------------------------------------------------手势
        //添加双击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dayTouched:)];
        //设置出发操作需要的点按次数
        tap.numberOfTapsRequired = 1;
        //设置需要几根手指触发操作
        tap.numberOfTouchesRequired = 1;
        //把手势添加到视图上
        [eachdayView addGestureRecognizer:tap];
        
        //--------------------------------------------------
        inputDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:inputDate];
        //        NSString *str = [EEEformater stringFromDate:inputDate];
        //        NSLog(@"%@",str);
        if([[EEEformater stringFromDate:inputDate] isEqualToString:@"Mon"] ||
           [[EEEformater stringFromDate:inputDate] isEqualToString:@"周一"])
        {
            nowX = Xmid;
            nowY = nowY+Height+Ymid;
        }else{
            nowX = nowX+Width+Xmid;
        }
        //        NSLog(@"testDate:%@", str);
    };
}

/**
 *  查看下一个月
 */
-(void)nextMonth{
    
    //动画结束前，先禁用按钮
    self.nextBTN.enabled = NO;
    
    self.showMonth+=1;
    if(self.showMonth == 13){
        self.showYear+=1;
        self.showMonth = 1;
    }
    //渲染出下一页
    [self setUpTheDayView:self.preDayView
                 ForMonth:self.showMonth
                     Year:self.showYear
                 andFrame:CGRectMake(kViewWidth(self),
                                     kViewY(self.preBTN)+
                                     kViewHeight(self.preBTN)+20,
                                     kViewWidth(self),
                                     kViewHeight(self)-
                                     kViewHeight(self.preBTN)-
                                     kViewY(self.preBTN)-30)];
    
    //通过动画变过去
    [UIView animateWithDuration:0.5 animations:^{
        
        self.preDayView.frame = kRectSetX(self.preDayView.frame, 0);
        self.dayView.frame    = kRectSetX(self.dayView.frame, -kViewWidth(self));
        
    }completion:^(BOOL finished) {
        
        UIView *tempview = self.dayView;
        
        self.dayView     = self.preDayView;
        self.preDayView  = tempview;
        
        for (UIView *subview in self.preDayView.subviews) {
            [subview removeFromSuperview];
        }
        
        self.nextBTN.enabled = YES;
        
    }];
    
    [self freshLable];
}

/**
 *  查看前一个月的日历
 */
-(void)preMonth{
    //动画结束前，先禁用按钮
    self.preBTN.enabled = NO;
    
    self.showMonth-=1;
    if(self.showMonth == 0){
        self.showYear-=1;
        self.showMonth = 12;
    }
    
    //渲染出前一页
    [self setUpTheDayView:self.preDayView
                 ForMonth:self.showMonth
                     Year:self.showYear
                 andFrame:CGRectMake(-kViewWidth(self),
                                     kViewY(self.preBTN)+kViewHeight(self.preBTN)+20,
                                     kViewWidth(self),
                                     kViewHeight(self)-kViewHeight(self.preBTN)-kViewY(self.preBTN)-30)];
    
    //通过动画变过去
    [UIView animateWithDuration:0.5 animations:^{
        
        self.preDayView.frame = kRectSetX(self.preDayView.frame, 0);
        self.dayView.frame = kRectSetX(self.dayView.frame, kViewWidth(self));
        
    }completion:^(BOOL finished) {
        
        UIView *tempview = self.dayView;
        
        self.dayView = self.preDayView;
        self.preDayView = tempview;
        
        for (UIView *subview in self.preDayView.subviews) {
            [subview removeFromSuperview];
        }
        self.preBTN.enabled = YES;
        
    }];
    [self freshLable];
}

/**
 *  更新日历标题
 */
-(void)freshLable{
    self.titleLab.text = [NSString stringWithFormat:@"%d-%d月",self.showYear,self.showMonth];
}

/**
 *  加载日历显示
 */
-(void)loadData{
    for (UIView *subview in self.dayView.subviews) {
        [subview removeFromSuperview];
    }
    [self setUpTheDayView:self.dayView
                 ForMonth:self.showMonth
                     Year:self.showYear
                 andFrame:CGRectMake(0,
                                     kViewY(self.preBTN)+
                                     kViewHeight(self.preBTN)+20,
                                     kViewWidth(self),
                                     kViewHeight(self)-
                                     kViewHeight(self.preBTN)-
                                     kViewY(self.preBTN)-30)];
}

//把某一天变为选中状态
-(void)AddToChooseOneDay:(NSString *)dayStr{
    [self.selectedArray addObject:dayStr];
    [self loadData];
}


//点击手势
-(void)dayTouched:(UITapGestureRecognizer *)recognizer{
    NSString *dayString = ((YQCalendarEachDay *)(recognizer.view)).dateString;
    //NSLog(@"%@",dayString);
    if(self.delegate){
        [self.delegate YQCalendarViewTouchedOneDay:dayString];
    }
}

@end
