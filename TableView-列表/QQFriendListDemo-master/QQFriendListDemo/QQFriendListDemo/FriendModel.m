//
//  FriendModel.m
//  核心动画
//
//  Created by 朱伟阁 on 2019/1/26.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import "FriendModel.h"

@implementation FriendModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)friendWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    //前边key是你想使用的key，后边是返回的key
//    return @{
//
//             };
//}

@end
