//
//  AppDelegate.m
//  LaunchScreenDemo
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 Soubw. All rights reserved.
//  博客地址：http://blog.csdn.net/wx_jin/article/details/50617041
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.window setRootViewController:viewController];
    [self.window makeKeyAndVisible];
    
    
    [self initAd];
    
    return YES;
}

/*
 兼容使用LaunchImage启动图
 这边去获取启动图（为了防止广告图还在加载中，启动图已经加载结束了）
 */
- (void) initAd{
    CGSize viewSize =self.window.bounds.size;
    NSString*viewOrientation =@"Portrait";//横屏请设置成 @"Landscape"
    NSString*launchImage =nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for(NSDictionary* dict in imagesDict) {
        CGSize imageSize =CGSizeFromString(dict[@"UILaunchImageSize"]);
        if(CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    self.oldLaunchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    self.oldLaunchView.frame=self.window.bounds;
    self.oldLaunchView.contentMode=UIViewContentModeScaleAspectFill;
    [self.window addSubview:self.oldLaunchView];

    [self loadLaunchAd];

}

/*
 加载自定义广告
 */
-(void)loadLaunchAd{
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(handleTimer) userInfo:nil repeats:NO];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    if (storyboard == nil) {
        return;
    }
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    if (viewController == nil) {
        return;
    }
    
    self.launchView = viewController.view;
    [self.window addSubview:self.launchView];
    
    self.imgBg=[[UIImageView alloc]initWithFrame:self.window.frame];
    
    
    [self.launchView addSubview:self.imgBg];
    
    [self.oldLaunchView removeFromSuperview];
    
    [self.window bringSubviewToFront:self.launchView];
}

-(void)handleTimer{
    [self.imgBg removeFromSuperview];
    [self.launchView removeFromSuperview];
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
