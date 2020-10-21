//
//  HXCustomAssetModel.h
//  照片选择器
//
//  Created by 洪欣 on 2018/7/25.
//  Copyright © 2018年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HXCustomAssetModelType) {
    HXCustomAssetModelTypeLocalImage    = 1,    //!< 本地图片
    HXCustomAssetModelTypeLocalVideo    = 2,    //!< 本地视频
    HXCustomAssetModelTypeNetWorkImage  = 3,    //!< 网络图片
    HXCustomAssetModelTypeNetWorkVideo  = 4,    //!< 网络视频
    HXCustomAssetModelTypeLivePhoto     = 5     //!< livePhoto
};

@interface HXCustomAssetModel : NSObject

/**
 资源类型
 */
@property (assign, nonatomic) HXCustomAssetModelType type;

/**
 网络图片地址 or 网络视频封面
 */
@property (strong, nonatomic) NSURL *networkImageURL;

/**
 网络图片缩略图地址 or 网络视频封面
 */
@property (strong, nonatomic) NSURL *networkThumbURL;

/**
 本地图片UIImage
 */
@property (strong, nonatomic) UIImage *localImage;

/**
 本地视频地址
 */
@property (strong, nonatomic) NSURL *localVideoURL;

/// 网络视频地址
@property (strong, nonatomic) NSURL *networkVideoURL;

/// 视频时长
@property (assign, nonatomic) NSTimeInterval videoDuration;

/**
 是否选中
 */
@property (assign, nonatomic) BOOL selected;

/**
 根据本地图片名初始化

 @param imageName 本地图片名
 @param selected 是否选中
 @return HXCustomAssetModel
 */
+ (instancetype)assetWithLocaImageName:(NSString *)imageName selected:(BOOL)selected;

/**
 根据本地UIImage初始化

 @param image 本地图片
 @param selected 是否选中
 @return HXCustomAssetModel
 */
+ (instancetype)assetWithLocalImage:(UIImage *)image selected:(BOOL)selected;

/**
 根据网络图片地址初始化

 @param imageURL 网络图片地址
 @param selected 是否选中
 @return HXCustomAssetModel
 */
+ (instancetype)assetWithNetworkImageURL:(NSURL *)imageURL selected:(BOOL)selected;

/**
 根据网络图片地址初始化

 @param imageURL 网络图片地址
 @param thumbURL 网络图片缩略图地址
 @param selected 是否选中
 @return HXCustomAssetModel
 */
+ (instancetype)assetWithNetworkImageURL:(NSURL *)imageURL networkThumbURL:(NSURL *)thumbURL selected:(BOOL)selected;

/**
 根据本地视频地址初始化

 @param videoURL 本地视频地址
 @param selected 是否选中
 @return HXCustomAssetModel
 */
+ (instancetype)assetWithLocalVideoURL:(NSURL *)videoURL selected:(BOOL)selected;

/// 根据网络视频地址、视频封面初始化
/// @param videoURL 视频地址
/// @param videoCoverURL 视频封面地址
/// @param videoDuration 视频时长
/// @param selected 是否选中
+ (instancetype)assetWithNetworkVideoURL:(NSURL *)videoURL videoCoverURL:(NSURL *)videoCoverURL videoDuration:(NSTimeInterval)videoDuration selected:(BOOL)selected;

/// 根据本地图片和本地视频生成LivePhoto
/// @param image 本地图片
/// @param videoURL 本地视频地址
/// @param selected 是否选中
//+ (instancetype)livePhotoAssetWithLocalImage:(UIImage *)image localVideoURL:(NSURL *)videoURL selected:(BOOL)selected; // 暂不支持本地生成LivePhoto
@end
