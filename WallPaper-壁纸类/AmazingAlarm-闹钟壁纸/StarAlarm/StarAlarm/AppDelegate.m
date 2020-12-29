//
//  AppDelegate.m
//  StarAlarm
//
//  Created by dllo on 16/3/30.
//  Copyright © 2016年 YYL. All rights reserved.
//

#import "AppDelegate.h"
#import "YXWMainViewController.h"
#import "WDGDatabaseTool.h"
#import "XFZ_Notification.h"
#import "YXWCalmCosmosViewController.h"
#import "WQPlaySound.h"
#import "YXWRocketViewController.h"
#import "YXWSmileViewController.h"
#import "XFZ_Count_ViewController.h"
#import "YXWGuideViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@property (nonatomic, strong) YXWMainViewController *mainVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self creatMainVC];
    [WDGDatabaseTool creatTableWithSQL:@"CREATE TABLE if not exists Alarm (id integer PRIMARY KEY AUTOINCREMENT,hour text NOT NULL,minute text,week text,style text)"];
    

    return YES;
}

- (void)creatMainVC {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyWindow];
    self.mainVC = [[YXWMainViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.mainVC];
    self.window.rootViewController = self.mainVC;
    
#pragma mark - 引导页
    NSUserDefaults *guide = [NSUserDefaults standardUserDefaults];
    if ([guide objectForKey:@"first"] == nil) {
        [guide setObject:@"YES" forKey:@"first"];
        YXWGuideViewController *guideVC = [[YXWGuideViewController alloc] init];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(guideAction:) name:@"guide" object:nil];
        self.window.rootViewController = guideVC;
    } else {
        self.window.rootViewController = self.mainVC;
    }

    
}
//引导页
-(void)guideAction:(UIButton *)sender {
    
    self.window.rootViewController = self.mainVC;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"1");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"2");

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"3");

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"4");

}


// 本地通知回调函数，当应用程序在前台时调用0
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    NSLog(@"aaaaaa");
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"style"] isEqualToString:@"平静的宇宙"]) {
        YXWCalmCosmosViewController *calmVc = [[YXWCalmCosmosViewController alloc] init];
        [self.window.rootViewController presentViewController:calmVc animated:YES completion:^{
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }];

    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"style"] isEqualToString:@"质量计算器"]) {
        XFZ_Count_ViewController *countVC = [[XFZ_Count_ViewController alloc] init];
        [self.window.rootViewController presentViewController:countVC animated:YES completion:^{
            [[UIApplication sharedApplication] cancelAllLocalNotifications];

        }];
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"style"] isEqualToString:@"火箭发射器"]) {
        YXWRocketViewController *rocketVC = [[YXWRocketViewController alloc] init];
        [self.window.rootViewController presentViewController:rocketVC animated:YES completion:^{
            [[UIApplication sharedApplication] cancelAllLocalNotifications];

        }];
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"style"] isEqualToString:@"宇航员的微笑"]) {
        YXWSmileViewController *smileVC = [[YXWSmileViewController alloc] init];
        [self.window.rootViewController presentViewController:smileVC animated:YES completion:^{
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }];
    }
    
}



@end
