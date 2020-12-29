//
//  HKShopTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShopTool.h"

@implementation HKShopTool

+(void)getShopInfoWithShopID:(NSString *)shopId SuccessBlock:(void(^)(HKShopResponse *response))response fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_shopGetShopById body:@{@"shopId":shopId,kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKShopResponse * res =[HKShopResponse mj_objectWithKeyValues:responseObject];
        if (res.code ==0) {
            response(res);
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }
     ];
}

+(void)getShopDetailInfoWithShopId:(NSString *)shopId SuccessBlock:(void(^)(HKShopInfo *response))response fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_shopGetShopInfo body:@{@"shopId":shopId} success:^(id  _Nullable responseObject) {
        HKShopInfo * res =[HKShopInfo mj_objectWithKeyValues:responseObject];
        if (res.code ==0) {
            response(res);
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }
     ];
}
+(void)collectionShopOrNot:(HKShopResponse *)response successBlock:(void(^)(void))success fail:(void(^)(NSString *error))error {
    NSString *state = response.data.isCollect ? @"0":@"1";
    [HK_BaseRequest buildPostRequest:get_shopCollectShopById body:@{@"shopId":response.data.shopId,kloginUid:HKUSERLOGINID,@"state":state} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }
     ];
}
+(void)getShoplistWithUrl:(NSString *)url andShopId:(NSString *)shopId andPages:(NSInteger)page  SuccessBlock:(void(^)(HKRecondShopResponse *response))response fail:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:url body:@{@"shopId":shopId,@"pageNumber":@(page)} success:^(id  _Nullable responseObject) {
       HKRecondShopResponse* res =[HKRecondShopResponse mj_objectWithKeyValues:responseObject];
        if (res.code ==0) {
            response(res);
        }else {
            error(res.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }
     ];  
}
+(void)getNewGoodsDataByShopId:(NSString *)shopId andPage:(NSInteger)page successBlock:(void(^)(HKShopNewGoods *response))response fail:(void(^)(NSString *error))error {
    
    [HK_BaseRequest buildPostRequest:get_shopGetShopProductByCreate body:@{@"shopId":shopId,@"pageNumber":@(page)} success:^(id  _Nullable responseObject) {
        HKShopNewGoods *goods =[HKShopNewGoods mj_objectWithKeyValues:responseObject];
        if (goods.code==0) {
            response(goods);
        }else {
            error(goods.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }
     ];
}
@end
