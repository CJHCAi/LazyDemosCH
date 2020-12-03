//
//  CFCalendarView.h
//  CFCalendar
//
//  Created by MountainCao on 2017/8/22.
//  Copyright © 2017年 深圳中业兴融互联网金融服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedDateBlock)(NSInteger year,NSInteger month,NSInteger day);

@interface CFCalendarView : UIView

+(instancetype)initWithFrame:(CGRect)frame year:(NSInteger)year month:(NSInteger)month superView:(UIView *)superView selectedDateBlock:(SelectedDateBlock)selectedBlock;

@end
