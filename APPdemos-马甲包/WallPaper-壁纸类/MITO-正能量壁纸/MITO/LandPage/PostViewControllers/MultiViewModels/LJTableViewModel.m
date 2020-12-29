//
//  LJTableViewModel.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/31.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJTableViewModel.h"

@implementation LJTableViewModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
