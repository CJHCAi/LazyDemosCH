//
//  HKChargeViewModel.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKChargeResponse.h"
#import "WxAppPayresponse.h"
@interface HKChargeViewModel : NSObject

/**
 *  创建支付订单
 */
+(void)creatPayInfoWithOrders:(NSString *)ordersId andPayType:(HKPayType)type success:(void (^)(WxAppPayresponse* responde))success;
/**
 *  APP获取充值订单号
 */
+(void)getChargeOrderIdWithIntegral:(NSString *)integral successBlock:(void(^)(HKChargeResponse * response))response  fial:(void(^)(NSString *error))error;


@end
