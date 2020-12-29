//
//  ImageUtil.h
//  YiXiu
//
//  Created by QinGuoLi on 16/4/5.
//  Copyright © 2016年 Liqg. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 图片上传文件最大限制(400KB)
#define IMAGE_MAX_SIZE 400 * 1024


@interface ImageUtil : NSObject

/**
 * 按宽度等比压缩
 */
+ (UIImage *)compress:(UIImage *)image newWidth:(int)newWidth;

/**
 * 指定范围等比压缩
 */
+ (UIImage *)compress:(UIImage *)image newWidth:(int)newWidth newHeight:(int)newHeight;

/**
 * 压缩并裁剪成正方形
 */
+ (UIImage *)cutImage:(UIImage *)image width:(int)width;

/**
 * 裁剪成固定 高/宽  比的图 (在原图尺寸上裁剪)
 */
+ (UIImage *)cutImage:(UIImage *)image withScale:(float)scale;

/**
 * 修复拍照图片旋转90度的问题
 */
+ (UIImage *)fixImageOrientation:(UIImage *)image;

/**
 * 压缩图片质量
 */
+ (NSData *)compressImageQuality:(UIImage *)image;

@end
