//
//  AppDelegate.m
//  IStone
//
//  Created by 胡传业 on 14-7-20.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

// 说明： 整个工程的根控制器为 RootViewController 的实例， HomeViewController 实例 为广场模块的VC（viewController），MenuViewController 实例 为侧边菜单VC，
// SameCityViewController 实例 为同城模块VC， FriendsViewController 实例 为好友模块VC， PersonalInfoViewController 实例 为个人信息模块VC，
// SystemInfoViewController 实例 为系统消息模块VC . 在 MenuViewController.m 中，可以实现由菜单中的 cell ，跳转到对应的主页， 某些主页未被添加，如有需要，自行添加.
// 该工程使用了 storyboard， 操作 storyboard 之前，请务必参照 http://blog.csdn.net/chang6520/article/details/7945845 storyboard 解析（一）、（二）.



#import "AppDelegate.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UIColor *navColor = [UIColor colorWithRed:57.0/255 green:204.0/255 blue:230.0/255 alpha:1.0f];

    [[UINavigationBar appearance] setBarTintColor:navColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    // make the status bar white
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 分栏图标高亮时的颜色
    [[UITabBar appearance] setTintColor:navColor];
    

    
    return YES;
}

// 禁止应用横向显示
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
