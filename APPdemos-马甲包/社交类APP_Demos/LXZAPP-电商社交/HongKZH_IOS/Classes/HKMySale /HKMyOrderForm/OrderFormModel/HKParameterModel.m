//
//  HKParameterModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKParameterModel.h"

@implementation HKParameterModel
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageNum = 1;
    }
    return self;
}
@end
