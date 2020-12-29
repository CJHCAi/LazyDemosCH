//
//  HK_RecruitPosition.m
//  HongKZH_IOS
//
//  Created by zhj on 2018/7/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_RecruitPosition.h"

@implementation HK_RecruitPosition

- (BaseModel *)data {
    if(!_data) {
        _data = [[BaseModel alloc] init];
    }
    return _data;
}

@end
