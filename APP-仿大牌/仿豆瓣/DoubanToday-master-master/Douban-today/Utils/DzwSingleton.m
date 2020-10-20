//
//  DzwSingleton.m
//  Douban-today
//
//  Created by dzw on 2018/10/26.
//  Copyright © 2018 dzw. All rights reserved.
//

#import "DzwSingleton.h"

@class DzwSingleton;
@implementation DzwSingleton

static DzwSingleton *_sharedInstance = nil;

+ (DzwSingleton *)sharedInstance{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance.currentCity = @"";
    });
    return _sharedInstance;
}


@end
