//
//  WOrderSureModel.m
//  FamilyTree
//
//  Created by 王子豪 on 16/8/3.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WOrderSureModel.h"

@implementation WOrderSureModel


+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"pay" : [WPaymoney class], @"shopmoney" : [WShopmoney class], @"kd" : [WKuaidi class]};
}
@end
@implementation WAddress

@end


@implementation WPaymoney

@end


@implementation WShopmoney

@end


@implementation WKuaidi

@end


