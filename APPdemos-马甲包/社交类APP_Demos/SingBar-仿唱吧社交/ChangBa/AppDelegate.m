//
//  AppDelegate.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/3.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
//懒加载window
- (UIWindow *)window{
    if (_window == nil) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_window makeKeyAndVisible];
    }
    return _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    TabBarViewController *TabBarVC = [TabBarViewController new];
    self.window.rootViewController = TabBarVC;
    
    
    //全局设置NavigationBar，因为标题字体太难看了！
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HannotateSC-W5" size:17]}];
    
//    [[UILabel appearance] setFont:[UIFont fontWithName:@"HannotateSC-W5" size:12]];
    //设置应用的BmobKey 09b4188fa5842fe0c4cac6da4a57be17  506d091290ea0684f5ca60f1634aaaa7
    [Bmob registerWithAppKey:@"506d091290ea0684f5ca60f1634aaaa7"];
    
    //初始化环信
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"854152389#yinaifanchat" apnsCertName:nil];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    //初始化单例对象
    [EasemobManager shareManager];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];

}

@end
