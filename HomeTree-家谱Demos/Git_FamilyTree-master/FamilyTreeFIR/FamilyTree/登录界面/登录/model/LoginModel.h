//
//  LoginModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/5/30.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginInfoModel;

@interface LoginModel : NSObject
/** */
@property (nonatomic, strong) LoginInfoModel *info;
/** 等级*/
@property (nonatomic, assign) NSInteger lv;

+(instancetype)sharedLoginMode;
@end

@interface LoginInfoModel : NSObject
/** id*/
@property (nonatomic, assign) NSInteger userId;
/** 账户名*/
@property (nonatomic, copy) NSString *account;
/** 授权码*/
@property (nonatomic, copy) NSString *auth;



@end


