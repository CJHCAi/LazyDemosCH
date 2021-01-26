//
//  CJMainViewController.h
//  CJCalendar
//
//  Created by chjsun on 16/5/23.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJCalendarViewController;

@protocol CalendarViewControllerDelegate <NSObject>

@optional
-(void) CalendarViewController:(CJCalendarViewController *)controller didSelectActionYear:(NSString *)year month:(NSString *)month day:(NSString *)day;

@end

@interface CJCalendarViewController : UIViewController

// attr
//以下属性均有默认值
/** HeaderColor default white 上部显示区域标题的颜色*/
@property (nonatomic, copy) UIColor *headerColor;
/** HeaderBackgroundColor default rgb (60, 45, 140) 上部显示区域标题栏背景颜色 */
@property (nonatomic, copy) UIColor *headerBackgroundColor;
/** contentColor default white 上部显示区域内容文本颜色*/
@property (nonatomic, copy) UIColor *contentColor;
/** contentBackgroundColor default rgb (71, 55, 169) 上部显示区域内容背景颜色*/
@property (nonatomic, copy) UIColor *contentBackgroundColor;


/** 直接指定时间 */
@property (nonatomic, strong) NSDate *Date;

/** 代理 */
@property (nonatomic, assign) id<CalendarViewControllerDelegate> delegate;

// method
/** 传入年、月、日. 设置时间 */
-(void) setYear:(NSString *)year month:(NSString *)month day:(NSString *)day;
/** 传入半透明程度 和颜色，设置背景。 默认黑色，透明度0.8 */
-(void) setBgAlpha:(CGFloat)alpha color:(UIColor *)bgColor;

@end
