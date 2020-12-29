//
//  HK_CodeReceived.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/8/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

typedef enum {
    codeTypeRegister,
    codeTypeGetPassWord, //找回密码
    codePhoneLogin,    //手机验证码登录
    codeChangeMobile  //修改手机号
} codeReceivedType;

@interface HK_CodeReceived : HK_BaseView

@property(nonatomic,copy)NSString * presString;
@property(nonatomic,copy)NSString * phonString;
@property (nonatomic, copy) NSString * previsPhone;
@property (nonatomic, assign)codeReceivedType typeCode;

@end
