//
//  BaseModel.m
//  MVVM-demo
//
//  Created by shen_gh on 16/4/13.
//  Copyright © 2016年 申冠华. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    NSError *error = nil;
    self =  [self initWithDictionary:dic error:&error];
    return self;
}

@end
