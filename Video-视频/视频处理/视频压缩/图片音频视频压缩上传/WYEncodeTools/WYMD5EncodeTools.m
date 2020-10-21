//
//  WYMD5EncodeTools.m
//  WYEncodeAndEncryptDemo
//
//  Created by Mac mini on 16/7/16.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import "WYMD5EncodeTools.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation WYMD5EncodeTools

// 编码
+ (NSString *)md5StringFromString:(NSString *)sourceString {
    
    // 码文数组(16 个字节)
    unsigned char resultArray[16];
    // 编码
    CC_MD5(sourceString.UTF8String, (CC_LONG)strlen(sourceString.UTF8String), resultArray);
    // 码文
    NSMutableString *md5String = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        
        [md5String appendFormat:@"%02X", resultArray[i]];// X 代表十六进制
    }
    
    return md5String;
}


@end
