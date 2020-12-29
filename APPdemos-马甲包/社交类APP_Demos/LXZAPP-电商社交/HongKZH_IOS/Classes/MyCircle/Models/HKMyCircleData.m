//
//  HKMyCircleData.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyCircleData.h"
#import "HKMyPostViewModel.h"
#import "HKProductsModel.h"
#import "HKMyCircleMemberModel.h"
@implementation HKMyCircleData
+ (NSDictionary *)objectClassInArray{
    return @{@"posts" : [HKMyPostModel class],@"products":[HKProductsModel class],@"members":[HKMyCircleMemberModel class]};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end
