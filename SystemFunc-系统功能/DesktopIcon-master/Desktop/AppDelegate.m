//
//  AppDelegate.m
//  Desktop
//
//  Created by 罗泰 on 2018/11/6.
//  Copyright © 2018 chenwang. All rights reserved.
//

#import "AppDelegate.h"

#import "ControllerPushHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {    
    [[ControllerPushHelper sharedHelper] pushControllerWithopenURL:url];
    return YES;
}
@end
