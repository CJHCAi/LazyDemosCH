//
//  NSString+CCRegular.h
//  CCTextField
//
//  Created by cyd on 2019/2/25.
//  Copyright © 2019 cyd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CCRegular)

#pragma mark - 输入限制
// 中文
- (BOOL)isCHZN;
// 数字
- (BOOL)isNumber;
// 字母
- (BOOL)isLetter;
// 标点符号
- (BOOL)isPunctuation;
// 特殊字符
- (BOOL)isSpecialCharacter;
// 空格
- (BOOL)isSpace;
// ,
- (BOOL)isComma;
// .
- (BOOL)isAnend;
// -
- (BOOL)isMinusSign;

#pragma mark - 输入校验
// 电话
- (BOOL)isTel;
// 日期
- (BOOL)isDate;
// 浮点数
- (BOOL)isFloat;
// 邮箱
- (BOOL)isEmail;
// 手机
- (BOOL)isPhone;
// 金额
- (BOOL)isMoney;
// 身份证
- (BOOL)isIDCard;
// 域名
- (BOOL)isDomain;
// 邮编
- (BOOL)isZipCode;
// 帐号
- (BOOL)isAccount;
// 密码
- (BOOL)isPassword;
// 强密码
- (BOOL)isStrongPassword;

@end

NS_ASSUME_NONNULL_END
