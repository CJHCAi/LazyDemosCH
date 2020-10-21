//
//  UITabBarItem+BadgeColor.h
//  CYTabBarDemo
//
//  Created by 张 春雨 on 7/27/17.
//  Copyright © 2017 张春雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UITabBarItem (BadgeColor)
@property (nonatomic, readwrite, copy, nullable) UIColor *badgeColor;
@end
