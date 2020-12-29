//
//  HKBaseParameter.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseParameter.h"

@implementation HKBaseParameter
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray;
}
-(void)setIsAsc:(BOOL)isAsc{
    _isAsc = isAsc;
    if (_isAsc) {
        self.sortValue = @"asc";
    }else{
        self.sortValue = @"desc";
    }
}
@end
