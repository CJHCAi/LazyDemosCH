//
//  HKPushViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPushViewModel.h"
#import "HKMyPostsRespone.h"
@implementation HKPushViewModel

+(void)myPraisePost:(NSDictionary*)parameter type:(int)type success:(void (^)( HKMyPostsRespone* responde))success{
    NSString*url = @"";
    if (type == 11) {
        url = get_myPraisePost;
    }else{
        url = get_myForwardPost;
    }
    [HK_BaseRequest buildPostRequest:url body:parameter success:^(id  _Nullable responseObject) {
        HKMyPostsRespone*respone = [HKMyPostsRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKMyPostsRespone*respone = [[HKMyPostsRespone alloc]init];
        success(respone);
    }];
}
@end
