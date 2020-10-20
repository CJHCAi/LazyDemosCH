//
//  AppDelegate.m
//  QQ空间
//
//  Created by 妖精的尾巴 on 15-8-23.
//  Copyright (c) 2015年 妖精的尾巴. All rights reserved.
//

#import "AppDelegate.h"
#import "NewVersionViewController.h"
#import "ViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //    NSString* info=[NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    //    NSLog(@"%@",info);
    [NSThread sleepForTimeInterval:5.0f];
    //1----创建窗口
    self.window=[[UIWindow alloc]init];
    self.window.frame=[UIScreen mainScreen].bounds;
    
    //2-----取软件版本号
    NSString* key=@"CFBundleVersion";
    NSString* lastVersion=[[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSString* currentVersion=[NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) {
        self.window.rootViewController=[[ViewController alloc]init];
    }
    else{
        self.window.rootViewController=[[NewVersionViewController alloc]init];
        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    return YES;
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
