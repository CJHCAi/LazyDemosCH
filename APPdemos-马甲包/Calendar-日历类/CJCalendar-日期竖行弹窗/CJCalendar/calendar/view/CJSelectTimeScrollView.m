//
//  CJSelectTime.m
//  CJCalendar
//
//  Created by chjsun on 16/5/29.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import "CJSelectTimeScrollView.h"

#import "CJYearViewController.h"
#import "CJMonthDayViewController.h"

#define CJColor(r, g, b) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1])

#define CJEdgeWidth 40
#define CJEdgeHeight 50

@interface CJSelectTimeScrollView()<YearViewControllerDelegate, MonthAndDayControllerDelegate>

/** 控制器宽度 */
@property (nonatomic, assign) CGFloat nextWidth;

/** selectController */
@property (nonatomic, assign) CJYearViewController *yearController;

/** selectController */
@property (nonatomic, assign) CJMonthDayViewController *monthAndDayController;

@end


@implementation CJSelectTimeScrollView

#pragma mark - 设置滚动的scrollView
/**
 *  设置可以滚动的控制器
 */
-(void) setUpAllControllerWithSuperControll:(UIViewController *)controller{
    // 设置月、日
    [self setUpMonthAndDayWithSuperController:controller];
    // 设置年
    [self setUpYearWithSuperController:controller];
    
    // 添加scrollView颜色
    self.backgroundColor = [UIColor whiteColor];
}

// 设置选择年的table控制器
-(void) setUpYearWithSuperController:(UIViewController *)superController{
    
    CJYearViewController *year = [[CJYearViewController alloc] init];
    self.yearController = year;
    year.delegate = self;
    
    CGFloat selectWidth = self.bounds.size.width;
    CGFloat selectHeight = self.bounds.size.height;
    
    year.view.frame = CGRectMake(self.nextWidth, 0, selectWidth, selectHeight);
    [self addSubview:year.view];
    [superController addChildViewController:year];
    year.selectColor = CJColor(60, 45, 140);
    
    self.nextWidth += selectWidth;
}

// 设置选择日子的collection控制器
-(void) setUpMonthAndDayWithSuperController:(UIViewController *)superController{
    
    CGFloat selectWidth = self.bounds.size.width;
    CGFloat selectHeight = self.bounds.size.height;
    CGRect selectRect = CGRectMake(self.nextWidth, 0, selectWidth, selectHeight);
    CJMonthDayViewController *monthAndDay = [[CJMonthDayViewController alloc] initWithFrame:selectRect];
    monthAndDay.delegate = self;
    self.monthAndDayController = monthAndDay;
    [self addSubview:monthAndDay.view];
    [superController addChildViewController:monthAndDay];
    self.nextWidth += selectWidth;
    monthAndDay.selectColor = CJColor(60, 45, 140);
}


#pragma mark - 刷新方法
// 刷新年
-(void)setYear:(NSString *)year{
    _year = year;
    [self.yearController refreshControlWithCellText:year];
}

// 刷新日历
-(void)refreshControlWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day{
    [self.monthAndDayController refreshControlWithYear:year month:month day:day];
}


#pragma mark - 年份选择控制板 yearDelegate
-(void)yearTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath cellText:(NSString *)cellText{

    if ([self.delegates respondsToSelector:@selector(selectTimeView:didSelectYearAtIndexPath:cellText:)]) {
        [self.delegates selectTimeView:self didSelectYearAtIndexPath:indexPath cellText:cellText];
    }
}

#pragma mark - 日期选择控制器 
-(void)monthAndDayController:(CJMonthDayViewController *)controller didSelectIndexPath:(NSIndexPath *)indexPath GregoiainCalendar:(NSString *)gregoiainCalendar chineseCalendar:(NSString *)chineseCalendar{
    if ([self.delegates respondsToSelector:@selector(selectTimeView:didSelectMonthAndDayAtIndexPath:GregoiainCalendar:chineseCalendar:)]) {
        
        [self.delegates selectTimeView:self didSelectMonthAndDayAtIndexPath:indexPath GregoiainCalendar:gregoiainCalendar chineseCalendar:chineseCalendar];
    }
}

-(void)setSelectYearColor:(UIColor *)selectYearColor{
    _selectYearColor = selectYearColor;
    self.yearController.selectColor = selectYearColor;
}

-(void)setSelectMonthDayColor:(UIColor *)selectMonthDayColor{
    _selectMonthDayColor = selectMonthDayColor;
    self.monthAndDayController.selectColor = selectMonthDayColor;
}

@end
