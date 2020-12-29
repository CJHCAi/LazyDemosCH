//
//  HK_SaveOrderBaseModel.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_SaveOrderBaseModel.h"
#import "HK_SaveOrderDataModel.h"
@implementation HK_SaveOrderBaseModel
-(HK_SaveOrderDataModel *)data
{
    if (!_data) {
        _data = [[HK_SaveOrderDataModel alloc] init];
    }
    return _data;
}
@end
