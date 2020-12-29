//
//  HKMyFriendListViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
#import "HKMediaInfoResponse.h"
#import "HKFrindShopResponse.h"
#import "HKUserVideoResponse.h"
@class HKFriendRespond;
@interface HKMyFriendListViewModel : HKBaseViewModel
+(void)myFriend:(NSDictionary*)parameter success:(void (^)( HKFriendRespond* responde))succes;

/**
 *  加入黑名单
 */
+(void)addFriendToBlackListWithUserId:(NSString *)uid success:(void (^)(id response))succes fial:(void(^)(NSString *error))error;
/**
 *  跳转到举报界面
 */
+(void)addUserContentReportVc:(UIViewController *)controller;
/**
 *  获取自媒体用户信息
 */
+(void)getUserMediaInfoByUid:(NSString *)uid successBlock:(void(^)(HKMediaInfoResponse *response))response fial:(void(^)(NSString *error))error;
/**
 *  根据Id获取用户发布的商品
 */
+(void)getUserShopDataByUid:(NSString *)uid withPage:(NSInteger)page successBlock:(void(^)(HKFrindShopResponse *response))response fial:(void(^)(NSString *error))error;
/**
 *  根据Id获取用户发布的视频
 */
+(void)getUserVideoDataByUid:(NSString *)uid withPage:(NSInteger)page successBlock:(void(^)(HKUserVideoResponse *response))response fial:(void(^)(NSString *error))error;

@end
