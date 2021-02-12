//
//  CJMonthDayViewController.h
//  CJCalendar
//
//  Created by chjsun on 16/5/24.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJMonthDayViewController;
@protocol MonthAndDayControllerDelegate <NSObject>

@optional
-(void) monthAndDayController:(CJMonthDayViewController *)controller didSelectIndexPath:(NSIndexPath *)indexPath GregoiainCalendar:(NSString *)gregoiainCalendar chineseCalendar:(NSString *)chineseCalendar;

@end

@interface CJMonthDayViewController : UICollectionViewController

/** 选中状态的color */
@property (nonatomic, strong) UIColor *selectColor;

-(instancetype)initWithFrame:(CGRect)frame;

/** 代理 */
@property (nonatomic, assign) id<MonthAndDayControllerDelegate> delegate;

//根据时间更新collection
-(void)refreshControlWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day;

@end
