//
//  GDTAppDelegate.m
//  GDTMobApp
//
//  Created by GaoChao on 13-12-2.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import "GDTAppDelegate.h"
#import "GDTNavigationController.h"
#import "GDTSDKConfig.h"
#import "GDTADTool.h"
@implementation GDTAppDelegate

@synthesize viewController;
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:@"View" bundle:nil];
    GDTNavigationController *nav = [[GDTNavigationController alloc]initWithRootViewController:self.viewController];
    nav.navigationBar.barStyle = UIBarStyleBlackOpaque;
    nav.navigationBar.topItem.title = @"广告形式";
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    //腾讯广告
    [GDTSDKConfig setHttpsOn];
    self.splash=[GDTADTool GDT_FullSplashAD:self.window];
    self.splash.delegate=self;
    
//    //开屏广告初始化并展示代码
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        GDTSplashAd *splash = [[GDTSplashAd alloc] initWithAppId:kGDTMobSDKAppId placementId:@"9040714184494018"];
//        splash.delegate = self;
//        UIImage *splashImage = [UIImage imageNamed:@"SplashNormal"];
//        if (IS_IPHONEX) {
//            splashImage = [UIImage imageNamed:@"SplashX"];
//        } else if ([UIScreen mainScreen].bounds.size.height == 480) {
//            splashImage = [UIImage imageNamed:@"SplashSmall"];
//        }
//        UIImage *backgroundImage = [GDTAppDelegate imageResize:splashImage
//                                                   andResizeTo:[UIScreen mainScreen].bounds.size];
//        splash.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
//        splash.fetchDelay = 3;
//        [splash loadAdAndShowInWindow:self.window];
//        self.splash = splash;
//
//    }
    return YES;
}

+ (UIImage *)imageResize:(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 开发者在该回调函数中对传入的URL进行分析，展示详情页面。
    return YES;
}
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"%s%@",__FUNCTION__,error);
}

- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}
-(void)splashAdClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
    self.splash = nil;
}

- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdClicked:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"%s",__FUNCTION__);
}

@end
