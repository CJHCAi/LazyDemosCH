//
//  TabBarController.m
//  CYTabBarDemo
//
//  Created by 张春雨 on 2017/11/17.
//  Copyright © 2017年 张春雨. All rights reserved.
//

#import "TabBarController.h"
#import "PlusAnimate.h"

@interface TabBarController ()<CYTabBarDelegate>

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabbar.delegate = self;
}

#pragma mark - CYTabBarDelegate
//中间按钮点击
- (void)tabbar:(CYTabBar *)tabbar clickForCenterButton:(CYCenterButton *)centerButton{
    [PlusAnimate standardPublishAnimateWithView:centerButton];
}
//是否允许切换
- (BOOL)tabBar:(CYTabBar *)tabBar willSelectIndex:(NSInteger)index{
        NSLog(@"将要切换到---> %ld",index);
    return YES;
}
//通知切换的下标
- (void)tabBar:(CYTabBar *)tabBar didSelectIndex:(NSInteger)index{
        NSLog(@"切换到---> %ld",index);
}

@end
