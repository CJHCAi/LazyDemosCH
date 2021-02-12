//
//  AppDelegate.m
//  启动屏加启动广告页
//
//  Created by WOSHIPM on 16/8/8.
//  Copyright © 2016年 WOSHIPM. All rights reserved.
//

#import "AppDelegate.h"
 
#import "HomeViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "SplashScreenView.h"
#import "SplashScreenDataManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self initTabBar];
    
    [_window makeKeyWindow];
 
        //        启动页停留1秒
        [NSThread sleepForTimeInterval:1];
        
    
    // 1.判断沙盒中是否存在广告图片
    NSString *filePath = [SplashScreenDataManager getFilePathWithImageName:[[NSUserDefaults standardUserDefaults] valueForKey:adImageName]];
    
    BOOL isExist = [SplashScreenDataManager isFileExistWithFilePath:filePath];
    NSLog(@"%hhd  %@ %@",isExist,[[NSUserDefaults standardUserDefaults] valueForKey:adDeadline],filePath);
    if (isExist) {
        // 图片存在
        SplashScreenView *advertiseView = [[SplashScreenView alloc] initWithFrame:self.window.bounds];
        advertiseView.imgFilePath = filePath;
        advertiseView.imgLinkUrl = [[NSUserDefaults standardUserDefaults] valueForKey:adUrl];
        advertiseView.imgDeadline = [[NSUserDefaults standardUserDefaults] valueForKey:adDeadline];
//        设置广告页显示的时间
        [advertiseView showSplashScreenWithTime:3];
        
    }
    
    
    
    
 
   // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
   [SplashScreenDataManager getAdvertisingImageData];





    return YES;
}

-(void)initTabBar{
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:[HomeViewController new]];
    nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:nil tag:1001];
    
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:[SecondViewController new]];
    nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:nil tag:1002];
    
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:[ThirdViewController new]];
    nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:nil tag:1003];
    
    UITabBarController *tabBarC = [[UITabBarController alloc] init];
    tabBarC.viewControllers = @[nav1, nav2, nav3];
    _window.rootViewController = tabBarC;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
