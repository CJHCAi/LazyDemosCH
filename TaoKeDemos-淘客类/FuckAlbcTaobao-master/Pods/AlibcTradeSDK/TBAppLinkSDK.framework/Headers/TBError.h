//
//  TBError.h
//  TBAppLinkSDK
//
//  Created by muhuai on 15/9/2.
//  Copyright (c) 2015年 MuHuai. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, TBApplinkErrorTye) {
    APPLINK_ERROR_ITEMID_ILLEGAL = 1,//参数非法,例如itemId为空或含有非数字字符
    APPLINK_ERROR_SHOPID_ILLEGAL = 2,//同上 shoopID非法
    APPLINK_ERROR_H5HURL_ILLEGAL = 3, //URL非法法, 必须为URL格式 例如http://www.taobao.com
    APPLINK_ERROR_SIGN_MISSING   = 4,//sign缺失,未设置黑匣子,或者appSecret缺失
    APPLINK_ERROR_NOT_INSTALL_TB = 5 //手淘未安装或版本不支持
};
@interface TBError : NSObject

@property (nonatomic)TBApplinkErrorTye errorCode;

+ (instancetype)initWithErrorType:(TBApplinkErrorTye)errorType;



@end
