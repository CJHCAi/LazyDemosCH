//
//  HKAddHeadViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAddHeadViewModel.h"
#import "HK_BaseRequest.h"
#import "HKRecommendFansModel.h"
#import "HKMobileRequestModel.h"
@implementation HKAddHeadViewModel
+(void)loadRecommendedUsers
:(NSDictionary*)dict success:(void (^)( HKRecommendFansModel *model))success{
    [HK_BaseRequest buildPostRequest:get_recommendFans body:dict success:^(id  _Nullable responseObject) {
        HKRecommendFansModel *model = [HKRecommendFansModel mj_objectWithKeyValues:responseObject];
        success(model);
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)loadMobile
:(NSDictionary*)dict success:(void (^)(HKMobileRequestModel *model))success{
    [HK_BaseRequest buildPostRequest:get_mobile body:dict success:^(id  _Nullable responseObject) {
        HKMobileRequestModel*model = [HKMobileRequestModel mj_objectWithKeyValues:responseObject];
        DLog(@"");
        success(model);
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)followAdd:(NSDictionary*)dict success:(void (^)(BOOL isSuc))success{
    [HK_BaseRequest buildPostRequest:get_followAdd body:dict success:^(id  _Nullable responseObject) {
        DLog(@"");
        if ([responseObject[@"code"] integerValue]==0) {
            success(YES);
        }else{
            success(NO);
        }
    } failure:^(NSError * _Nullable error) {
        success(NO);
    }];
}
+(void)followDelete:(NSDictionary*)dict success:(void (^)(BOOL isSuc))success{
    [HK_BaseRequest buildPostRequest:get_followDelete body:dict success:^(id  _Nullable responseObject) {
        DLog(@"");
        if ([responseObject[@"code"] integerValue]==0) {
            success(YES);
        }else{
            success(NO);
        }
    } failure:^(NSError * _Nullable error) {
        success(NO);
    }];
}
@end
