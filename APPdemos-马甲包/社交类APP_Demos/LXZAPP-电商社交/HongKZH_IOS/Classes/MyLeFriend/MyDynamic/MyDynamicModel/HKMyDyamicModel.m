//
//  HKMyDyamicModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyDyamicModel.h"
#import "HKMydyamicDataModel.h"
@implementation HKMyDyamicModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKMydyamicDataModel class]};
}
@end
