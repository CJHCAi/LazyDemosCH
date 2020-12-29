//
//  AppDelegate.m
//  SportForum
//
//  Created by zhengying on 6/9/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "AppDelegate.h"
#import "UINavigationBar+SportFormu.h"
#import "MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <SMS_SDK/SMS_SDK.h>
#import <HealthKit/HealthKit.h>

@implementation AppDelegate
{
    BOOL _bFirstAutoLogin;
    HKHealthStore *_healthStore;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _mainNavigationController = [[CSNavigationController alloc] init];
    //[_mainNavigationController.navigationBar customNavigationBar];
    self.window.rootViewController = _mainNavigationController;
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //添加友盟数据统计
    [MobClick startWithAppkey:@"54d30becfd98c50afd0006da" reportPolicy:(ReportPolicy) BATCH channelId:nil];
    
    [ShareSDK registerApp:@"4d61fede9550"];
    
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"3857157322"
                               appSecret:@"e0e546d27908ba835cdb138719d3482a"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];

    //连接短信分享
    [ShareSDK connectSMS];
    
    [SMS_SDK registerApp:@"521e872dffc8" withSecret:@"51dc77c60dabf0a0b97df4593e1aa632"];
    [[ApplicationContext sharedInstance] saveObject:@(NO) byKey:@"WeiBoLogin"];
    [[ApplicationContext sharedInstance] saveObject:@(NO) byKey:@"WeiBoShare"];
    
    [_mainNavigationController autoLoginWhenStart];
    _bFirstAutoLogin = YES;
    
    // Let the device know we want to receive push notifications
    [self setNotificationType];
    
    if ([WCSession isSupported]) {
        [[WCSession defaultSession] setDelegate:self];
        [[WCSession defaultSession] activateSession];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateProcessToWatch:) name:NOTIFY_MESSAGE_UPDATE_PROCESS_TO_WATCH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogoutSuccess) name:NOTIFY_MESSAGE_LOGOUT_SUCCESS object:nil];
    _healthStore = [[HKHealthStore alloc] init];
    return YES;
}

- (void)applicationShouldRequestHealthAuthorization:(UIApplication *)application NS_AVAILABLE_IOS(9_0)
{
    [_healthStore handleAuthorizationForExtensionWithCompletion:^(BOOL success, NSError * __nullable error){
    }];
}

-(void)handleUpdateProcessToWatch:(NSNotification*) notification
{
    if ([WCSession defaultSession].reachable && notification.userInfo != nil) {
        if([[WCSession defaultSession] isReachable] && [[WCSession defaultSession] isPaired] && [[WCSession defaultSession] isWatchAppInstalled])
        {
            NSMutableDictionary *dictReply = [[NSMutableDictionary alloc]init];
            [dictReply setObject:notification.userInfo forKey:@"UpdateProcessToWatch"];
            [[WCSession defaultSession] sendMessage:dictReply
                                       replyHandler:^(NSDictionary *reply) {
                                           
                                           NSLog(@"%@",reply);
                                       }
             
                                       errorHandler:^(NSError *error) {
                                           
                                           NSLog(@"%@",error);
                                           
                                       }];
        }
    }
}

- (void)handleLogoutSuccess {
    if ([WCSession defaultSession].reachable) {
        if([[WCSession defaultSession] isReachable] && [[WCSession defaultSession] isPaired] && [[WCSession defaultSession] isWatchAppInstalled])
        {
            NSMutableDictionary *dictReply = [[NSMutableDictionary alloc]init];
            [dictReply setObject:@(NO) forKey:@"LoginState"];
            [[WCSession defaultSession] sendMessage:dictReply
                                       replyHandler:^(NSDictionary *reply) {
                                           
                                           NSLog(@"%@",reply);
                                           
                                       }
             
                                       errorHandler:^(NSError *error) {
                                           
                                           NSLog(@"%@",error);
                                           
                                       }];
        }
    }
}

- (void) session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler{
    if ([message objectForKey:@"request"]) {
        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
        SysConfig *sysConfig = [[ApplicationContext sharedInstance]systemConfigInfo];
        
        NSMutableDictionary *dictReply = [[NSMutableDictionary alloc]init];
        
        if (userInfo == nil || sysConfig == nil) {
            [dictReply setObject:@(NO) forKey:@"LoginState"];
            replyHandler(dictReply);
            return;
        }
        
        [dictReply setObject:@(YES) forKey:@"LoginState"];
        
        NSUInteger nCurLevel = userInfo.proper_info.rankLevel;
        CGFloat fProcess = (userInfo.proper_info.rankscore - [sysConfig.level_score.data[nCurLevel - 1] unsignedIntValue]) * 1.00 / ([sysConfig.level_score.data[nCurLevel] unsignedIntValue] - [sysConfig.level_score.data[nCurLevel - 1] unsignedIntValue]);
        [dictReply setObject:@(fProcess * 100) forKey:@"LevelProcess"];
        [dictReply setObject:@(userInfo.proper_info.rankscore) forKey:@"CurrentScore"];
        [dictReply setObject:@([sysConfig.level_score.data[nCurLevel] unsignedIntValue]) forKey:@"LevelTotal"];
        replyHandler(dictReply);
    }
    else if([message objectForKey:@"LatestWorkoutTime"])
    {
        NSString *strBeginTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"LatestWorkoutTime"];
        NSMutableDictionary *dictReply = [[NSMutableDictionary alloc]init];
        [dictReply setObject:strBeginTime.length > 0 ? strBeginTime : @"" forKey:@"LatestWorkoutTime"];
        replyHandler(dictReply);
    }
    else if([message objectForKey:@"publishRecord"])
    {
        NSDictionary *dictValue = [message objectForKey:@"publishRecord"];
        NSString *strSource = [dictValue objectForKey:@"source"];
        long long lStartTime = [[dictValue objectForKey:@"beginTime"]longLongValue];
        long long lEndTime = [[dictValue objectForKey:@"endTime"]longLongValue];
        NSUInteger nDuration = [[dictValue objectForKey:@"duration"]integerValue];
        NSUInteger nDistance = [[dictValue objectForKey:@"distance"]integerValue];
        
        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
        
        if (userInfo == nil) {
            NSMutableDictionary *dictReply = [[NSMutableDictionary alloc]init];
            [dictReply setObject:@(-1) forKey:@"ErrorCode"];
            [dictReply setObject:@"请求失败，请在手机端App上登录！" forKey:@"ErrorDesc"];
            [dictReply setObject:@"" forKey:@"recordId"];
            replyHandler(dictReply);
            return;
        }
        
        SportRecordInfo* sportRecordInfo =[[SportRecordInfo alloc]init];
        sportRecordInfo.type = @"run";
        sportRecordInfo.source = strSource;
        sportRecordInfo.begin_time = lStartTime;
        sportRecordInfo.end_time = lEndTime;
        sportRecordInfo.duration = nDuration;
        sportRecordInfo.distance = nDistance;
        sportRecordInfo.sport_pics.data = nil;
        sportRecordInfo.weight = [[CommonUtility sharedInstance]generateWeightBySex:userInfo.sex_type Weight:userInfo.weight];
        sportRecordInfo.mood = @"";
        
        if ([dictValue objectForKey:@"heartRate"]) {
            sportRecordInfo.heart_rate = [[dictValue objectForKey:@"heartRate"]floatValue];
        }
        
        __typeof(self) __weak weakSelf = self;
        
        [[SportForumAPI sharedInstance]recordNewByRecordItem:sportRecordInfo RecordId:0 Public:YES
                                               FinishedBlock:^(int errorCode, NSString* strDescErr, NSString* strRecordId, ExpEffect* expEffect) {
                                                   __typeof(self) strongSelf = weakSelf;
                                                   
                                                   if (strongSelf == nil) {
                                                       return;
                                                   }
                                                   
                                                   if (errorCode == 0) {
                                                       UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
                                                       userInfo.weight = sportRecordInfo.weight;
                                                       
                                                       [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                                                        {
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
                                                        }];
                                                       
                                                       [[NSUserDefaults standardUserDefaults]setObject:[dictValue objectForKey:@"endTime"] forKey:@"LatestWorkoutTime"];
                                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                                   }
                                                   
                                                   NSMutableDictionary *dictReply = [[NSMutableDictionary alloc]init];
                                                   [dictReply setObject:@(errorCode) forKey:@"ErrorCode"];
                                                   [dictReply setObject:strDescErr forKey:@"ErrorDesc"];
                                                   [dictReply setObject:strRecordId forKey:@"recordId"];
                                                   replyHandler(dictReply);
                                               }];
    }
    else if([message objectForKey:@"sendHeartRate"])
    {
        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
        
        if (userInfo == nil) {
            NSMutableDictionary *dictReply = [[NSMutableDictionary alloc]init];
            [dictReply setObject:@(-1) forKey:@"ErrorCode"];
            [dictReply setObject:@"请求失败，请在手机端App上登录！" forKey:@"ErrorDesc"];
            replyHandler(dictReply);
            return;
        }
        
        NSString* strRecordId = [message objectForKey:@"sendHeartRate"];
        
        if (strRecordId.length > 0) {
            
            [[SportForumAPI sharedInstance]userSendHeartByRecordId:strRecordId FinishedBlock:^(int errorCode)
             {
                 NSMutableDictionary *dictReply = [[NSMutableDictionary alloc]init];
                 [dictReply setObject:@(errorCode) forKey:@"ErrorCode"];
                 replyHandler(dictReply);
             }];
        }
    }
}

-(void)setNotificationType
{
    if (IOS8_OR_LATER) {
        /*//1.创建消息上面要添加的动作(按钮的形式显示出来)
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";//按钮的标示
        action.title=@"Accept";//按钮的标题
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        //    action.authenticationRequired = YES;
        //    action.destructive = YES;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = YES;
        
        //2.创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示,推送通知的时候也是根据这个来区分
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        
        //3.创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
        [application registerUserNotificationSettings:notiSettings];
        [application registerForRemoteNotifications];*/
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:kSTORE_DEVICE_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"DeviceToken successful:%@", token);
    [_mainNavigationController setDeviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Error: Failed to get token, detail is: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //[_mainNavigationController disconnectWebSocket];
   // [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_PROGRAM_RESIGNACTIVE object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    /*UIApplication*    app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier task = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:task];
        //task = UIBackgroundTaskInvalid;
    }];
    
    [[ApplicationContext sharedInstance]logout:^void((int nErrorCode)){
        // Do the work associated with the task.
        NSLog(@"Started background task timeremaining = %f", [app backgroundTimeRemaining]);
        
        [app endBackgroundTask:task];
        //task = UIBackgroundTaskInvalid;
    }];*/
    
    BOOL bStartScreen = [[[ApplicationContext sharedInstance]getObjectByKey:@"WeiBoLogin"]boolValue];
    BOOL bWeiBoShare = [[[ApplicationContext sharedInstance]getObjectByKey:@"WeiBoShare"]boolValue];
    
    if (!bStartScreen && !bWeiBoShare)
    {
        [_mainNavigationController disconnectWebSocket];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_PROGRAM_RESIGNACTIVE object:nil];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    BOOL bWeiBoShare = [[[ApplicationContext sharedInstance]getObjectByKey:@"WeiBoShare"]boolValue];
    
    if (!bWeiBoShare) {
        [[ApplicationContext sharedInstance] saveObject:@(NO) byKey:@"WeiBoShare"];
        [_mainNavigationController autoLoginWhenStart];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    /*BOOL bStartScreen = [[[ApplicationContext sharedInstance]getObjectByKey:@"WeiBoLogin"]boolValue];
    
    if (!_bFirstAutoLogin && !bStartScreen) {
        [_mainNavigationController autoLoginWhenStart];
    }
    
    _bFirstAutoLogin = NO;*/
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
