//
//  BaiduMobAdDubao.h
//  BaiduMobAdSDK
//
//  Created by baidu on 16/7/24.
//  Copyright © 2016年 Baidu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdDubaoDelegate.h"
#import "BaiduMobAdCommonConfig.h"

@interface BaiduMobAdDubao : NSObject

/**
 *  委托对象
 */
@property (nonatomic ,assign) id<BaiduMobAdDubaoDelegate> delegate;


/**
 *  设置/获取代码位id
 */
@property (nonatomic,copy) NSString* AdUnitTag;



/**
 *  SDK版本
 */
@property (nonatomic, readonly) NSString* Version;
//
///**
// *  应用启动时展示开屏广告
// */
//- (void)loadAndDisplayUsingKeyWindow:(UIWindow *)keyWindow;
//
///**
// *  应用启动时展示半屏开屏广告
// */
//- (void)loadAndDisplayUsingContainerView:(UIView *)view;

/**
 *  展示度宝广告
 */
- (void) showAd;
/**
 *  关闭度宝广告释放资源
 */
- (void)closeAd;

/**
 *  设置度宝的初始化位置
 */
- (void)setPosition:(BaiduMobAdDubaoPosition)style marginPercent:(double)percent;




@end
