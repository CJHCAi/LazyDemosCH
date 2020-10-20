//
//  MMPhotoUtil.h
//  MMPhotoPicker
//
//  Created by LEA on 2017/11/10.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

@interface MMPhotoUtil : NSObject

/**
  保存图片到自定义相册

 @param image 图片
 @param completionHandler 保存成功与否
 */
+ (void)writeImageToPhotoAlbum:(UIImage *)image
             completionHandler:(void(^)(BOOL success))completionHandler;


/**
 保存视频到自定义相册

 @param videoURL 视频路径URL
 @param completionHandler 保存成功与否
 */
+ (void)writeVideoToPhotoAlbum:(NSURL *)videoURL
             completionHandler:(void(^)(BOOL success))completionHandler;


/**
 获取指定相册中照片

 @param assetCollection 相册
 @param ascending 升序OR降序
 @return 排序后的集合
 */
+ (NSArray<PHAsset *> *)getAllAssetWithAssetCollection:(PHAssetCollection *)assetCollection
                                             ascending:(BOOL)ascending;

/**
 获取asset对应的图片

 @param asset asset
 @param size 图片size
 @param completion 图片
 */
+ (void)getImageWithAsset:(PHAsset *)asset
                     size:(CGSize)size
               completion:(void (^)(UIImage *image))completion;


/**
 获取asset对应图片

 @param asset asset
 @param completion 图片
 */
+ (void)getImageWithAsset:(PHAsset *)asset
               completion:(void (^)(UIImage *image))completion;

@end
