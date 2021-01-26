//
//  CJSelectTime.h
//  CJCalendar
//
//  Created by chjsun on 16/5/29.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJSelectTimeScrollView;
@protocol SelectTimeScrollViewDelegate <NSObject>

@optional
-(void) selectTimeView:(CJSelectTimeScrollView *)timeScroll didSelectYearAtIndexPath:(NSIndexPath *)indexPath cellText:(NSString *)cellText;

-(void) selectTimeView:(CJSelectTimeScrollView *)timeScroll didSelectMonthAndDayAtIndexPath:(NSIndexPath *)indexPath GregoiainCalendar:(NSString *)gregoiainCalendar chineseCalendar:(NSString *)chineseCalendar;

@end

@interface CJSelectTimeScrollView : UIScrollView

// attr
/** 需要设置的年 */
@property (nonatomic, copy) NSString *year;
/** 需要设置的月 */
@property (nonatomic, copy) NSString *month;
/** 需要设置的日 */
@property (nonatomic, copy) NSString *day;

/** 选中状态下的年的背景颜色 */
@property (nonatomic, strong) UIColor *selectYearColor;
/** 选中状态下的,年的背景颜色 */
@property (nonatomic, strong) UIColor *selectMonthDayColor;

// methed
// 设置所有的控制器
-(void) setUpAllControllerWithSuperControll:(UIViewController *)controller;
//根据时间更新collection
-(void)refreshControlWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day;


/** 代理 */
@property (nonatomic, assign) id<SelectTimeScrollViewDelegate> delegates;

@end
