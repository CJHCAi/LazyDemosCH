//
//  AppDelegate.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTabBar.h"
#import "LCTabBarController.h"
@class UnityAppController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIScrollViewDelegate,LCTabBarDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign)BOOL isshow;
@property (strong, nonatomic) LCTabBarController *tabView;
@property (nonatomic,assign)NSInteger from;
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backtaskIdentifier;
@property (strong, nonatomic) UIWindow *unityWindow;
//@property (strong, nonatomic) UnityAppController *unityController; //
- (void)showUnityWindow;
- (void)hideUnityWindow; /** 通用APP启动接口 */
-(void)commonInitLaunch; /** 检查APP版本信息 */
-(void)checkAPPVerson;
+(AppDelegate *)sharedDelegate;
-(void)StartMyUnity3DGames; //开启unity
@property (nonatomic, copy)NSString *testCodel;
@property(nonatomic, assign) BOOL allowRotation;
@end

