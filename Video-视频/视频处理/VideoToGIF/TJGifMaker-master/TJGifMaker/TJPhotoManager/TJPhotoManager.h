//
//  TJPhotoManager.h
//  TJGifMaker
//
//  Created by TanJian on 17/6/16.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface TJPhotoManager : NSObject


/**
 单例方法

 @return TJPhotoManager单例
 */
-(instancetype)manager;


/**
 获取所有所需类型媒体的集合

 @param mediaType 所需媒体类型
 @param ascend 是否升序
 @return 媒体集合
 */
+ (PHFetchResult<PHAsset *> *)getFetchResultWithMediaType:(PHAssetMediaType)mediaType ascend:(BOOL)ascend;


/**
 获取媒体缩略图

 @param result 媒体集合
 @param original 是否需要缩略图
 @return 缩略图数组
 */
+ (NSArray *)getPhotosWithPHFetchResult:(PHFetchResult *)result original:(BOOL)original;
@end
