//
//  HKMyGoodsViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
@class HKMyGoodsRespone;
@interface HKMyGoodsViewModel : HKBaseViewModel
+(void)loadMyUpperProduct:(NSDictionary*)dict andType:(int)type success:(void (^)(HKMyGoodsRespone* respone))success;
+(void)searchGoods:(NSDictionary*)dict success:(void (^)(HKMyGoodsRespone* respone))success;

/**
 商品上下架

 @param productId 商品ID
 @param state string
 (query)
 
 
 1上架0下架

 @param success 结果
 @param failure 错误结果
 */
+(void)goodUpperLowerProductWithProductId:(NSString*)productId andState:(int)state success:(void (^)(HKBaseResponeModel*respone))success failure:(void (^_Nullable)(NSError *_Nullable error))failure;
@end
