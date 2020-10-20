//
//  XMGDownMenu.h
//  小码哥彩票
//
//  Created by xiaomage on 15/6/28.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGDownMenu : UIView


+ (instancetype)showInView:(UIView *)view items:(NSArray *)items oriY:(CGFloat)oriY;

- (void)hide;

@end
