//
//  HKSetTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HK_BaseRequest.h"
#import "HKAccountResponse.h"
#import "HKBlcakListResponse.h"
@interface HKSetTool : NSObject
/**
 *  绑定微信
 */

+(void)bindWechatWithCode:(NSString *)code successBlock:(void(^)(void))success fail:(void(^)(NSString *error))error;
/**
 *  绑定微信
 */
+(void)bindQQWithOpenID:(NSString *)openId userName:(NSString *)name successBlock:(void(^)(void))success fail:(void(^)(NSString *error))error;
/**
 *  获取用户账户信息
 */
+(void)getUserAccountInfoSuccessBlock:(void(^)(HKAccountResponse *response))response fail:(void(^)(NSString *error))error;
/**
 *  设置手机号
 */
+(void)setNewphone:(NSString *)phone successBlock:(void(^)(void))success fail:(void(^)(NSString *error))error;
/**
 *  是否申请过商家
 */
+(void)userIsAsShopsuccessBlock:(void(^)(id response))success fail:(void(^)(NSString *error))error;
/**
 *  申请成为商家
 */
+(void)AppleShopUserWithDic:(NSMutableDictionary *)dic successBlock:(void(^)(id response))success fail:(void(^)(NSString *error))error;
/**
 *  是否实名认证了
 */
+(void)userIsRealNamesuccessBlock:(void(^)(id response))success fail:(void(^)(NSString *error))error;
/**
 *  申请实名认证
 */
+(void)AppleRealNameDic:(NSMutableDictionary *)dic successBlock:(void(^)(id response))success fail:(void(^)(NSString *error))error;
/**
 *  删除黑名单
 */
+(void)removeBlackLikstWithFriendId:(NSString *)friendId successBlock:(void(^)(id response))success fail:(void(^)(NSString *error))error;
/**
 *  获取黑名单列表
 */
+(void)getBlackListWithPage:(NSInteger)page SuccessBlock:(void(^)(HKBlcakListResponse *response))response fail:(void(^)(NSString *error))error;


@end
