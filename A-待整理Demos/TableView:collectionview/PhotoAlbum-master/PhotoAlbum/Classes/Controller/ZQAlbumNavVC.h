//
//  ZQAlbumNavC.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/28.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

//ZQBottomToolbarView里有一个回调
//ZQPhotoPreviewVC里getCurrentCrop有一个回调

#import <UIKit/UIKit.h>
#import "Typedefs.h"

//typedef NS_ENUM(NSInteger, ZQAlbumType) {
//    ZQAlbumTypePhoto,
//    ZQAlbumTypeVideo,
//    ZQAlbumTypeVideoAndPhoto
//};


@class ZQAlbumNavVC;


@protocol ZQAlbumNavVCDelegate <NSObject>

@optional

/**
 *  返回自定义的超过最大可选张数的提示信息
 *
 *  @param maxImageCount 最大可选张数
 *
 *  @return 提示信息
 */
- (NSString*)ZQAlbumNavVCExceedMaxImageCountMessage:(NSInteger)maxImageCount;

@end



@interface ZQAlbumNavVC : UINavigationController

/**
 *  最大可选图片张数
 */
@property (nonatomic, assign) NSInteger maxImagesCount;

/**
 *  视频最大长度
 */
@property (nonatomic, assign) NSTimeInterval maxVideoDurationInSeconds;

/**
 *  是否支持剪裁（单选）
 */
@property (nonatomic, assign) BOOL bEnableCrop;

/**
 *  是否单选
 */
@property (nonatomic, assign) BOOL bSingleSelection;

@property (nonatomic, weak) id<ZQAlbumNavVCDelegate> albumDelegate;

/**
 *  photo selected callback
 */
@property (nonatomic, copy) void (^ didFinishPickingPhotosHandle)(NSArray<UIImage*> *photos);

//video selected callback
/**
 *  url: 视频压缩后的本地路径
 *  cover: 视频第一张图
 *  avAsset: AVURLAsset类，原始的asset文件
 */
@property (nonatomic, copy) void (^ didFinishPickingVideoHandle)(NSURL *url, UIImage *cover, id avAsset);

//after video selected, and before photo album dismiss, update ui
//会被调用两次，第一次是小图，第二次是大图
@property (nonatomic, copy) void (^ updateUIFinishVideoPicking)(UIImage *cover);


/**
 *  ask permission
 */
+ (void)authorize;


/**
 *  Convenient initializer. SingleSelect
 *
 *  @param type AlbumType.
 *
    typedef NS_ENUM(NSInteger, ZQAlbumType) {
        ZQAlbumTypePhoto,
        ZQAlbumTypeVideo,
        ZQAlbumTypeVideoAndPhoto
    };
 *
 *  @return instance of ZQAlbumNavVC
 */
- (instancetype)initWithType:(ZQAlbumType)type;


/**
 *  designated initializer
 *
 *  @param maxImagesCount =1 means singleSelect, >1 means multiSelect
 *  @param type           ZQAlbumType
 *
 *  @return instance of ZQAlbumNavVC
 */
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount type:(ZQAlbumType)type bSingleSelect:(BOOL)bSingleSelect;

@end
