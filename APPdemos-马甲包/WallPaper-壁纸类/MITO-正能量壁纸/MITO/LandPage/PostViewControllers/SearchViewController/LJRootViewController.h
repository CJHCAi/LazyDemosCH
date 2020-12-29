//
//  LJRootViewController.h
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/25.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJRootViewController : UIViewController

/*!
 @brief 设置NavigationTitle
 */
- (void) setNavigationTitle:(NSString *)title;

/*!
 @brief 设置NavigationItem

 */
- (void) setNavigationItemName:(NSString *)name addBackgroundImage:(NSString *)imageName addIsLeft:(BOOL)isLeft;

/*!
 @brief 设置navigationBarTintColor
 */
- (void)setNavigationBarTintColor:(UIColor *)color;

@end
