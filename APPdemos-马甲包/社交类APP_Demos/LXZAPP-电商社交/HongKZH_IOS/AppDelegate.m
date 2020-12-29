//
//  AppDelegate.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "AppDelegate.h"
#import "LCTabBar.h"
#import "LCTabBarController.h"
#import "HK_NavigationView.h"
#import "HKLeFriendManagerViewController.h"
#import  "SVProgressHUD.h"
#import "HK_BlackNavigationView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "LCTabBar.h"
#import "HKLEIViewController.h"
#import "ShareMessage.h"
#import "HKFriendViewModel.h"
//#import "UnityAppController+HKGame.h"
//键盘处理
#import "IQKeyboardManager/IQKeyboardManager.h"
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
static NSString *appKey = @"23c0bbc4f88dd77404236706";
static NSString *channel = @"App Store";
static BOOL isProduction = FALSE;
#import "HKBaseViewModel.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "PPGetAddressBook.h"
#import "DatabaseToll.h"
#import "HKLeSeeManagerViewController.h"
#import "HKShoppingHomeViewController.h"
#import "HKBase_HomeController.h"

//集成shareSDK
#import <ShareSDK/ShareSDK.h>


//哈哈传shan

#import "HKMyFriendListViewModel.h"
#import "LEFriendDbManage.h"
#import "HKLeCircleDbManage.h"
#import "HKCliceListRespondeModel.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "RCDRCIMDataSource.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMKit/RongIMKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "HKBurstingActivityShareModel.h"
#import "HKGoodsSendShareModel.h"
#import "HKMarketViewController.h"
#import "UIDevice+TFDevice.h"
@interface AppDelegate ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMConnectionStatusDelegate,AMapLocationManagerDelegate,JPUSHRegisterDelegate,WXApiDelegate,QQApiInterfaceDelegate,UITabBarControllerDelegate>
@property (nonatomic,strong)AMapLocationManager *locationManager;
@property (nonatomic, strong)UIApplication *application;
@property (nonatomic, strong)NSDictionary *launchOptions;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//       self.unityController = [[UnityAppController alloc] init];
//    [_unityController application:application didFinishLaunchingWithOptions:launchOptions];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [DatabaseToll setUpDatabase];
    DLog(@"-----------------FinishLaunching");
    [self jgPush:launchOptions];
    [AMapServices sharedServices].apiKey = @"1aff75d85a2e5cedde53f2fcc174f94a";
    
    [[RCIM sharedRCIM] initWithAppKey:@"mgb7ka1nm4wyg"];
    [[RCIM sharedRCIM]registerMessageType:[ShareMessage class]];
    [[RCIM sharedRCIM]registerMessageType:[HKBurstingActivityShareModel class]];
     [[RCIM sharedRCIM]registerMessageType:[HKGoodsSendShareModel class]];
    [self addRCIM];
    [PPGetAddressBook requestAddressBookAuthorization];
    //关于导航和状态栏的配置
    [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleDefault;
    
    [UINavigationBar appearance].translucent =NO;
    [[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
     [self.window makeKeyAndVisible];
    //    [UserPreferences setBool:NO withKey:@"isLogin"];
    
#pragma mark 全局配置提示框
    [self ToastViewOption];
#pragma mark 计时器进入后台处理
    NSInteger messageCount= [UIApplication sharedApplication].applicationIconBadgeNumber;
    [UIApplication sharedApplication].applicationIconBadgeNumber= messageCount;
    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{
        [self backgroundHandler];
    }];
    if (backgroundAccepted)
    {
    }
    [self backgroundHandler];
//注册微信
    [WXApi registerApp:WeChatAppID];
 
 //集成分享
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
         [platformsRegister setupQQWithAppId:QQAppID appkey:QQAppKey];
        [platformsRegister setupWeChatWithAppId:WeChatAppID appSecret:@""];
    }];

    LCTabBarController *tab=[[LCTabBarController alloc]init];
    tab.delegate = self;
    self.tabView = tab;
    [self initData];
    [self addChildVc:tab];
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    //融云即时通讯
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    
    //开始定位
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    //处理键盘
    [self handleKeyBoard];

    return YES;
}
/** 全局配置信息提示框*/
-(void)ToastViewOption {
    //配置全局的提示文本
    EasyShowOptions *options = [EasyShowOptions sharedEasyShowOptions];
    options.textSuperViewReceiveEvent = YES ;
    [EasyShowOptions sharedEasyShowOptions].textStatusType = 1 ;//
    [EasyShowOptions sharedEasyShowOptions].lodingShowType =6;
    [EasyShowOptions sharedEasyShowOptions].textShadowColor =[UIColor clearColor];
    
}

- (void)handleKeyBoard {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    
    keyboardManager.shouldShowToolbarPlaceholder = NO; // 是否显示占位文字
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}


//接收位置更新,实现AMapLocationManagerDelegate代理的amapLocationManager:didUpdateLocation方法，处理位置更新
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    DLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    [ViewModelLocator sharedModelLocator].latitude = location.coordinate.latitude;
    [ViewModelLocator sharedModelLocator].longitude = location.coordinate.longitude;
    
    if (reGeocode)
    {
        DLog(@"reGeocode:%@", reGeocode);
    }
    //开始定位
    if ([ViewModelLocator sharedModelLocator].latitude >0&&[ViewModelLocator sharedModelLocator].longitude >0) {
        [self.locationManager stopUpdatingLocation];
    }
}

-(void)addRCIM
{
    
 LoginUserData*userData = [LoginUserDataModel getUserInfoItems];
    [[RCIM sharedRCIM] connectWithToken:userData.token                                success:^(NSString *userId) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [[RCIM sharedRCIM] setUserInfoDataSource:RCDDataSource];
        [[RCIM sharedRCIM] setGroupInfoDataSource:RCDDataSource];
        
            RCUserInfo*userInfo = [[RCUserInfo alloc]initWithUserId:userId name:userData.name portrait:userData.headImg];
            [RCIM sharedRCIM].currentUserInfo = userInfo;
             [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userInfo.userId];
        });
        DLog(@"登陆成功。当前登录的用户ID：%@", userId);
         } error:^(RCConnectErrorCode status) {
             DLog(@"登陆的错误码为:%ld", (long)status);
         } tokenIncorrect:^{
             //token过期或者不正确。
             //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
             //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
             DLog(@"token错误");
         }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RCIMFrendNotification" object:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    DLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
/** 
 * 将得到的devicetoken 传给融云用于离线状态接收push ，您的app后台要上传推送证书
 *
 * @param application <#application description#>
 * @param deviceToken <#deviceToken description#>
 */
- (void)application:(UIApplication *)application 
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];

}
/**
 * 网络状态变化。
 *
 * @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        //注意这里下面的4行，根据自己需要修改 也可以注释了，但是只能注释这4行，网络状态变化这个方法一定要实现
        //        [alert show];
        //        //注意这里下面的4行，根据自己需要修改 也可以注释了，但是只能注释这4行，网络状态变化这个方法一定要实现
        //        ViewController *loginVC = [[ViewController alloc] init];
        //        UINavigationController *_navi =
    }
}
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].applicationIconBadgeNumber =
        [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    });
}

-(void)tabBar:(LCTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to {
    
    switch(to)
    {
        case 0:

            self.tabView.selectedIndex = to;
            break;
        case 1:
            self.tabView.selectedIndex = to;

            break;
        case 2:
            if (![LoginUserDataModel isHasSessionId]) {
                
                HK_NavigationView *nav =self.tabView.viewControllers[from];
                UIViewController * vc =nav.topViewController;
                self.tabView.selectedIndex =from;
                [AppUtils presentLoadControllerWithCurrentViewController:vc];
                
            }
            else {
                self.tabView.selectedIndex =to;
            }
           
            break;
        case 3:
        {
            if (![LoginUserDataModel isHasSessionId]) {
                
                HK_NavigationView *nav =self.tabView.viewControllers[from];
                UIViewController * vc =nav.topViewController;
                self.tabView.selectedIndex =from;
                [AppUtils presentLoadControllerWithCurrentViewController:vc];
            
            }
               else {
                  self.tabView.selectedIndex =to;
               }
            break;
        }
        case 4:
                        self.tabView.selectedIndex = to;
            break;
    }
}

#pragma mark 添加子控制器

-(void)addChildVc:(LCTabBarController*)tab
{
//-(void)addChildVc:(LCTabBarController*)tab
    tab.itemImageRatio = 1.0;
    tab.lcTabBar.backgroundColor = [UIColor whiteColor];
    tab.view.backgroundColor = [UIColor whiteColor];
    tab.lcTabBar.delegate = self;
    HKBase_HomeController * lookView =[[HKBase_HomeController alloc] init];
    lookView.tabBarItem.image = [UIImage imageNamed:@"lekan_01"];
    lookView.tabBarItem.selectedImage = [UIImage imageNamed:@"lekan"];
    HKShoppingHomeViewController*buyView = [[HKShoppingHomeViewController alloc]init];
    buyView.view.backgroundColor = [UIColor redColor];
    buyView.tabBarItem.image = [UIImage imageNamed:@"legou_01"];
    buyView.tabBarItem.selectedImage = [UIImage imageNamed:@"legou"];
    
  //  HK_GladlyListChatView  *listChatView=[[HK_GladlyListChatView alloc]init];
    HKMarketViewController*listChatView = [[HKMarketViewController alloc]init];
    listChatView.view.backgroundColor = [UIColor clearColor];
    //    shareView.title = @"乐享";
    listChatView.tabBarItem.image = [UIImage imageNamed:@"leyu_01"];
    listChatView.tabBarItem.selectedImage = [UIImage imageNamed:@"leyu"];
    
    HKLeFriendManagerViewController*friendView=[[HKLeFriendManagerViewController alloc]init];
    friendView.view.backgroundColor = [UIColor clearColor];
    //    friendView.title = @"乐友";
    friendView.tabBarItem.image = [UIImage imageNamed:@"leyou_01"];
    friendView.tabBarItem.selectedImage = [UIImage imageNamed:@"leyou"];
    
    //HK_GladlyUserView *userView=[[HK_GladlyUserView alloc]init];
    HKLEIViewController *userView=[[HKLEIViewController alloc]init];
//
    //    userView.title = @"乐我";
    userView.tabBarItem.image = [UIImage imageNamed:@"leai_01"];
    userView.tabBarItem.selectedImage = [UIImage imageNamed:@"leai"];
    
    HK_NavigationView *looknav=[[HK_NavigationView alloc]initWithRootViewController:lookView];
    HK_NavigationView *buynav=[[HK_NavigationView alloc]initWithRootViewController:buyView];
    HK_NavigationView *sharenav=[[HK_NavigationView alloc]initWithRootViewController:listChatView];
    
    HK_NavigationView *friendnav=[[HK_NavigationView alloc]initWithRootViewController:friendView];
    HK_BlackNavigationView *usernav=[[HK_BlackNavigationView alloc]initWithRootViewController:userView];
    
    tab.viewControllers = @[looknav,buynav,friendnav,usernav];
    tab.tabBarController.delegate = self;
    tab.lcTabBar.delegate = self;
    self.window.rootViewController=tab;
    tab.selectedIndex = 1;
}
#pragma mark 后台线程保证退出仍然执行倒计时
- (void)backgroundHandler {
    @weakify(self)
    self.backtaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        @strongify(self)
        [[UIApplication sharedApplication] endBackgroundTask:self.backtaskIdentifier];
        self.backtaskIdentifier = UIBackgroundTaskInvalid;
        [[UIApplication sharedApplication] clearKeepAliveTimeout];
    }];
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
   
    if ([url.scheme isEqualToString:WeChatAppID]) {
        
         return [WXApi handleOpenURL:url delegate:self];
  
    }else if ([url.host isEqualToString:@"safepay"]) {
        [self payResultWithUrl:url];
        return YES;
    }
    [QQApiInterface handleOpenURL:url delegate:self];
    return [TencentOAuth HandleOpenURL:url];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme isEqualToString:WeChatAppID]) {
        return [WXApi handleOpenURL:url delegate:self];
        
    }else if ([url.host isEqualToString:@"safepay"]){
        //支付宝
        [self payResultWithUrl:url];
        return YES;
    }
    [QQApiInterface handleOpenURL:url delegate:self];
    return [TencentOAuth HandleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.scheme isEqualToString:WeChatAppID]) {
        return [WXApi handleOpenURL:url delegate:self];
        
    }else if ([url.host isEqualToString:@"safepay"]) {
       //支付宝结果.
        [self payResultWithUrl:url];
        return YES;
    }
    [QQApiInterface handleOpenURL:url delegate:self];
    return [TencentOAuth HandleOpenURL:url];
}
#pragma mark 处理支付宝支付结果
-(void)payResultWithUrl:(NSURL*)url {
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        DLog(@"支付宝客户端支付结果result = %@",resultDic);
        if (resultDic && [resultDic objectForKey:@"resultStatus"] && ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000)) {
            // 发通知带出支付成功结果
            [[NSNotificationCenter defaultCenter] postNotificationName:AliPayOrderResult object:resultDic];
        } else {
            // 发通知带出支付失败结果
            [[NSNotificationCenter defaultCenter] postNotificationName:AliPayOrderResult  object:resultDic];
        }
    }];
}
#pragma mark 调用微信返回 发送通知
-(void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp * loginRes =(SendAuthResp *)resp;
        NSString *code =loginRes.code;
        [[NSNotificationCenter defaultCenter] postNotificationName:WeChatLoginMessage object:code];
    }else if ([resp isKindOfClass:[PayResp class]]) {
        
       //微信支付.....回调 发起通知到充值页面处理..
        switch (resp.errCode) {
        case WXSuccess:{
            //支付返回结果，实际支付结果需要去自己的服务器端查询
            NSNotification *notification = [NSNotification notificationWithName:WechatPayResult object:@"success"];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
            break;
        default:{
            NSNotification *notification = [NSNotification notificationWithName:WechatPayResult object:@"fail"];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
            break;
        }
    }
}
-(void)jgPush:(NSDictionary*)launchOptions{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"23c0bbc4f88dd77404236706"
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    //退到后台
//- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [UIApplication sharedApplication].idleTimerDisabled = NO;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [UIApplication sharedApplication].idleTimerDisabled = YES;
//
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber =0;
    if ([LoginUserDataModel isHasSessionId]) {
        
        [self initLeFriendData];
    }
}
-(void)StartMyUnity3DGames
{
//-(void)StartMyUnity3DGames
//{
//    [_unityController applicationDidBecomeActive:[UIApplication sharedApplication]];
}
- (void)applicationWillTerminate:(UIApplication *)application {
//}
//- (void)applicationWillTerminate:(UIApplication *)application {
//    [UIApplication sharedApplication].idleTimerDisabled = NO;
}
-(void)initData{
    
    DLog(@"loginid:%@",HKUSERLOGINID);
    [HKBaseViewModel initDataSuccess:^(BOOL isSave, HKInitializationRespone *respone) {
        
    }];
    [HKBaseViewModel getShopDataSuccess:^(BOOL isSave, HKShopDataInitRespone *respone) {
        
    }];
    [HKBaseViewModel initCityDataSuccess:^(BOOL isSave, HKChinaModel *respone) {
        
    }];
    [HKBaseViewModel initCountryDataSuccess:^(BOOL isSave, NSMutableArray *dataArray) {
        
    }];
    if ([LoginUserDataModel isHasSessionId]) {
        
        [self initLeFriendData];
    }
    
}
-(void)initLeFriendData{
    [HKMyFriendListViewModel myFriend:@{@"loginUid":HKUSERLOGINID} success:^(HKFriendRespond *responde) {
        
    }];
    [HKFriendViewModel loadClicleList:@{@"loginUid":HKUSERLOGINID} success:^(HKCliceListRespondeModel *responde) {
        
    }];
    
}

//}
//
//-(UIWindow *)unityWindow{
////
-(void)showUnityWindow{ //进入unity界面 //
    //}
//} -(void)showUnityWindow{ //进入unity界面 //
//    //}
//
    
}
-(void)hideUnityWindow{
    //推出Unity界面
    //
//    //推出Unity界面
//    //
//   // [SVProgressHUD showWithStatus:[KAppdelegate testCodel]];
//    UnityPause(true);
}
@end
