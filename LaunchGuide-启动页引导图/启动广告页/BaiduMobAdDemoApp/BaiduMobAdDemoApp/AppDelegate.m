//
//  AppDelegate.m
//  BaiduMobAdDemoApp
//
//  Created by lishan04 on 16/3/23.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTableViewController.h"
#import "BaiduMobAdSDK/BaiduMobAdSplash.h"
#import "BaiduMobAdSDK/BaiduMobAdSetting.h"

@interface AppDelegate ()<BaiduMobAdSplashDelegate>
@property (nonatomic, strong) BaiduMobAdSplash *splash;
@property (nonatomic, retain) UIView *customSplashView;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    MainTableViewController *mainController  = [[[MainTableViewController alloc]init]autorelease];
    UINavigationController *naviController = [[[UINavigationController alloc]initWithRootViewController:mainController]autorelease];
    self.window.rootViewController = naviController;
    [self.window makeKeyAndVisible];
    
    //    // 全屏开屏
    //    BaiduMobAdSplash *splash = [[BaiduMobAdSplash alloc] init];
    //    splash.delegate = self;
    //    splash.AdUnitTag = @"2058492";
    //    splash.canSplashClick = YES;
    //    [splash loadAndDisplayUsingKeyWindow:self.window];
    //    self.splash = splash;
    
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;
    [BaiduMobAdSetting sharedInstance].supportHttps = YES;
    //    自定义开屏
    //
    BaiduMobAdSplash *splash = [[[BaiduMobAdSplash alloc] init]autorelease];
    splash.delegate = self;
    splash.AdUnitTag = @"2058492";
    splash.canSplashClick = YES;
    self.splash = splash;
    
    //可以在customSplashView上显示包含icon的自定义开屏
    self.customSplashView = [[[UIView alloc]initWithFrame:self.window.frame]autorelease];
    self.customSplashView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.customSplashView];
    
    CGFloat screenWidth = self.window.frame.size.width;
    CGFloat screenHeight = self.window.frame.size.height;

    //在baiduSplashContainer用做上展现百度广告的容器，注意尺寸必须大于200*200，并且baiduSplashContainer需要全部在window内，同时开机画面不建议旋转
    UIView * baiduSplashContainer = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 40)]autorelease];
    [self.customSplashView addSubview:baiduSplashContainer];
    
    UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(0, screenHeight - 40, screenWidth, 20)]autorelease];
    label.text = @"上方为开屏广告位";
    label.textAlignment = NSTextAlignmentCenter;
    [self.customSplashView addSubview:label];
    //
    //在的baiduSplashContainer里展现百度广告
    [splash loadAndDisplayUsingContainerView:baiduSplashContainer];
    
    return YES;
}

- (NSString *)publisherId {
    return @"ccb60059";
}

- (void)splashDidClicked:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidClicked");
}

- (void)splashDidDismissLp:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidDismissLp");
}

- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidDismissScreen");
    [self removeSplash];
}

- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash {
    NSLog(@"splashSuccessPresentScreen");
}

- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason)reason {
    NSLog(@"splashlFailPresentScreen withError %d", reason);
    [self removeSplash];
}

/**
 *  展示结束or展示失败后, 手动移除splash和delegate
 */
- (void) removeSplash {
    if (self.splash) {
        self.splash.delegate = nil;
        self.splash = nil;
        [self.customSplashView removeFromSuperview];
    }
}


@end
