//
//  AppDelegate.m
//  集成GPUImage2
//
//  Created by 七啸网络 on 2017/8/23.
//  Copyright © 2017年 youbei. All rights reserved.
//

#import "AppDelegate.h"
#import "CameraViewController.h"
#import "MainViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    
    MainViewController * mainVC=[[MainViewController alloc]init];
    UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController=nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}





#pragma mark--系统
- (void)applicationWillResignActive:(UIApplication *)application {


}


- (void)applicationDidEnterBackground:(UIApplication *)application {

    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
}


- (void)applicationWillTerminate:(UIApplication *)application {


}


@end
