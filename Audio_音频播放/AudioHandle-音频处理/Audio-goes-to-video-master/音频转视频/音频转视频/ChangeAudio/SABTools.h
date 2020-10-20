//
//  SABTools.h
//  音频转视频
//
//  Created by dszhangyu on 2018/8/15.
//  Copyright © 2018年 dszhangyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SABTools : NSObject
/**
 是否有操作相册的权限
 
 @param authori yes表示可以访问相册
 */
+(void)photoAuthorization:(void(^)(bool authori))authori;

/**
 将视频文件保存相册中
 
 @param videoPath 视频路径
 @param complete 是否保存成功Yes成功
 */
+(void)saveVideoForPhoto:(NSString * )videoPath complet:(void(^)(NSString *  descirp))complete;

@end
