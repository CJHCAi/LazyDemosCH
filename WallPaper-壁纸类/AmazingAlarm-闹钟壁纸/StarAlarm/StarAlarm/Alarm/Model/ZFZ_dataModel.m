//
//  ZFZ_dataModel.m
//  StarAlarm
//
//  Created by 谢丰泽 on 16/4/12.
//  Copyright © 2016年 YYL. All rights reserved.
//

#import "ZFZ_dataModel.h"

@implementation ZFZ_dataModel

- (instancetype)initWithDateSource:(NSDictionary *)dataSource
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dataSource];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.customId = value;
    }
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end
