//
//  AliyunVideoBase.h
//  AliyunVideoSDK
//
//  Created by TripleL on 17/5/4.
//  Copyright (C) 2010-2017 Alibaba Group Holding Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AliyunVideoUIConfig,AliyunVideoRecordParam,AliyunVideoCropParam;


@protocol AliyunVideoBaseDelegate;

@interface AliyunVideoBase : NSObject


/**
 UI配置参数
 */
@property (nonatomic, strong, readonly)AliyunVideoUIConfig *videoUIConfig;


/**
 回调
 */
@property (nonatomic, weak) id<AliyunVideoBaseDelegate> delegate;

+ (instancetype)shared;


/**
 版本号
 */
- (NSString *)version;


/**
 设置UI配置参数

 @param videoUIConfig UI配置
 */
- (void)registerWithAliyunIConfig:(AliyunVideoUIConfig *)videoUIConfig;


/**
 创建一个录制界面

 @param recordParam 录制视频参数
 @return 录制界面
 */
- (UIViewController *)createRecordViewControllerWithRecordParam:(AliyunVideoRecordParam *)recordParam;


/**
 创建一个相册导入界面

 @param cropParam 裁剪视频参数
 @return 相册导入界面
 */
- (UIViewController *)createPhotoViewControllerCropParam:(AliyunVideoCropParam *)cropParam;

@end


@protocol AliyunVideoBaseDelegate <NSObject>

@optional


/**
 录制完成回调

 @param base AliyunVideoBase
 @param recordVC 录制界面VC
 @param videoPath 视频保存路径
 */
- (void)videoBase:(AliyunVideoBase *)base recordCompeleteWithRecordViewController:(UIViewController *)recordVC videoPath:(NSString *)videoPath;




/**
 退出录制
 */
- (void)videoBaseRecordVideoExit;




/**
 裁剪完成回调

 @param base AliyunVideoBase
 @param cropVC 裁剪页VC
 @param videoPath 视频保存路径
 */
- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC videoPath:(NSString *)videoPath;

/**
 裁剪完成回调
 
 @param base AliyunVideoBase
 @param cropVC 裁剪页VC
 @param image 图片
 */
- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC image:(UIImage *)image;


/**
 退出相册页
 */
- (void)videoBasePhotoExitWithPhotoViewController:(UIViewController *)photoVC;





/**
 录制页跳转相册页

 @param recordVC 当前录制页VC
 @return 跳转相册页的视频配置，若返回空则沿用录制页的视频配置
 */
- (AliyunVideoCropParam *)videoBaseRecordViewShowLibrary:(UIViewController *)recordVC;



/**
 相册页面跳转录制页

 @param photoVC 当前相册VC
 @return 跳转视频页的视频配置，若返回空则沿用相册裁剪页的视频配置
 */
- (AliyunVideoRecordParam *)videoBasePhotoViewShowRecord:(UIViewController *)photoVC;



/**
 裁剪完成回调
 
 @param base AliyunVideoBase
 @param cropVC 裁剪页VC
 @param videoPath 视频保存路径
 @param sourcePath 原视频路径
 */
- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC videoPath:(NSString *)videoPath sourcePath:(NSString *)sourcePath;

@end





