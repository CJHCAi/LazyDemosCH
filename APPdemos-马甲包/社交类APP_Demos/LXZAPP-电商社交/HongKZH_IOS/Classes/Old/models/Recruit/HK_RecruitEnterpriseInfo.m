//
//  HK_RecruitEnterpriseInfo.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_RecruitEnterpriseInfo.h"

@implementation HK_RecruitEnterpriseInfo

- (HK_RecruitEnterpriseInfoData *)data {
    if (!_data) {
        _data = [[HK_RecruitEnterpriseInfoData alloc] init];
    }
    return _data;
}

@end
