//
//  HK_FollowFansResponse.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HK_BaseRequest.h"
@interface HK_FollowFansResponse : NSObject

/***
 *  获取粉丝 关注列表
 */
+(void)getFansFollowListWith:(FollowFansType)type CurentPage:(NSInteger)page successBlock:(void(^)(id object))successObject failed:(void(^)(NSString * error))fail;


/***
 *  获取类型下的API
 */
+(NSString *)apiStrFromType:(FollowFansType)type;


/***
 *  关注用户 根据ID
 */
+(void)followSomeOneByIdString:(NSString *)idStr andType:(FollowFansType)type successBlock:(void(^)(id object))successObject failed:(void(^)(NSString * error))fail;

/***
 *  取消关注用户 根据ID
 */
+(void)CanCelSomeOneByIdString:(NSString *)idStr andType:(FollowFansType)type successBlock:(void(^)(id object))successObject failed:(void(^)(NSString * error))fail;
/***
 *  增加好友
 */
+(void)addFriendWithUid:(NSString *)uid successBlock:(void(^)(id object))successObject failed:(void(^)(NSString * error))fail;


@end
