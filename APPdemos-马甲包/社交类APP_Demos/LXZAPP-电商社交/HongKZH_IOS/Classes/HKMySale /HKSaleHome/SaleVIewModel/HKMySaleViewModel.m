//
//  HKMySaleViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMySaleViewModel.h"
#import "HK_BaseRequest.h"
@implementation HKMySaleViewModel
+(void)loadMySale:(NSDictionary*)dict success:(void (^)( HKMySaleRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_myseller body:dict success:^(id  _Nullable responseObject) {
        HKMySaleRespone *respone = [HKMySaleRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        
    }];
}
@end
