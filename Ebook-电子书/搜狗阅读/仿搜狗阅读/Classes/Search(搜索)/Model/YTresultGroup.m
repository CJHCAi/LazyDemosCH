//
//  YTresultGroup.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/5.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTresultGroup.h"

@implementation YTresultGroup

- (NSMutableArray *)resultsArr{
    if(_resultsArr == nil){
        _resultsArr = [NSMutableArray array];

    }
    return _resultsArr;
}

@end
