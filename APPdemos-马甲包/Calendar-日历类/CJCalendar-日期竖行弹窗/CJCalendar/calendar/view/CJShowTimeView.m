//
//  CJShowTimeView.m
//  CJCalendar
//
//  Created by chjsun on 16/5/23.
//  Copyright © 2016年 chjsun. All rights reserved.
//

//练习英文注释   不到之处 敬请谅解
#import "CJShowTimeView.h"

#define CJColor(r, g, b) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1])

#define CJBasicFontToHeight 0.83
#define CJSelectAlpha 0.6

@interface CJShowTimeView()

/** title */
@property (nonatomic, strong) UILabel *titleLabel;
/** month */
@property (nonatomic, strong) UILabel *animMonthLabel;
/** day */
@property (nonatomic, strong) UILabel *animDayLabel;
/** year */
@property (nonatomic, strong) UILabel *animYearLabel;

/** headerView */
@property (nonatomic, strong) UIView *headerView;
/** monthAndDayView */
@property (nonatomic, strong) UIView *monthAndDayView;
/** yearView */
@property (nonatomic, strong) UIView *yearView;

@end

@implementation CJShowTimeView

/**
 *  标题懒加载
 *
 *  @return label
 */
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

/**
 *  月份懒加载
 *
 *  @return label
 */
-(UILabel *)animMonthLabel{
    if (!_animMonthLabel) {
        _animMonthLabel = [[UILabel alloc] init];
        _animMonthLabel.textColor = self.contentColor;
    }
    return _animMonthLabel;
}
/**
 *  日期懒加载
 *
 *  @return label
 */
-(UILabel *)animDayLabel{
    if (!_animDayLabel) {
        _animDayLabel = [[UILabel alloc] init];
        _animDayLabel.textColor = self.contentColor;
    }
    return _animDayLabel;
}
/**
 *  年份懒加载
 *
 *  @return label
 */
-(UILabel *)animYearLabel{
    if (!_animYearLabel) {
        _animYearLabel = [[UILabel alloc] init];
        _animYearLabel.textColor = self.contentColor;
    }
    return _animYearLabel;
}

/**
 *  视图窗口懒加载
 *
 *  @return 视图
 */
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;

}
/**
 *  视图窗口懒加载
 *
 *  @return 视图
 */
-(UIView *)monthAndDayView{
    if (!_monthAndDayView) {
        _monthAndDayView = [[UIView alloc] init];
    }
    return _monthAndDayView;
    
}
/**
 *  视图窗口懒加载
 *
 *  @return 视图
 */
-(UIView *)yearView{
    if (!_yearView) {
        _yearView = [[UIView alloc] init];
    }
    return _yearView;
    
}


-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        //set default attr
        self.headerName = @"己酉鸡年 冬月廿四 星期一";
        self.headerBackgroundColor = CJColor(60, 45, 140);
        self.headerColor = [UIColor whiteColor];
        
        self.contentBackgroundColor = CJColor(71, 55, 169);
        self.contentColor = [UIColor whiteColor];
        self.dayText = @"1";
        self.monthText = @"1";
        self.yearText = @"1970";

    }
    return self;
}

-(void) generateView{
    //set header
    CGRect headerRect = CGRectMake(0, 0, self.bounds.size.width, 22);
    [self generateHeaderView:headerRect];
    
    //set content
    CGFloat contentHeight = self.bounds.size.height - 22;
    CGRect contentRect = CGRectMake(0, 22, self.bounds.size.width, contentHeight);
    [self generateContentView:contentRect];
}

/**
 *  set HeaderView
 *
 *  @param rect headerViewFrame
 */
-(void) generateHeaderView:(CGRect)rect{

    self.headerView.frame = rect;
    self.headerView.backgroundColor = self.headerBackgroundColor;
    
    [self.headerView addSubview:self.titleLabel];
    self.titleLabel.text = self.headerName;
    self.titleLabel.textColor = self.headerColor;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:rect.size.height * CJBasicFontToHeight-4];

    [self.titleLabel sizeToFit];
    self.titleLabel.center = self.headerView.center;

    [self addSubview:self.headerView];
}


-(void) generateContentView:(CGRect)rect{
    
    //set month and day
    [self setMonthAndDay:rect];
    
   //    //set year
    [self setYear:rect];
}

/**
 *  set month and day
 *
 *  @param rect
 */
-(void)setMonthAndDay:(CGRect)rect{

    CGFloat smallestUnitHeight = rect.size.height/4;
    //set month and day
    CGRect monthAndDayRect = CGRectMake(rect.origin.x,
                                        rect.origin.y,
                                        rect.size.width,
                                        smallestUnitHeight * 3);
    
    self.monthAndDayView.frame = monthAndDayRect;

    self.monthAndDayView.backgroundColor = self.contentBackgroundColor;
    //set month
    [self.monthAndDayView addSubview:self.animMonthLabel];
    
    self.animMonthLabel.textColor = self.contentColor;

    self.animMonthLabel.font = [UIFont systemFontOfSize:smallestUnitHeight * CJBasicFontToHeight];
    
    [self.animMonthLabel sizeToFit];
    //设置宽度与控件等宽
    CGRect monthLabelRect = CGRectMake(self.animMonthLabel.frame.origin.x, 0, rect.size.width, self.animMonthLabel.frame.size.height);
    self.animMonthLabel.frame = monthLabelRect;
    //
    
    self.animMonthLabel.textAlignment = NSTextAlignmentCenter;
    
    //set day
    [self.monthAndDayView addSubview:self.animDayLabel];
    
    self.animDayLabel.text = self.dayText;
    self.animDayLabel.textColor = self.contentColor;
    self.animDayLabel.font = [UIFont systemFontOfSize:smallestUnitHeight * 2];
    [self.animDayLabel sizeToFit];
    
    //设置宽度与控件等宽

    CGRect dayLabelRect = CGRectMake(self.animDayLabel.frame.origin.x, CGRectGetMaxY(self.animMonthLabel.frame) , rect.size.width, self.animDayLabel.frame.size.height);
    self.animDayLabel.frame = dayLabelRect;
    //
    self.animDayLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.monthAndDayView addSubview:self.animDayLabel];
    
    [self addSubview:self.monthAndDayView];
    
    //set tap UITapGestureRecognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(monthAndDayTap)];
    [self.monthAndDayView addGestureRecognizer:tap];
    
}

-(void)monthAndDayTap{
    //代理传值
    if ([_delegate respondsToSelector:@selector(ShowTimeView:didSelectYear:Month:day:)]) {
        [_delegate ShowTimeView:self didSelectYear:_yearText Month:_monthText day:_dayText];
    }
    [UIView animateWithDuration:0.25 animations:^{
        //动画变小
        _animMonthLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _animDayLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        //set select color
        _animMonthLabel.alpha = 1;
        _animDayLabel.alpha = 1;
        _animYearLabel.alpha = CJSelectAlpha;
        
    }completion:^(BOOL finished) {
        // 变小之后弹性回归
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _animMonthLabel.transform = CGAffineTransformIdentity;
            _animDayLabel.transform = CGAffineTransformIdentity;
            
        } completion:nil];
    }];
    
}

/**
 *  set year
 *
 *  @param rect
 */
-(void)setYear:(CGRect)rect{
    CGFloat smallestUnitHeight = rect.size.height/4;
    
    CGRect yearRect = CGRectMake(rect.origin.x,
                                 rect.origin.y + rect.size.height/4 * 3,
                                 rect.size.width,
                                 smallestUnitHeight);

    self.yearView.frame = yearRect;
    self.yearView.backgroundColor = self.contentBackgroundColor;
    
    [self.yearView addSubview:self.animYearLabel];
    //初始化透明度
    self.animYearLabel.alpha = CJSelectAlpha;
    
    self.animYearLabel.text = self.yearText;
    self.animYearLabel.textColor = self.contentColor;
    self.animYearLabel.font = [UIFont systemFontOfSize:smallestUnitHeight * CJBasicFontToHeight];
    
    [self.animYearLabel sizeToFit];
    //设置宽度与控件等宽
    CGRect yearLabelRect = CGRectMake(self.animYearLabel.frame.origin.x, 0, rect.size.width, self.animYearLabel.frame.size.height);
    self.animYearLabel.frame = yearLabelRect;
    //
    self.animYearLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.yearView];
    
    //set tap UITapGestureRecognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yearTap)];
    [self.yearView addGestureRecognizer:tap];

}

-(void)yearTap{
    //代理传值
    if ([_delegate respondsToSelector:@selector(ShowTimeView:didSelectYear:)]) {
        [_delegate ShowTimeView:self didSelectYear:_yearText];
    }
    [UIView animateWithDuration:0.25 animations:^{
        // 动画变小
        _animYearLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        // set select color
        _animMonthLabel.alpha = CJSelectAlpha;
        _animDayLabel.alpha = CJSelectAlpha;
        _animYearLabel.alpha = 1;

        
    }completion:^(BOOL finished) {
        // 变小之后弹性回归
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _animYearLabel.transform = CGAffineTransformIdentity;

        } completion:nil];
    }];
}


-(void)setYearText:(NSString *)yearText{
    _yearText = yearText;
    self.animYearLabel.text = yearText;
    [self setNeedsDisplay];
}

-(void)setDayText:(NSString *)dayText{
    _dayText = dayText;
    self.animDayLabel.text = [NSString stringWithFormat:@"%.2ld", (long)[dayText integerValue]];
}

-(void)setMonthText:(NSString *)monthText{
    _monthText = monthText;
    self.animMonthLabel.text = [NSString stringWithFormat:@"%ld月", (long)[monthText integerValue]];
}

-(void)setHeaderName:(NSString *)headerName{
    _headerName = headerName;
    self.titleLabel.text = headerName;
}

#pragma mark - 设置扩展属性  颜色

- (void)setHeaderColor:(UIColor *)headerColor{
    _headerColor = headerColor;
    self.titleLabel.textColor = headerColor;
}

-(void)setHeaderBackgroundColor:(UIColor *)headerBackgroundColor{
    _headerBackgroundColor = headerBackgroundColor;
    self.headerView.backgroundColor = headerBackgroundColor;
}

- (void)setContentColor:(UIColor *)contentColor{
    _contentColor = contentColor;
    self.animMonthLabel.textColor = contentColor;
    self.animDayLabel.textColor = contentColor;
    self.animYearLabel.textColor = contentColor;
}

- (void)setContentBackgroundColor:(UIColor *)contentBackgroundColor{
    _contentBackgroundColor = contentBackgroundColor;
    self.monthAndDayView.backgroundColor = contentBackgroundColor;
    self.yearView.backgroundColor = contentBackgroundColor;
}

@end
