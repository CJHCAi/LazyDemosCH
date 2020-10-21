//
//  HMQuestionModel.m
//  猜图游戏
//
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMQuestionModel.h"

@implementation HMQuestionModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;

}
+ (instancetype)questionWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
