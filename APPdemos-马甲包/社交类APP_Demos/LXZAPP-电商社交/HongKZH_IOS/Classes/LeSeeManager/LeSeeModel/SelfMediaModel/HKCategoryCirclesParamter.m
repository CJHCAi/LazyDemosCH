//
//  HKCategoryCirclesParamter.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCategoryCirclesParamter.h"

@implementation HKCategoryCirclesParamter
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sortValue = @"desc";
        self.sortId = @"user_count";
    }
    return self;
}
@end
