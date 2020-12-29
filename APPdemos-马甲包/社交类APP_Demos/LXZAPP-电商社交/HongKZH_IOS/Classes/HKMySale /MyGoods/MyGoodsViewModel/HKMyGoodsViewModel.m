//
//  HKMyGoodsViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyGoodsViewModel.h"
#import "HKMyGoodsRespone.h"
@implementation HKMyGoodsViewModel
+(void)loadMyUpperProduct:(NSDictionary*)dict andType:(int)type success:(void (^)(HKMyGoodsRespone* respone))success{
    NSString*url = get_myUpperProduct;
    if (type == 1) {
        url = get_myLowerProduct;
    }
    [HK_BaseRequest buildPostRequest:url body:dict success:^(id  _Nullable responseObject) {
        HKMyGoodsRespone*respone = [HKMyGoodsRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKMyGoodsRespone*respone = [[HKMyGoodsRespone alloc]init];
        respone.code = 1;
        success(respone);
    }];
}
+(void)searchGoods:(NSDictionary*)dict success:(void (^)(HKMyGoodsRespone* respone))success{
    
    [HK_BaseRequest buildPostRequest:get_myAllProduct body:dict success:^(id  _Nullable responseObject) {
        HKMyGoodsRespone*respone = [HKMyGoodsRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKMyGoodsRespone*respone = [[HKMyGoodsRespone alloc]init];
        respone.code = 1;
        success(respone);
    }];
}
+(void)goodUpperLowerProductWithProductId:(NSString*)productId andState:(int)state success:(void (^)(HKBaseResponeModel*respone))success failure:(void (^_Nullable)(NSError *_Nullable error))failure{
    NSDictionary *dict = @{@"loginUid":HKUSERLOGINID,@"productId":productId,@"state":@(state)};
    [HK_BaseRequest buildPostRequest:get_upperLowerProduct body:dict success:^(id  _Nullable responseObject) {
        HKBaseResponeModel * respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        failure(error);
    }];
}
@end
