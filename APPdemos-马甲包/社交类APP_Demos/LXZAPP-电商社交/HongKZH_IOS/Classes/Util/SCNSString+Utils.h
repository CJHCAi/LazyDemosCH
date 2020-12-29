//
//  SCNSString+Utils.h
//  SeaCat_IOS
//
//  Created by reganan on 15/5/5.
//  Copyright (c) 2015年 reganan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString (SCUtils)

- (NSString *) md5;
- (NSString *) sha1;
//- (NSString *) sha1_base64;
//- (NSString *) md5_base64;
//- (NSString *) base64;
//验证email
-(BOOL)isValidateEmail;
//验证电话号码
-(BOOL)isValidateTelNumber;
// 正则判断手机号码地址格式
- (BOOL)isMobileNumber;
//正则判断纯数字
- (BOOL)isNumber;

-(CGSize)sizeWithFont:(UIFont *)f maxWidth:(CGFloat)w;
- (NSString*)trim;
- (BOOL)isString;
- (BOOL)isEmpty;
@end
