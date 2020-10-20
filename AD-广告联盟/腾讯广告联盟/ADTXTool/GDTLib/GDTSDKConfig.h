//
//  GDTSDKConfig.h
//  GDTMobApp
//
//  Created by GaoChao on 14/8/25.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDTSDKConfig : NSObject
/**
 * 提供给聚合平台用来设定SDK 流量分类
 */
+ (void)setSdkSrc:(NSString *)sdkSrc;

/**
 * 查看SDK流量来源
 */
+ (NSString *)sdkSrc;

/**
 *  打开HTTPS开关
 *  详解：供流量方设置以使用并获取HTTPS接口和资源，用以支持苹果ATS政策，请在调用广告接口之前设置为true
 *      默认为关闭状态，返回http资源
 */
+ (void)setHttpsOn;

/**
 * 获取 SDK 版本
 */

+ (NSString *)sdkVersion;

@end
