//
//  HKChinaModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKChinaModel.h"
@implementation HKChinaModel
MJExtensionCodingImplementation
-(NSMutableArray<HKProvinceModel *> *)provinces{
    if (!_provinces) {
        _provinces = [NSMutableArray array];
    }
    return _provinces;
}
@end
