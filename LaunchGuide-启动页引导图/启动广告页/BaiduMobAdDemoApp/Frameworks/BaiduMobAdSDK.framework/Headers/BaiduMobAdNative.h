//
//  BaiduMobAdNative.h
//  BaiduMobAdSdk
//
//  Created by lishan04 on 15-1-8.
//
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdNativeAdDelegate.h"
@class BaiduMobAdNativeAdView;

@interface BaiduMobAdNative : NSObject
/**
 *  应用的APPID
 */
@property(nonatomic, copy) NSString *publisherId;
/**
 *  设置/获取代码位id
 */
@property(nonatomic, copy) NSString *adId;

/**
 * 原生广告delegate
 */
@property (nonatomic ,assign) id<BaiduMobAdNativeAdDelegate> delegate;

/**
 * 模版高度，仅用于信息流模版广告
 */
@property (nonatomic ,retain)  NSNumber *height ;
/**
 * 模版宽度，仅用于信息流模版广告
 */
@property (nonatomic ,retain)  NSNumber *width ;


/**
 * 请求多条原生广告
 */
- (void)requestNativeAds;

@end
