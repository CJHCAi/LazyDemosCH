//
//  BaiduMobCpuInfoManager.h
//  BaiduMobNativeSDK
//
//  Created by JK.PENG on 16/5/4.
//  Copyright © 2016年 lishan04. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaiduMobCpuInfoManager : NSObject

+ (BaiduMobCpuInfoManager *)shared;

/**
 *  返回媒体URL
 *
 *  @param channelId   频道ID
 *  @param appId 应用ID
 *  说明：
 */
- (NSString *)getCpuInfoUrlWithChannelId:(NSString *)channelId
                                   appId:(NSString *)appId;

@end
