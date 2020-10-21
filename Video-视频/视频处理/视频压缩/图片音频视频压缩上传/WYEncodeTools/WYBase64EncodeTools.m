//
//  WYBase64EncodeTools.m
//  WYEncodeAndEncryptDemo
//
//  Created by Mac mini on 16/7/18.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import "WYBase64EncodeTools.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation WYBase64EncodeTools

// 编码
+ (void)base64StringFromString:(NSString *)filePathString
                    SuccessBlock:(SuccessBlock)success
                     FailedBlock:(FailedBlock)failed {
    
    // 获取文件的二进制数据 data
    NSData *data = [NSData dataWithContentsOfFile:filePathString];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 转码 --> 码文
        NSString *base64String = [data base64EncodedStringWithOptions:0];
        
        if (base64String) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                success(base64String);
            });
        }else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                failed();
            });
        }
    });
}

+ (void)base64StringFromData:(NSData *)fileData
                      SuccessBlock:(SuccessBlock)success
                   FailedBlock:(FailedBlock)failed {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 转码 --> 码文
        NSString *base64String = [fileData base64EncodedStringWithOptions:0];
        
        if (base64String) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                success(base64String);
            });
        }else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                failed();
            });
        }
    });
}


@end
