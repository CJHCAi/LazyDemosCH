//
//  CYTabBarConfig.m
//  CYTabBarDemo
//
//  Created by 张 春雨 on 2017/5/5.
//  Copyright © 2017年 张春雨. All rights reserved.
//

#import "CYTabBarConfig.h"

@implementation CYTabBarConfig
+ (instancetype)shared{
    static CYTabBarConfig *config = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        config = [CYTabBarConfig new];
        config.textColor = [UIColor grayColor];
        config.selectedTextColor = config.textColor;
        config.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
        config.bulgeHeight = 16.f;
        config.selectIndex = -1; // 指定的初始化控制器(<0时为默认)
        config.centerBtnIndex = -1;
        config.HidesBottomBarWhenPushedOption = HidesBottomBarWhenPushedNormal;
    });
    return config;
}
@end
