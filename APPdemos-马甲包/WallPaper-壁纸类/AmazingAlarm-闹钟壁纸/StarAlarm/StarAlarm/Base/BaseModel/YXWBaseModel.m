//
//  YXWBaseModel.m
//  StarAlarm
//
//  Created by dllo on 16/3/30.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWBaseModel.h"

@implementation YXWBaseModel

- (instancetype)initWithDataSource:(NSDictionary *)dataSource;
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dataSource];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end
