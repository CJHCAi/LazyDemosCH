//
//  WYMD5EncodeTools.h
//  WYEncodeAndEncryptDemo
//
//  Created by Mac mini on 16/7/16.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYMD5EncodeTools : NSObject

/**
 *  1. MD5 其实不是一种加密方式, 它只是一种编码方式; MD5 可以将任意长度的数据编码成一个 (具有唯一性的, 由 32 位十六进制数组成, 占 16 个字节的) 字符串, 因此它看起来像是具有加密的效果而已;
    2. 但是MD5 只能编码不能解码, 因此它主要应用于起验证效果的一些场景, 比如说用户名密码的验证等等.
 */


// 编码
+ (NSString *)md5StringFromString:(NSString *)sourceString;

@end
