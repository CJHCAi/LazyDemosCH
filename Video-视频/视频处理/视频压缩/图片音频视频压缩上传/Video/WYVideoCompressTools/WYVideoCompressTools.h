//
//  WYVideoCompressTools.h
//  WYVideoDemo
//
//  Created by Mac mini on 16/7/18.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  AVFoundation 框架下的视频压缩类简介 :
    1. AVAsset 是什么? 多媒体一般以文件或者流的形式存在, 显而易见, 直接对多媒体进行操作并不是一件愉快的事, 这需要我们了解很多底层多媒体方面的知识. 不过还好在 iOS 开发中, AVFoundation 框架为我们提供了一个多媒体的载体类：AVAsset, 在AVAsset中有着统一并且友好的接口, 我们不需要了解太多多媒体的知识就能对其进行操作. AVAsset 的属性就包含了是多媒体文件的所有属性.
    2. AVURLAsset 是什么? AVURLAsset 是 AVAsset 的一个子类, 可以使用它来初始化一个 AVAsset 对象.
    3. AVAssetExportSession 是什么? AVAssetExportSession 用来对 AVAsset 对象的内容进行转码, 并输出到指定的路径.
 
    总之, 视频压缩就是给定源视频的路径, 压缩视频的存储路径还有压缩格式, 开始压缩就 ok 了! 但是 iOS 的视频压缩只支持 iPhone 设备上已有的视频或者现拍的视频.
 */


/**
 *  视频的压缩格式包括 :
 
    这三种压缩格式会输出一个根据当前设备自适应分辨率的视频文件, 视频采用 H264 编码, 三种压缩质量的大小是有明显差别的, 但是考虑到清晰度和大小, 一般选中中质量的压缩格式
    AVAssetExportPresetLowQuality
    AVAssetExportPresetMediumQuality
    AVAssetExportPresetHighestQuality
 
    这五种压缩格式会输出一个指定分辨率的视频文件(不过有的机子可能不支持某些格式), 视频采用 H264 编码
    AVAssetExportPreset640x480
    AVAssetExportPreset960x540
    AVAssetExportPreset1280x720
    AVAssetExportPreset1920x1080
    AVAssetExportPreset3840x2160
 */


typedef void(^SuccessBlock)(NSString *compressVideoPathString);// 压缩成功之后的回调, 要将这个视频的路径传递出去
typedef void(^FailedBlock)();// 压缩失败之后的回调
typedef void(^NotSupportBlock)();// 压缩失败之后的回调

@interface WYVideoCompressTools : NSObject

// 压缩视频的方法
+ (void)compressVideoWithSourceVideoPathString:(NSString *)sourceVideoPathString
                                  CompressType:(NSString *)compressType
                          CompressSuccessBlock:(SuccessBlock)compressSuccessBlock
                           CompressFailedBlock:(FailedBlock)compressFailedBlock
                       CompressNotSupportBlock:(NotSupportBlock)compressNotSupportBlock;
// 删除压缩视频, 比如说压缩视频在上传完成之后不再使用了, 可以将它删除掉
+ (void)deleteCompressVideoFromPath:(NSString *)compressVideoPathString;

@end
