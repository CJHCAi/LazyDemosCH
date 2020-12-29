//
//  HKOrderFormViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
@class HKSellerorderListHeaderPesone,HKSellerorderListRespone,HKOrderFromInfoRespone,HKExpresListRespone,HKRevisePiceParameter,HKLogisticsListResponse;
@interface HKOrderFormViewModel : HKBaseViewModel

/**
 订单头部

 @param success 结果
 */
+(void)sellerorderListHeaderWithsuccess:(void (^)(HKSellerorderListHeaderPesone* responde))success;

/**
 订单列表

 @param dict 参数
 @param success 结果
 */
+(void)sellerorderListByState:(NSDictionary*)dict success:(void (^)( HKSellerorderListRespone* responde))success;

/**
 搜索订单

 @param dict 参数
 @param success 结果
 */
+(void)searchorderListByState:(NSDictionary*)dict success:(void (^)( HKSellerorderListRespone* responde))success;

/**
 订单详情

 @param dict 参数
 @param success 结果
 */
+(void)orderInfo:(NSDictionary*)dict success:(void (^)( HKOrderFromInfoRespone* responde))success;
+(NSString*)orderFormWithStaue:(OrderFormStatue)statue;

/**
 快递公司列表

 @param success <#success description#>
 */
+(void)expresListWithsuccess:(void (^)(HKExpresListRespone* responde))success;

/**
 发货

 @param dict 参数
 @param success 结果
 */
+(void)sellerOrderDeliver:(NSDictionary*)dict success:(void (^)( HKBaseResponeModel* responde))success;

/**
 修改订单价格

 @param parameter 参数模型
 @param success 结构
 */
+(void)sellerupdateorderprice:(HKRevisePiceParameter*)parameter success:(void (^)( HKBaseResponeModel* responde))success;

/**
 关闭订单

 @param parameter 参数
 @param success 结果
 */
+(void)sellerupdatecloseorder:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success;


/**
 查询物流信息

 @param parameter 参数
 @param success 结果
 */
+(void)logisticsInformation:(NSDictionary*)parameter success:(void (^)( HKLogisticsListResponse* responde))success;
@end
