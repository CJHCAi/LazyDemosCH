//
//  MarketDataViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "MarketDataViewModel.h"
#import "MarketDataRespone.h"
#import "HKGameProductRespone.h"
#import "HKCouponResponse.h"
@implementation MarketDataViewModel
+(void)myDataMarketSuccess:(void (^)(MarketDataRespone*respone))succes{
    [HK_BaseRequest buildPostRequest:get_myDataMarket body:@{@"loginUid":HKUSERLOGINID,@"pageNumber":@"1"} success:^(id  _Nullable responseObject) {
        MarketDataRespone*respone = [MarketDataRespone mj_objectWithKeyValues:responseObject];
        succes(respone);
    } failure:^(NSError * _Nullable error) {
        MarketDataRespone*respone = [[MarketDataRespone alloc]init];
        succes(respone);
    }];
}
+(void)getCounponList:(void (^)(HKCouponResponse*respone))succes{
    [HK_BaseRequest buildPostRequest:get_myNormalCoupon body:@{@"loginUid":HKUSERLOGINID,@"pageNumber":@"1"} success:^(id  _Nullable responseObject) {
        HKCouponResponse*respone = [HKCouponResponse mj_objectWithKeyValues:responseObject];
        succes(respone);
    } failure:^(NSError * _Nullable error) {
        HKCouponResponse*respone = [[HKCouponResponse alloc]init];
        succes(respone);
    }];
}
+(void)getGameProductRespone:(void (^)(HKGameProductRespone*respone))succes{
    [HK_BaseRequest buildPostRequest:get_gameMyProduct body:@{@"loginUid":HKUSERLOGINID,@"pageNumber":@"1"} success:^(id  _Nullable responseObject) {
        HKGameProductRespone*respone = [HKGameProductRespone mj_objectWithKeyValues:responseObject];
        succes(respone);
    } failure:^(NSError * _Nullable error) {
        HKGameProductRespone*respone = [[HKGameProductRespone alloc]init];
        succes(respone);
    }];
}
@end
