//
//  Global.h
//  上网管理 － 学龄宝
//
//  Created by MAC on 15/2/4.
//  Copyright (c) 2015年 SaiHello. All rights reserved.
//

#ifndef ___________Global_h
#define ___________Global_h

#define InitH(name) \
- (instancetype)initWithDict:(NSDictionary *)dict; \
+ (instancetype)name##WithDict:(NSDictionary *)dict;

#define InitM(name)\
- (instancetype)initWithDict:(NSDictionary *)dict \
{ \
    if (self = [super init]) { \
        [self setValuesForKeysWithDictionary:dict]; \
    } \
    return self; \
} \
+ (instancetype)name##WithDict:(NSDictionary *)dict \
{\
    return [[self alloc] initWithDict:dict]; \
}

#endif
