//
//  CFCalendarCell.h
//  CFCalendar
//
//  Created by MountainCao on 2017/8/22.
//  Copyright © 2017年 深圳中业兴融互联网金融服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFCalendarCell : UIView

@property (nonatomic, strong, readonly) UILabel   *dayLabel;
@property (nonatomic, strong, readonly) UIView    *dotView;

@property (nonatomic, copy) void(^selectCellBlock)(void);

@end
