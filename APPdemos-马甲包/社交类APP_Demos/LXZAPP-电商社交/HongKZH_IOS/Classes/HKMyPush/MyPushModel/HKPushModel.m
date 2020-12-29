//
//  HKPushModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPushModel.h"

@implementation HKPushModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tableName = @"systemPushInfo";
        self.whereIdDict=[NSMutableArray arrayWithArray:@[@"sysUid"]];
    }
    return self;
}
@end
