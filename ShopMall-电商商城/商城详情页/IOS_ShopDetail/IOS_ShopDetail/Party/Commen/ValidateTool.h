//
//  ValidateTool.h
//  HuaGuoYuan
//
//  Created by souwu on 14-6-20.
//  Copyright (c) 2014年 Model. All rights reserved.
//－－－－－－－－－－－－－输入格式的判断类－－－－－－－－－－－－－－－－－

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import <UIKit/UIKit.h>

@interface ValidateTool : NSObject
+ (BOOL)isChinaMobile:(NSString *)phoneNum;
//邮箱
+ (BOOL) validateEmail:(NSString *)email;

//密码单一判断
+ (BOOL)checkIsHaveNumAndLetter:(NSString *)password;

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobileNum;

//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo;

//车型
+ (BOOL) validateCarType:(NSString *)CarType;

//用户名
+ (BOOL) validateUserName:(NSString *)name;

//密码
+ (BOOL) validatePassword:(NSString *)passWord;

//昵称
+ (BOOL) validateNickname:(NSString *)nickname;

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

//设置颜色
+ (UIColor *)colorWithHex:(NSString *)hexColor;

//图片的设置 大小
+ (UIImage *)imageWithColor: (UIColor *) color imageSize:(CGSize)imageSize;

//安全取值
+ (NSString *)objectForKeySafeNum:(id)aKey with:(id)dic;
//未知的值的类型的安全取值
+ (id)objectForKeySafe:(id)aKey with:(id)dic;

//图片的模糊处理
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
//图片大小的比例
//+ (UIImage *)cutImage:(UIImage*)image WithSize:(CGSize)sizeWandH;

@end
