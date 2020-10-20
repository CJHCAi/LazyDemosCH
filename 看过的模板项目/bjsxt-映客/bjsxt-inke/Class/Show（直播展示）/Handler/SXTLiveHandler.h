//
//  SXTLiveHandler.h
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/2.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTBaseHandler.h"

@interface SXTLiveHandler : SXTBaseHandler

/**
 *  获取热门直播信息
 *
 *  @param success
 *  @param failed
 */
+ (void)executeGetHotLiveTaskWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed;

/**
 *  获取附近的直播信息
 *
 *  @param success
 *  @param failed
 */

+ (void)executeGetNearLiveTaskWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed;

/**
 *  获取广告页
 *
 *  @param success
 *  @param failed
 */

+ (void)executeGetAdvertiseTaskWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed;

@end
