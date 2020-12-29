//
//  HKChargeViewModel.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKChargeViewModel.h"
#import "HK_BaseRequest.h"
@implementation HKChargeViewModel

+(void)getChargeOrderIdWithIntegral:(NSString *)integral successBlock:(void(^)(HKChargeResponse * response))response  fial:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_mediaShopRechargeOrder body:@{kloginUid:HKUSERLOGINID,@"integral":integral} success:^(id  _Nullable responseObject) {
        HKChargeResponse *res =[HKChargeResponse mj_objectWithKeyValues:responseObject];
        if (res.code ==0) {
            response(res);
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
    }];
}
+(void)creatPayInfoWithOrders:(NSString *)ordersId andPayType:(HKPayType)type success:(void (^)(WxAppPayresponse* responde))success {
    [HK_BaseRequest buildPostRequest:payWeixinpay body:@{kloginUid:HKUSERLOGINID,@"ordersId":ordersId,@"type":[NSString stringWithFormat:@"%u",type]} success:^(id  _Nullable responseObject) {
        WxAppPayresponse* responde = [WxAppPayresponse mj_objectWithKeyValues:responseObject];
        success(responde);
    } failure:^(NSError * _Nullable error) {
        WxAppPayresponse* responde = [[WxAppPayresponse alloc]init];
        success(responde);
    }];
    
}



@end
