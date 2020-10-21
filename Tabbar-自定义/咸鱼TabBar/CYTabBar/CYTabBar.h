//
//  CYTabBar.h
//  蚁巢
//
//  Created by 张春雨 on 2016/11/17.
//  Copyright © 2016年 张春雨. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CYCenterButton.h"
@class CYButton;
@class CYTabBar;

@protocol CYTabBarDelegate <NSObject>
@optional
/**
 *   中间按钮点击通知
 */
- (void)tabbar:(CYTabBar *)tabbar clickForCenterButton:(CYCenterButton *)centerButton;

/**
 *  是否允许切换控制器,(通过TabBarController来直接设置SelectIndex来切换的是不会收到通知的)
 */
- (BOOL)tabBar:(CYTabBar *)tabBar willSelectIndex:(NSInteger)index;

/**
 *  通知已经选择的控制器下标
 */
- (void)tabBar:(CYTabBar *)tabBar didSelectIndex:(NSInteger)index;
@end

@interface CYTabBar : UIView
/** tabbar按钮显示信息 */
@property (copy, nonatomic) NSArray<UITabBarItem *> *items;
/** 其他按钮 */
@property (strong , nonatomic) NSMutableArray <CYButton*>*btnArr;
/** 中间按钮 */
@property (strong , nonatomic) CYCenterButton *centerBtn;
/** tabBar通知委托 */
@property (weak , nonatomic) id<CYTabBarDelegate>delegate;
@end

@interface ContentView : UIView
@property (weak , nonatomic) UITabBarController *controller;
@end

