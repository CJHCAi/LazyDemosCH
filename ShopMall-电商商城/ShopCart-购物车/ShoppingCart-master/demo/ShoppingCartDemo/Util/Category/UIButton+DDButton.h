//
//  UIButton+DDButton.h
//  CategoryTest
//
//  Created by Dry on 2017/7/26.
//  Copyright © 2017年 Dry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (DDButton)


/**
 设置button不同状态下的色值

 @param backgroundColor UIColor
 @param state UIControlState
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;


@end
