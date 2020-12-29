//
//  HKSelfMediaHeadModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelfMediaHeadModel.h"

@implementation HKSelfMediaHeadModel
+ (NSDictionary *)objectClassInArray{
    return @{@"top" : [CategoryTop10ListModel class],@"carousels":[HKSowingModel class]};
}
@end
