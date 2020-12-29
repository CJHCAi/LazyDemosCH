//
//  HKNewPerSonTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKNewPerSonTool.h"

@implementation HKNewPerSonTool

+(void)getNewPersonBaseDataSuccessBlock:(void(^)(HKNewPerSonTypeResponse *renponse))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_shopGetNewUserVip body:nil success:^(id  _Nullable responseObject) {
        HKNewPerSonTypeResponse *response =[HKNewPerSonTypeResponse mj_objectWithKeyValues:responseObject];
        if (response.code==0) {
            success(response);
        }else {
            error(response.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getTypeNewUserListWithId:(NSString *)typeId pageNumber:(NSInteger)page SuccessBlock:(void(^)(HKNewPersonResponse *renponse))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:shop_GetNewUserVipList body:@{@"typeId":typeId,@"pageNumber":@(page)} success:^(id  _Nullable responseObject) {
        HKNewPersonResponse *res =[HKNewPersonResponse mj_objectWithKeyValues:responseObject];
        if (res.code==0) {
            success(res);
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getUserVipDetailWithVipCouponId:(NSString *)vipCounponId SuccessBlock:(void(^)(HKUserVipResponse *renponse))success fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_shopGetNewUserVipCouponByCouponId body:@{@"vipCouponId":vipCounponId} success:^(id  _Nullable responseObject) {
        HKUserVipResponse * vip =[HKUserVipResponse mj_objectWithKeyValues:responseObject];
        if (vip.code==0) {
            success(vip);
        }else {
            error(vip.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

@end
