//
//  AppDelegate.m
//  CYTabBarDemo
//
//  Created by 张春雨 on 2017/3/12.
//  Copyright © 2017年 张春雨. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ViewController2.h"
#import "TabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 继承CYTabBar的控制器， 你可以自定定义 或 不继承直接使用
    TabBarController * tabbar = [[TabBarController alloc]init];

    // 配置
    [CYTabBarConfig shared].selectedTextColor = [UIColor orangeColor];
    [CYTabBarConfig shared].textColor = [UIColor grayColor];
    [CYTabBarConfig shared].backgroundColor = [UIColor whiteColor];
    [CYTabBarConfig shared].selectIndex = 1;
    [CYTabBarConfig shared].centerBtnIndex = 1;
    [CYTabBarConfig shared].HidesBottomBarWhenPushedOption = HidesBottomBarWhenPushedAlone;
    // 样式
    switch (0) {
        case 0:
            // 中间按钮突出 ， 设为按钮 , 底部有文字 ， 闲鱼
            [self style1:tabbar];
            break;
        case 1:
            // 中间按钮不突出 ， 设为控制器 ,底部无文字  , 微博
            [self style2:tabbar];
            break;
        default:
            //无中间按钮 ，普通样式
            [self style3:tabbar];
            break;
    }
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)style1:(CYTabBarController *)tabbar {
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[ViewController2 new]];
    [tabbar addChildController:nav1 title:@"发现" imageName:@"Btn01" selectedImageName:@"SelectBtn01"];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [tabbar addChildController:nav2 title:@"我的" imageName:@"Btn02" selectedImageName:@"SelectBtn02"];
    [tabbar addCenterController:nil bulge:YES title:@"发布" imageName:@"post_normal" selectedImageName:@"post_normal"];
}

- (void)style2:(CYTabBarController *)tabbar {
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [tabbar addChildController:nav1 title:@"消息" imageName:@"tabbar_mainframe" selectedImageName:@"tabbar_mainframeHL"];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[ViewController2 new]];
    [tabbar addChildController:nav2 title:@"朋友圈" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discoverHL"];
    [tabbar addCenterController:[ViewController2 new] bulge:NO title:nil imageName:@"tabbar_centerplus_selected" selectedImageName:@"tabbar_centerplus_selected"];
}

- (void)style3:(CYTabBarController *)tabbar {
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [tabbar addChildController:nav1 title:@"消息" imageName:@"tabbar_mainframe" selectedImageName:@"tabbar_mainframeHL"];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [tabbar addChildController:nav2 title:@"朋友圈" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discoverHL"];

}

@end
