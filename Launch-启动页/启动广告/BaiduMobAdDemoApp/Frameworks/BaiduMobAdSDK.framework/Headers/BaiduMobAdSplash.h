//
//  BaiduMobAdSplash.h
//  BaiduMobAdSDK
//
//  Created by LiYan on 16/5/25.
//  Copyright © 2016年 Baidu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaiduMobAdSplashDelegate.h"
@interface BaiduMobAdSplash : NSObject

/**
 *  委托对象
 */
@property (nonatomic ,assign) id<BaiduMobAdSplashDelegate> delegate;


/**
 *  设置/获取代码位id
 */
@property (nonatomic,copy) NSString* AdUnitTag;

/**
 *  设置开屏广告是否可以点击的属性,开屏默认可以点击。
 */
@property (nonatomic) BOOL canSplashClick;

/**
 *  SDK版本
 */
@property (nonatomic, readonly) NSString* Version;

/**
 *  应用启动时展示开屏广告
 */
- (void)loadAndDisplayUsingKeyWindow:(UIWindow *)keyWindow;

/**
 *  应用启动时展示半屏开屏广告
 */
- (void)loadAndDisplayUsingContainerView:(UIView *)view;
@end
