//
//  JXVideoImageGenerator.h
//  JXVideoImagePicker
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@class JXVideoImage;

/// 结束时的图片（单一）
typedef void(^SingleImageClosure)(JXVideoImage *);

/// 结束时的图片（数组）
typedef void(^SequenceOfImagesClosure)(NSArray <JXVideoImage *>*);


@interface JXVideoImage : NSObject


/** image*/
@property (nonatomic, strong) UIImage *image;

/** 时间*/
@property (nonatomic, assign)CMTime requestedTime;

/** 实际时间*/
@property (nonatomic, assign)CMTime actualTime;


- (instancetype)initWithImage:(UIImage *)image requestedTime:(CMTime)requestedTime actualTime:(CMTime)actualTime;

@end




/**！
 视频关键帧图片生成管理者
 */
@interface JXVideoImageGenerator : NSObject

/**
 生成图片
 
 @param asset AVAsset
 @param second wanted time, default 0
 @param closure 回调block
 */
+ (void)generateSingleImageFromAsset:(AVAsset *)asset second:(Float64)second closure:(SingleImageClosure)closure;

/// generate images of times
///
/// - parameter asset:     AVAsset
/// - parameter seconds:   seconds
/// - parameter closure:   completed handler
+ (void)generateSequenceOfImages:(AVAsset *)asset seconds:(NSArray <NSNumber *>*)seconds closure:(SequenceOfImagesClosure)closure;


/// 默认
+ (void)generateDefaultSequenceOfImagesFromAsset:(AVAsset *)asset closure:(SequenceOfImagesClosure)closure;
@end
