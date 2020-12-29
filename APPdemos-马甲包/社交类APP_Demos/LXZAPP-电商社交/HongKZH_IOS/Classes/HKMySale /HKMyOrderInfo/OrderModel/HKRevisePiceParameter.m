//
//  HKRevisePiceParameter.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRevisePiceParameter.h"

@implementation HKRevisePiceParameter
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loginUid = HKUSERLOGINID;
    }
    return self;
}
@end
