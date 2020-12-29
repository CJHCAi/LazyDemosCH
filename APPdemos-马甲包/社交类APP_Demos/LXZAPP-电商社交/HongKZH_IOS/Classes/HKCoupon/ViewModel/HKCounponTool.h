//
//  HKCounponTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKCouponResponse.h"
#import "HKMyCopunDetailResponse.h"
#import "HKCollagedResponse.h"
#import "HKCollageResPonse.h"
#import "HK_BaseRequest.h"
#import "HKDisCutResponse.h"
#import "HKBVipCopunResponse.h"
#import "HKCollageOrderResponse.h"
#import "HKShareBaseModel.h"
@interface HKCounponTool : NSObject

/**
 *  删除优惠券
 */

+(void)deleteUserCounponWithCounponId:(NSString *)couponId  successBlock:(void(^)(void))success fail:(void(^)(NSString *error))error;
/**
 *  我的优惠券
 */
+(void)getCounponListWithState:(NSInteger )state page:(NSInteger )page successBlock:(void(^)(HKCouponResponse * response))success fail:(void(^)(NSString *error))error;
/**
 *  我的新人专享优惠券
 */
+(void)getMyVipListWithState:(NSInteger)state page:(NSInteger )page successBlock:(void(^)(HKBVipCopunResponse * response))success fail:(void(^)(NSString *error))error;

/**
 *  优惠券详情
 */
+(void)getCouponDetailWithCounponId:(NSString *)couponId  successBlock:(void(^)(HKMyCopunDetailResponse *response))success fail:(void(^)(NSString *error))error;

/**
 *  获取拼团列表
 */
+(void)getCollageListWithsortId:(NSString *)sortId andsortValue:(NSString *)sortValue andPageNumber:(NSInteger)page  successBlock:(void(^)(HKCollagedResponse *response))success fail:(void(^)(NSString *error))error;
/**
 *  拼团详情
 */
+(void)getCollageDetailCounponId:(NSString *)couponId  successBlock:(void(^)(HKCollageResPonse *response))success fail:(void(^)(NSString *error))error;
/**
 *  购买拼团优惠券
 */
+(void)buyCollageOrderWithCollageCounId:(NSString *)collageId successBlock:(void(^)(NSString *response))success fail:(void(^)(NSString *error))error;


/**
 *  购买新人专享优惠券
 */
+(void)buyNewUserVipCuponWithVipCouponId:(NSString *)vipCouponId successBlock:(void(^)(NSString *response))success fail:(void(^)(NSString *error))error;

/**
 *  进行拼团
 */
+(void)buyCollageByOrderId:(NSString *)orderId successBlock:(void(^)(void))success fail:(void(^)(NSString *error))error;

/**
 *  获取优惠券可用时间段
 */
+(NSString *)getConponLastStringWithEndString:(NSString *)end;

/**
 *  获取折扣劵列表
 */
+(void)getDisCutCuponListWithPage:(NSInteger)page  successBlock:(void(^)(HKDisCutResponse *response))success fail:(void(^)(NSString *error))error;
/**
 *  拼团订单详情
 */
+(void)getCollageOrderInfo:(NSString *)orderId  successBlock:(void(^)(HKCollageOrderResponse *response))success fail:(void(^)(NSString *error))error;
/**
 *  通过详情信息返回一个分享的商品参数模型
 */
+(HKShareBaseModel *)getShareModelFromResponse:(id)response controller:(UIViewController *)vc;

@end
