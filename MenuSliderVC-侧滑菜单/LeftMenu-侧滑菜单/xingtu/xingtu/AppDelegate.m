//
//  AppDelegate.m
//  xingtu
//
//  Created by Wondergirl on 2016/12/9.
//  Copyright © 2016年 Wondgirl. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftMenuViewController.h"
#import "mainTabBarController.h"
//版本新特性
#import "GuideViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
     mainTabBarController *tabBarController = [[mainTabBarController alloc]init];
    LeftMenuViewController * setVC = [[LeftMenuViewController alloc]init];
    self.leftSlideVC = [[LeftSlideViewController alloc]initWithLeftView:setVC andMainView:tabBarController];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString *oldVersion=[defaults objectForKey:@"version"];
    NSDictionary *dict=[NSBundle mainBundle].infoDictionary;
    NSString *nowVersion=dict[@"CFBundleShortVersionString"];
    
    if (oldVersion==nil || ![oldVersion isEqualToString:nowVersion]) {
        
        GuideViewController *controller=[[GuideViewController alloc] init];
        
        self.window.rootViewController=controller;
        //获取当前程序的版本--读取当前的info.plist文件
        NSDictionary *dict=[NSBundle mainBundle].infoDictionary;
        
        NSString *nowVersion=dict[@"CFBundleShortVersionString"];
        [defaults setObject:nowVersion forKey:@"version"];
        
        
    }else{
   
   
   [self.window setRootViewController:self.leftSlideVC];
   }
    [self.window makeKeyAndVisible];
    return YES;

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
