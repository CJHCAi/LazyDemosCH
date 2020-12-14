//
//  AppDelegate.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/2.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "AppDelegate.h"
#import <JVFloatingDrawerViewController.h>
#import <JVFloatingDrawerSpringAnimator.h>

static NSString * const StoryboardName = @"Main";

static NSString * const YTLeftslideStoryboardID = @"LeftslideViewControllerStoryboardID";
static NSString * const YTBookstoreStoryboardID = @"bookstoreStoryboardID";
static NSString * const YTBookshelfStoryboardID = @"bookshelfStoryboardID";
static NSString * const YTDiscoverStoryboardID = @"discoverStoryboardID";

//bookshelfStoryboardID    discoverStoryboardID

@interface AppDelegate ()

@property (nonatomic, strong, readonly) UIStoryboard *drawersStoryboard;

@end

@implementation AppDelegate

@synthesize drawersStoryboard = _drawersStoryboard;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //防止界面跳转，出现黑块
    self.window.backgroundColor = [UIColor whiteColor];

    self.window.rootViewController = self.drawerViewController;
    [self configureDrawerViewController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
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

#pragma mark - Drawer View Controllers

- (JVFloatingDrawerViewController *)drawerViewController {
    if (!_drawerViewController) {
        _drawerViewController = [[JVFloatingDrawerViewController alloc] init];
    }
    
    return _drawerViewController;
}

#pragma mark Sides

- (UIViewController *)leftslideViewController {
    if (!_leftslideViewController) {
        _leftslideViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:YTLeftslideStoryboardID];
    }
    
    return _leftslideViewController;
}



#pragma mark Center

- (UIViewController *)bookstoreViewController {
    if (!_bookstoreViewController) {
        _bookstoreViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:YTBookstoreStoryboardID];
    }
    
    return _bookstoreViewController;
}

- (UIViewController *)discoverViewController {
    if (!_discoverViewController) {
        _discoverViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:YTDiscoverStoryboardID];
    }
    
    return _discoverViewController;
}

- (UICollectionViewController *)bookshelfViewController {
    if (!_bookshelfViewController) {
        _bookshelfViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:YTBookshelfStoryboardID];
    }
    
    return _bookshelfViewController;
}



- (JVFloatingDrawerSpringAnimator *)drawerAnimator {
    if (!_drawerAnimator) {
        _drawerAnimator = [[JVFloatingDrawerSpringAnimator alloc] init];
    }
    
    return _drawerAnimator;
}

- (UIStoryboard *)drawersStoryboard {
    if(!_drawersStoryboard) {
        _drawersStoryboard = [UIStoryboard storyboardWithName:StoryboardName bundle:nil];
    }
    
    return _drawersStoryboard;
}

- (void)configureDrawerViewController {
    self.drawerViewController.leftViewController = self.leftslideViewController;
    self.drawerViewController.centerViewController = self.bookstoreViewController;
    
    self.drawerViewController.animator = self.drawerAnimator;
    
    self.drawerViewController.backgroundImage = [UIImage imageNamed:@"personalCenterBg"];
}

#pragma mark - Global Access Helper

+ (AppDelegate *)globalDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:animated completion:nil];
}




@end
