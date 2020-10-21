//
//  NSString+CCRegular.m
//  CCTextField
//
//  Created by cyd on 2019/2/25.
//  Copyright © 2019 cyd. All rights reserved.
//

#import "NSString+CCRegular.h"

@implementation NSString (CCRegular)

#pragma mark - 输入限制
// 中文
- (BOOL)isCHZN
{
    NSString *tmpRegex = @"^[\\u4e00-\\u9fa5]+$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

// 数字
- (BOOL)isNumber
{
    NSString *tmpRegex = @"^[0-9]+$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

// 字母
- (BOOL)isLetter
{
    NSString *tmpRegex = @"^[A-Za-z]+$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

// 标点符号
- (BOOL)isPunctuation
{
    NSString *tmpRegex = @"^[[:punct:]]+$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

// 特殊字符
- (BOOL)isSpecialCharacter
{
    NSString *tmpRegex = @"((?=[\x21-\x7e]+)[^A-Za-z0-9])+$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

// 空格
- (BOOL)isSpace
{
    return [self isEqualToString:@" "];
}

// ,
- (BOOL)isComma
{
    return [self isEqualToString:@","];
}

// .
- (BOOL)isAnend
{
    return [self isEqualToString:@"."];
}

// -
- (BOOL)isMinusSign
{
    return [self isEqualToString:@"-"];
}

#pragma mark - 输入校验
// 电话
- (BOOL)isTel
{
    NSString *tmpRegex = @"^((\\(\\d{2,3}\\))|(\\d{3}\\-))?(\\(0\\d{2,3}\\)|0\\d{2,3}-)?[1-9]\\d{6,7}(\\-\\d{1,4})?$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

// 日期
- (BOOL)isDate
{
    NSString *tmpRegex = @"\\d{4}-(0?[1-9]|1[0-2])-((0?[1-9])|((1|2)[0-9])|30|31)";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

// 浮点数
- (BOOL)isFloat{
    NSString *tmpRegex = @"^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

// 邮箱
- (BOOL)isEmail
{
    NSString *tmpRegex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

// 手机
- (BOOL)isPhone
{
    if (self.length != 11){ return NO; }
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestmm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmm evaluateWithObject:self];
}

// 金额
- (BOOL)isMoney
{
    NSString *reg = @"^([0-9]+|[0-9]{1,3}(,[0-9]{3})*)(.[0-9]{1,2})?$";
    NSPredicate *regextestmm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [regextestmm evaluateWithObject:self];
}

// 身份证
- (BOOL)isIDCard
{
    if (self.length != 18){ return NO; }
    NSString *reg = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)";
    NSPredicate *regextestmm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [regextestmm evaluateWithObject:self];
}

// 域名
- (BOOL)isDomain
{
    NSString *reg = @"[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(/.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+/.?";
    NSPredicate *regextestmm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [regextestmm evaluateWithObject:self];
}

// 邮编
- (BOOL)isZipCode
{
    NSString *tmpRegex = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

// 帐号
- (BOOL)isAccount
{
    NSString *tmpRegex = @"^[a-zA-Z][a-zA-Z0-9_]{6,}$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

// 密码
- (BOOL)isPassword
{
    NSString *tmpRegex = @"^[a-zA-Z]\\w{6,}$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

// 强密码
- (BOOL)isStrongPassword
{
    NSString *tmpRegex = @"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

@end
