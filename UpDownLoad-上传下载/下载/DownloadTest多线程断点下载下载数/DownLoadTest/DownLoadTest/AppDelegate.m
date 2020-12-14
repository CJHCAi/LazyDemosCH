 //
//  AppDelegate.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/23.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "AppDelegate.h"
#import "DLWelcomeViewController.h"
#import "DLTaskTableViewController.h"
#import "DLDownloadViewController.h"
#import "DLMineViewController.h"
#import "IQKeyboardManager.h"
#import "DLDownloadMagager.h"
#import "DLCurrentDownloadViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) UITabBarController *tabBarController;
@end

@implementation AppDelegate

- (void)dealloc
{
    [self.reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //网络监测
    [self checkReachability];
    //键盘自动收起和对齐
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    //设置UI
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self loadController];
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
    if ([DLDownloadMagager sharedManager].queue.operationCount > 0) {
        [[DLDownloadMagager sharedManager].queue cancelAllOperations];
    }
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler
{
    self.backgroundSessionCompletionHandler = completionHandler;
}
#pragma mark - Private
- (void)loadController
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    NSString * isFirstLaunch = [defaults objectForKey:@"isFirstLaunch"];
    [self setTabBarController];
    if ([isFirstLaunch isEqualToString:@"YES"]) {
        self.window.rootViewController = _tabBarController;
    }else {
        DLWelcomeViewController * welcomeController = [[DLWelcomeViewController alloc] init];
        welcomeController.launchBlock=^(void){
            self.window.rootViewController = _tabBarController;
        };
        self.window.rootViewController = welcomeController;
        [defaults setObject:@"YES" forKey:@"isFirstLaunch"];
        [defaults synchronize];
    }
}

- (void)setTabBarController
{
    _tabBarController = [[UITabBarController alloc] init];
    DLTaskTableViewController *taskVC = [[DLTaskTableViewController alloc] init];
    taskVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"任务" image:[UIImage imageNamed:@"icon_tabbar_资料"] tag:0];
    UINavigationController *taskNav = [[UINavigationController alloc] initWithRootViewController:taskVC];
    
    DLDownloadViewController *downloadVC = [[DLDownloadViewController alloc]init];
    downloadVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"下载" image:[UIImage imageNamed:@"icon_tabbar_信箱"] tag:0];
    UINavigationController *downloadNav = [[UINavigationController alloc] initWithRootViewController:downloadVC];
    
    DLMineViewController *mineVC = [[DLMineViewController alloc] init];
    mineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"icon_tabbar_我"] tag:0];
    UINavigationController *mineNavi = [[UINavigationController alloc] initWithRootViewController:mineVC];
    _tabBarController.viewControllers = @[taskNav, downloadNav, mineNavi];
    [_tabBarController setSelectedIndex:1];
}

- (void)checkReachability {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    [self updateInterfaceWithReachability:self.reachability];
}

#pragma mark - NetNotification
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NSInteger downloadStatus = [DLDownloadMagager sharedManager].currentNetStatus;
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == NotReachable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DLSuspendTaskNotification object:nil];
    } else if (downloadStatus == ReachableViaWiFi && status == ReachableViaWWAN && ![DLDownloadMagager sharedManager].isWWANDownload) {
        NSMutableArray *statusArray = [[NSMutableArray alloc] init];
        for (DLURLSessionOperation *operation in [[DLDownloadMagager sharedManager].operationDictionary allValues]) {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
            [tempDic setObject:operation.urlString forKey:@"url"];
            [tempDic setObject:@(operation.isSuspend) forKey:@"isSuspend"];
            [tempDic setObject:@(operation.isResume) forKey:@"isResume"];
            [statusArray addObject:tempDic];
        }
        NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
        [defaults setObject:statusArray forKey:@"suspendStatus"];
        [defaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DLSuspendTaskNotification object:nil];
    } else if (downloadStatus == ReachableViaWiFi && status == ReachableViaWWAN) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DLSuspendAndRestartTaskNotification object:nil];
    } else if (downloadStatus == ReachableViaWWAN && status == ReachableViaWiFi && ![DLDownloadMagager sharedManager].isWWANDownload) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DLAutoStartTaskNotification object:nil];
    } else if (downloadStatus == ReachableViaWWAN && status == ReachableViaWiFi) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DLSuspendAndRestartTaskNotification object:nil];
    }
    [DLDownloadMagager sharedManager].currentNetStatus = status;
}

@end
