//
//  AppDelegate.m
//  01-微博动画
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
// 通过stroyboard启动，跟控制器的view并不会在程序启动完成的时候添加到窗口
// 程序启动完成的时候调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 2.加载storyboard.创建窗口的跟控制器
    UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *vc = [stroyboard instantiateInitialViewController];
    
    self.window.rootViewController = vc;
    
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    
    // 显示欢迎界面
    WelcomeView *welcomeV = [WelcomeView weicomeView];
    
    
    // 注意：一定要给界面设置Frame
    welcomeV.frame = self.window.bounds;
    
    
    [self.window addSubview:welcomeV];
    
    NSLog(@"%@",self.window);
    
    // Override point for customization after application launch.
    return YES;
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

// 跟控制器的view会在这个方法中添加到窗口
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
