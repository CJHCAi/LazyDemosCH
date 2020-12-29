//
//  HKShopTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKShopResponse.h"
#import "HK_BaseRequest.h"
#import "HKShopInfo.h"
#import "HKRecondShopResponse.h"
#import "HKShopNewGoods.h"
@interface HKShopTool : NSObject
/**
 *  店铺页
 */
+(void)getShopInfoWithShopID:(NSString *)shopId SuccessBlock:(void(^)(HKShopResponse *response))response fail:(void(^)(NSString *error))error;

/**
 *  店铺信息
 */
+(void)getShopDetailInfoWithShopId:(NSString *)shopId SuccessBlock:(void(^)(HKShopInfo *response))response fail:(void(^)(NSString *error))error;

/**
 *  收藏/取消收藏..
 */
+(void)collectionShopOrNot:(HKShopResponse *)response successBlock:(void(^)(void))success fail:(void(^)(NSString *error))error;

/**
 *  获取店铺商品页信息(推荐.商品,热销) 根据不同URL
 */
+(void)getShoplistWithUrl:(NSString *)url andShopId:(NSString *)shopId andPages:(NSInteger)page  SuccessBlock:(void(^)(HKRecondShopResponse *response))response fail:(void(^)(NSString *error))error;

/**
 *  获取上新页数据
 */
+(void)getNewGoodsDataByShopId:(NSString *)shopId andPage:(NSInteger)page successBlock:(void(^)(HKShopNewGoods *response))response fail:(void(^)(NSString *error))error;


@end
