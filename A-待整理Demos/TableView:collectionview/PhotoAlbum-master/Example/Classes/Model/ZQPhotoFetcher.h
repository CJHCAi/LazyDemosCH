//
//  ZQPhotoFetcher.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/25.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#import <PhotosUI/PhotosUI.h>
#import "Typedefs.h"
#import "ZQAlbumModel.h"
#import "ZQPhotoModel.h"
#import "ZQAlbumNavVC.h"




typedef void(^ZQPhotoCompletion)(UIImage * _Nullable image, NSDictionary * _Nullable info);
typedef void(^ZQVideoCompletion)(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info);


@interface ZQPhotoFetcher : NSObject

+ (BOOL)authorizationStatusAuthorized;
+ (void)exceedMaxImagesCountAlert:(NSInteger)maxImagesCount
                     presentingVC:(UIViewController * _Nonnull)vc
                            navVC:(ZQAlbumNavVC * _Nonnull)navVC;

//获取所有相册，completion中返回ZQAlbumModel数组
+ (NSArray<ZQAlbumModel*> *)getAllAlbumsWithType:(ZQAlbumType)type;


//获取一个相册的所有item, completion中返回ZQPhotoModel数组
+ (NSArray<ZQPhotoModel*> *)getAllPhotosInAlbum:(ZQAlbumModel *_Nonnull)collection;


//获取一个相册的封面，默认最后一张作为封面, completion中返回image和image的信息
+ (PHImageRequestID)getAlbumCoverFromAlbum:(ZQAlbumModel *_Nonnull)collection
                                completion:(ZQPhotoCompletion)completion;



//快速获取一张照片(按指定的尺寸、图片质量获取)
+ (PHImageRequestID)getPhotoFastWithAssets:(PHAsset *_Nonnull)asset
                                photoWidth:(CGFloat)photoWidth
                                completion:(ZQPhotoCompletion)completion;

//默认的方式获取一张照片,加载的大图都是360*360的尺寸，取的是原始图片
+ (PHImageRequestID)getPhotoWithAssets:(PHAsset *_Nonnull)asset
                            photoWidth:(CGFloat)photoWidth
                            completion:(ZQPhotoCompletion)completion;



//获取一个视频
+ (PHImageRequestID)getVideoWithAssets:(PHAsset *_Nonnull)asset
                            completion:(ZQVideoCompletion)completion;


//上传
+ (void)exportVideoDegradedWithAssets:(PHAsset *_Nonnull)asset
                             progress:(void(^_Nullable)(CGFloat progress))progressBlock
                           completion:(void(^_Nullable)(AVAsset* _Nullable playerAsset, NSDictionary* _Nullable info, NSURL* _Nullable url))completion;



/**
 *  取消一个request
 *
 *  @param requestID 请求时返回的requestID
 */
+ (void)cancelRequest:(PHImageRequestID)requestID;



@end
