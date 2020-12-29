//
//  HK_SaveOrderDataModel.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_SaveOrderDataModel.h"

@implementation HK_SaveOrderDataModel

-(HK_SaveOrderDataUserModel *)user
{
    if (!_user) {
        _user = [[HK_SaveOrderDataUserModel alloc] init];
    }
    return _user;
}

@end
