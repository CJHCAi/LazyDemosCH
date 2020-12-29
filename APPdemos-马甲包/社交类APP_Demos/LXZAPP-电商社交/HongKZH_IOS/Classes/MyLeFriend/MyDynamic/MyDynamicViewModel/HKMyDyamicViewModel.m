//
//  HKMyDyamicViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyDyamicViewModel.h"
#import "HKMyDyamicRespone.h"
#import "HKMyDyamicParameter.h"
@implementation HKMyDyamicViewModel
+(void)getFriendDynamic:(HKMyDyamicParameter*)parameter success:(void (^)( HKMyDyamicRespone* responde))succes{
    NSDictionary *dict = @{@"loginUid":HKUSERLOGINID,@"type":@(parameter.type),@"pageNumber":@(parameter.pageNumber)};
    [HK_BaseRequest buildPostRequest:get_friendDynamic body:dict success:^(id  _Nullable responseObject) {
        HKMyDyamicRespone*respone = [HKMyDyamicRespone mj_objectWithKeyValues:responseObject];
        succes(respone);
    } failure:^(NSError * _Nullable error) {
        HKMyDyamicRespone*respone = [[HKMyDyamicRespone alloc]init];
        succes(respone);
    }];
}
@end
