//
//  BaiduMobAdInterstitial.h
//  BaiduMobAdSDK
//
//  Created by LiYan on 16/4/13.
//  Copyright © 2016年 Baidu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdInterstitialDelegate.h"
/*
 * 5 插屏广告：其他场景中使用 BaiduMobAdViewTypeInterstitialOther
 * 7 插屏广告：视频图片前贴片 BaiduMobAdViewTypeInterstitialBeforeVideo 有倒计时5s
 * 8 插屏广告：视频暂停贴片 BaiduMobAdViewTypeInterstitialPauseVideo 没有倒计时
 */
typedef enum _BaiduMobAdInterstitialType {
    BaiduMobAdViewTypeInterstitialOther = 5,
    BaiduMobAdViewTypeInterstitialBeforeVideo = 7,
    BaiduMobAdViewTypeInterstitialPauseVideo = 8
    
} BaiduMobAdInterstitialType;

@interface BaiduMobAdInterstitial : NSObject
/**
 *  委托对象
 */
@property (nonatomic ,assign) id<BaiduMobAdInterstitialDelegate> delegate;


/**
 *  插屏广告类型
 */
@property (nonatomic) BaiduMobAdInterstitialType interstitialType;

/**
 *  插屏广告是否准备好
 */
@property (nonatomic) BOOL isReady;

/**
 *  设置/获取代码位id
 */
@property (nonatomic,copy) NSString* AdUnitTag;

/**
 *  SDK版本
 */
@property (nonatomic, readonly) NSString* Version;

/**
 *  实时加载并显示插屏广告.会卡住约两秒钟,影响用户体验,不建议使用.
 */
- (void)loadAndDisplayUsingKeyWindow:(UIWindow *)keyWindow;

/**
 *  加载插屏广告
 */
- (void)load;

/**
 *  展示插屏广告
 */
- (void)presentFromRootViewController:(UIViewController *)rootViewController;

/**
 * 加载自定义大小的插屏,必须大于100*150
 */
- (void)loadUsingSize:(CGRect)rect;

/**
 * 展示自定义大小的插屏
 */
- (void)presentFromView:(UIView *)view;
@end
