//
//  ARResultGroup.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARResultGroup.h"

@implementation ARResultGroup

- (NSMutableArray *)resultsArr{
    if(_resultsArr == nil){
        _resultsArr = [NSMutableArray array];
        
    }
    return _resultsArr;
}

@end
