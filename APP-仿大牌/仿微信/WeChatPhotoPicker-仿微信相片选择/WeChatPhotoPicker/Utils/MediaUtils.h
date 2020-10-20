//
//  MediaUtils.h
//  模仿微信相册
//
//  Created by Mac on 16/5/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface MediaUtils : NSObject
/**
 *  @author 嘴爷, 2016-05-26 13:05:15
 *
 *  @brief 获取temp路径
 *
 *  @return temp路径
 */
+(NSString*)getTempPath;

/**
 *  @author 嘴爷, 2016-05-26 13:05:00
 *
 *  @brief 删除temp路径
 */
+(void)deleteTempPath;

/**
 *  @author 嘴爷, 2016-05-27 08:05:26
 *
 *  @brief 删除文件
 *
 *  @param path 文件路径
 */
+(void)deleteFileByPath:(NSString*)path;

/**
 *  @author 嘴爷, 2016-05-27 10:05:34
 *
 *  @brief 获取文件大小(单位/byte)
 *
 *  @param filePath 文件路径
 *
 *  @return 文字大小/字节  /1024 = KB   / 1024 = M
 */
+(long long)getFileSize:(NSString*)filePath;

/**
 *  @author 嘴爷, 2016-05-26 12:05:31
 *
 *  @brief IOS8 之后将手机相册视频写到本地
 *
 *  @param asset       用于读取媒体信息
 *  @param path        存储路径
 *  @param finishBlock 存储完成回调，并反回fileURL
 */
+(void)writePHVedio:(PHAsset*)asset toPath:(NSString*)path block:(void (^)(NSURL* url))finishBlock;

/**
 *  @author 嘴爷, 2016-05-26 15:05:07
 *
 *  @brief 压缩视频文件
 *
 *  @param inputURL  待压缩视频文件路径
 *  @param outputURL 压缩完成后的视频文件路径
 *  @param handler   处理结束回调
 */
+(void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                             outputURL:(NSURL*)outputURL
                       completeHandler:(void (^)(AVAssetExportSession* exportSession, NSURL* compressedOutputURL)) handler;
/**
 *  @author 嘴爷, 2016-05-27 13:05:38
 *
 *  @brief 压缩视频文件
 *
 *  @param movUrl 待压缩视频文件路径
 *
 *  @return 压缩完成后的视频文件路径
 */
+ (NSURL *)convert2Mp4:(NSURL *)movUrl;

@end
