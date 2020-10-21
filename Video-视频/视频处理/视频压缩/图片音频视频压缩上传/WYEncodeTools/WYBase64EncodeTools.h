//
//  WYBase64EncodeTools.h
//  WYEncodeAndEncryptDemo
//
//  Created by Mac mini on 16/7/18.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import <Foundation/Foundation.h>

// 主要为的是封装好的转码工具能在子线程中完成转码
typedef void(^SuccessBlock)(NSString *string);// 转码成功后的 Base64 码
typedef void(^FailedBlock)();// 转码失败

@interface WYBase64EncodeTools : NSObject

/**
 *  1. Base64 其实也不是一种加密方式, 它也是一种编码方式; Base64 可以将任意长度的数据编码成一个 (具有唯一性的,由 ASCII 码组成的) 字符串, 因此它也是看起来像是具有加密的效果而已;
    2. Base64 能编码也能解码, 它主要应用于网络传输的一些场景, 比如给服务器上传图片, 音频, 视频等. 因为计算机中所有的数据都是以 ASCII 码存储的, 直接传输二进制流有可能会造成数据传输出错. 实际操作中我们一般只需要将 NSData 数据 Base64 编码后传给服务器就 ok 了, 然后后台会做专门的处理, 我们请求响应的接口就可以获取到这个数据, 并不需要我们解码.
    3. Base64 的大小约是 NSData 大小的 4/3, 但是上传起来更加安全和方便.
 */

// 使用路径给文件编码
+ (void)base64StringFromString:(NSString *)filePathString
                    SuccessBlock:(SuccessBlock)success
                     FailedBlock:(FailedBlock)failed;
// 使用二进制给文件编码
+ (void)base64StringFromData:(NSData *)fileData
                  SuccessBlock:(SuccessBlock)success
                   FailedBlock:(FailedBlock)failed;


@end
