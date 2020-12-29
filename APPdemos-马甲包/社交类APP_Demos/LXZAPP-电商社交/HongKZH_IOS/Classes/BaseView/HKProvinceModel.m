//
//  HKProvinceModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKProvinceModel.h"

@implementation HKProvinceModel
MJExtensionCodingImplementation
-(NSMutableArray<HKCityModel *> *)citys{
    if (!_citys) {
        _citys = [NSMutableArray array];
    }
    return _citys;
}
@end
