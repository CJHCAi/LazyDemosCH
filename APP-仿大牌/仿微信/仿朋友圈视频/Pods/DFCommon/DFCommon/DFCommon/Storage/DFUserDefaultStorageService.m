//
//  DFUserDefaultStorageService.m
//  coder
//
//  Created by Allen Zhong on 15/5/9.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFUserDefaultStorageService.h"

@implementation DFUserDefaultStorageService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _ud = [NSUserDefaults standardUserDefaults];
    }
    return self;
}


-(void)sync
{
    [_ud synchronize];
}
@end
