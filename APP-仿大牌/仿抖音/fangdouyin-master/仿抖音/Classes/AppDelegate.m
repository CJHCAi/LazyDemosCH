//
//  AppDelegate.m
//  仿抖音
//
//  Created by ireliad on 2018/3/15.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]init];
    self.window.frame=[UIScreen mainScreen].bounds;
    self.window.backgroundColor=[UIColor whiteColor];
    UINavigationController * nav=[[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc]init]];
    self.window.rootViewController=nav;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
