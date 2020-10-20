//
//  LKContentModel.m
//  douYinTest
//
//  Created by Kai Liu on 2019/3/5.
//  Copyright © 2019 Kai Liu. All rights reserved.
//

#import "LKContentModel.h"

#import <MJExtension.h>

@implementation LKContentModel
-(id)initWithDict:(NSDictionary*)dict
{
    if (self == [super init]) {
        self = [LKContentModel mj_objectWithKeyValues:dict];
        NSArray *arr = dict[@"replay"];
        self.maxReplayCount = arr.count;
    }
    return self;
}

+(id)modelWithDict:(NSDictionary*)dict
{
    return [[self alloc] initWithDict:dict];
}
+ (NSDictionary *)objectClassInArray{
    return @{
             @"replay" : [LKContentModel class]
             };
}
@end
