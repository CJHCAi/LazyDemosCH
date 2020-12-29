//
//  HKReleaseViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReleaseViewModel.h"
#import "RecruitInfoRespone.h"
#import "EnterpriseRecruitListRespone.h"
@implementation HKReleaseViewModel
+(void)getRecruitInfo:(NSDictionary*)parameter success:(void (^)( RecruitInfoRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_recruitInfo body:parameter success:^(id  _Nullable responseObject) {
        
        RecruitInfoRespone*respone = [RecruitInfoRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        RecruitInfoRespone*respone = [[RecruitInfoRespone alloc]init];
        success(respone);
    }];
}
+(void)getEnterpriseRecruitListById:(NSDictionary*)parameter success:(void (^)( EnterpriseRecruitListRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_enterpriseRecruitListById body:parameter success:^(id  _Nullable responseObject) {
        EnterpriseRecruitListRespone*respone = [EnterpriseRecruitListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        EnterpriseRecruitListRespone*respone = [[EnterpriseRecruitListRespone alloc]init];
        success(respone);
    }];
}
@end
