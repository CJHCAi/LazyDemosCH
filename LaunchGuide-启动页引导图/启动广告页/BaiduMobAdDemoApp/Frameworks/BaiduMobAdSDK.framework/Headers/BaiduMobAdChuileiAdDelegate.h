//
//  BaiduMobAdChuileiAdDelegate.h
//  BaiduMobAdSDK
//
//  Created by lishan04 on 16/7/11.
//  Copyright © 2016年 Baidu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdNativeAdDelegate.h"
#import "BaiduMobAdChuileiAdView.h"

@protocol BaiduMobAdChuileiAdDelegate <BaiduMobAdNativeAdDelegate>
@required
/**
 *  应用在union.baidu.com上的APPID
 */
- (NSString *)publisherId;

/**
 * 广告位id
 */
-(NSString*)apId;

@optional
/**
 * 广告请求成功
 * @param 请求成功的AdObject数组，如果只成功返回一条广告，数组大小为1
 */
- (void)onAdObjectsSuccessLoad:(NSArray*)adsArray;
/**
 *  广告请求失败
 * @param 失败的类型 BaiduMobFailReason
 */
- (void)onAdsFailLoad:(BaiduMobFailReason) reason;

/**
 *  广告点击
 */
- (void)onAdClicked:(BaiduMobAdChuileiAdView*)adView;

/**
 *  广告详情页关闭
 */
-(void)didDismissLandingPage:(BaiduMobAdChuileiAdView *)adView;
@end
