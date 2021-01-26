//
//  NSObject+CCPObjc.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/27.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "NSObject+CCPObjc.h"
#import <objc/runtime.h>

@implementation NSObject (CCPObjc)

//获得所有属性名称
- (NSArray *)getPropertyNames {
    NSMutableArray *arr = [NSMutableArray array];
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        [arr addObject:[NSString stringWithUTF8String:propertyName]];
    }
    return arr;
}

@end
