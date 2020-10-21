//
//  AppDelegate.h
//  左侧菜单栏抽屉效果
//
//  Created by junde on 2017/1/11.
//  Copyright © 2017年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YHLeftDrawerController;
@class YHNavgationContrller;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) YHLeftDrawerController *drawerVC;

@property (nonatomic, strong) YHNavgationContrller *centerNav;

@end

