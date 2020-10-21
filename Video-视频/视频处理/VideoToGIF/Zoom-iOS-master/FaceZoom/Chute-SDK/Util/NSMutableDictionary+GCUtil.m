//
//  NSDictionary+GCUtil.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 12/27/12.
//  Copyright (c) 2012 Aleksandar Trpeski. All rights reserved.
//

#import "NSMutableDictionary+GCUtil.h"

@implementation NSMutableDictionary (GCUtil)

- (void)setObjectIfExists:(id)obj forKey:(id)key {
    if (obj) {
        [self setObject:obj forKey:key];
    }
}

@end
