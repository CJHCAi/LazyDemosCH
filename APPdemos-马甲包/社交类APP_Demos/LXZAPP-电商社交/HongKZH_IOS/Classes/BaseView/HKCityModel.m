//
//  HKCityModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCityModel.h"

@implementation HKCityModel
MJExtensionCodingImplementation
-(NSMutableArray *)areas{
    if (!_areas) {
        _areas = [NSMutableArray array];;
    }
    return _areas;
}
@end
