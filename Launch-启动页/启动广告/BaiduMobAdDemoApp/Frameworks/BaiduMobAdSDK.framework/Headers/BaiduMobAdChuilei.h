//
//  BaiduMobAdChuilei.h
//  BaiduMobAdSDK
//
//  Created by lishan04 on 16/7/11.
//  Copyright © 2016年 Baidu Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BaiduMobAdNative.h"
#import "BaiduMobAdChuileiAdDelegate.h"

@interface BaiduMobAdChuilei : BaiduMobAdNative
/**
 *  应用的APPID
 */
@property(nonatomic, copy) NSString *publisherId;
/**
 *  设置/获取代码位id
 */
@property(nonatomic, copy) NSString *adId;
/**
 * 广告delegate
 */
@property (nonatomic ,assign) id<BaiduMobAdChuileiAdDelegate> delegate;
/**
 * 请求多条广告
 */
- (void)requestAds;

@end
