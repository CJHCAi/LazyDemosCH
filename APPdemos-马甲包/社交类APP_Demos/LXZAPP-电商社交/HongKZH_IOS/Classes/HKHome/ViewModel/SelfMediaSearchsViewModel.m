//
//  SelfMediaSearchsViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "SelfMediaSearchsViewModel.h"
#import "HKSearchModels.h"
#import "SearchGoodsRespone.h"
#import "HKReconmendBaseResponse.h"
#import "HKSelfMedioheadRespone.h"
@implementation SelfMediaSearchsViewModel
+(void)selfMediaSearchs:(NSDictionary*)dict type:(int)type success:(void (^)(SearchGoodsRespone*respone))success{
    NSString*url = get_searchHistory;
    if (type == 1) {
        
    }
    [HK_BaseRequest buildPostRequest:url body:dict success:^(id  _Nullable responseObject) {
        SearchGoodsRespone *respone = [SearchGoodsRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        SearchGoodsRespone *respone = [[SearchGoodsRespone alloc]init];;
        success(respone);
    }];
    
}
+(void)searcPVideo:(NSDictionary*)dict type:(int)type success:(void (^)(NSMutableArray*dataArray))success{
    NSString*url = get_searchMedias;
    [HK_BaseRequest buildPostRequest:url body:dict success:^(id  _Nullable responseObject) {
        if ([responseObject[@"data"]isKindOfClass:[NSArray class]]) {
            NSMutableArray*array = [HKSearchModels mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            success(array);
        }else{
            success(nil);
        }
    } failure:^(NSError * _Nullable error) {
        success(nil);
    }];
}
+(void)getRecomendListWithDict:(NSDictionary*)dict type:(int)type SuccessBlock:(void(^)(HKReconmendBaseResponse *response))response fail:(void(^)(NSString *error))error {
    NSString*url = get_searchMediaList;
    if (type == 1) {
        url = get_searchMediaList;
    }
    [HK_BaseRequest buildPostRequest:url body:dict success:^(id  _Nullable responseObject) {
        HKReconmendBaseResponse * rec =[HKReconmendBaseResponse mj_objectWithKeyValues:responseObject];
        if (rec.code==0) {
            response(rec);
        }else {
            error(rec.msg);
        }
    } failure:^(NSError * _Nullable erro) {
         error(@"网络异常");
    }
     ];
}
+(void)getRecommendMain:(NSDictionary*)dict type:(int)type SuccessBlock:(void(^)(HKSelfMedioheadRespone *response))response fail:(void(^)(NSString *error))error {
    NSString*url = get_advGetRecommendMain;
    if (type == 1) {
        url = get_advGetRecommendMain;
    }
    [HK_BaseRequest buildPostRequest:url body:dict success:^(id  _Nullable responseObject) {
        HKSelfMedioheadRespone * rec =[HKSelfMedioheadRespone mj_objectWithKeyValues:responseObject];
            response(rec);
       
    } failure:^(NSError * _Nullable erro) {
        error(@"网络异常");
    }
     ];
}
@end
