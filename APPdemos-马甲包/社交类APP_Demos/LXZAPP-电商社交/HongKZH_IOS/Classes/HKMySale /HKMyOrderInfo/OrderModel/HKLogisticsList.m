//
//  HKLogisticsList.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLogisticsList.h"
#import "HKLogisticsInfoModel.h"
@implementation HKLogisticsList
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [HKLogisticsInfoModel class]};
}
@end
