//
//  LoginModel.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/30.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "LoginModel.h"

static LoginModel *loginModel = nil;

@implementation LoginModel
+(instancetype)sharedLoginMode{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginModel = [[LoginModel alloc] init];
    });
    
    return loginModel;
}

@end


@implementation LoginInfoModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"userId":@"id"
             };
}

@end






