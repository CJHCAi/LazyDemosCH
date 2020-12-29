//
//  HKLeIViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLeIViewModel.h"
#import "HKMyDataRespone.h"
@implementation HKLeIViewModel
+(void)myData:(NSDictionary*)dict success:(void (^)(HKMyDataRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_myData body:dict success:^(id  _Nullable responseObject) {
        HKMyDataRespone*respone = [HKMyDataRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKMyDataRespone*respone = [[HKMyDataRespone alloc]init];
        success(respone);
    }];
}
@end
