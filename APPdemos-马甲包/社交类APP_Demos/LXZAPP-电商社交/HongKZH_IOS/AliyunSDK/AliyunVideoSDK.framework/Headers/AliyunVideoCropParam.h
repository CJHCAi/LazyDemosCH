//
//  AliyunVideoCropParam.h
//  AliyunVideo
//
//  Created by TripleL on 17/5/4.
//  Copyright (C) 2010-2017 Alibaba Group Holding Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AliyunVideoRecordParam.h"

@class AVAsset;


/**
 裁剪模式
 */
typedef NS_ENUM(NSInteger, AliyunVideoCutMode) {
    AliyunVideoCutModeScaleAspectFill,     // 填充
    AliyunVideoCutModeScaleAspectCut       // 裁剪

};

@interface AliyunVideoCropParam : NSObject

/* 输出路径 */
@property (nonatomic, strong) NSString *outputPath;
/* 输出视频分辨率 */
@property (nonatomic, assign) AliyunVideoSize size;
/* 输出视频比例 */
@property (nonatomic, assign) AliyunVideoRatio ratio;
/* 过滤相册视频最小时长 */
@property (nonatomic, assign) CGFloat minDuration;
/* 过滤相册视频最大时长 */
@property (nonatomic, assign) CGFloat maxDuration;
/* 裁剪模式 */
@property (nonatomic, assign) AliyunVideoCutMode cutMode;
/* 视频质量 */
@property (nonatomic, assign) AliyunVideoQuality videoQuality;
/* 编码方式 */
@property (nonatomic, assign) AliyunVideoEncodeMode encodeMode;
/* 帧率 */
@property (nonatomic, assign) int fps;
/* 关键帧间隔 */
@property (nonatomic, assign) int gop;
/* 视频asset */
@property (nonatomic, strong) AVAsset *avAsset;
/**
 是否仅仅展示视频
 */
@property (nonatomic, assign) BOOL videoOnly;

/**
 填充的背景颜色
 */
@property (nonatomic, strong) UIColor *fillBackgroundColor;

/**
 是否使用gpu裁剪
 */
@property (nonatomic, assign) BOOL gpuCrop;

/**
 裁剪码率
 */
@property (nonatomic, assign) int bitrate;

/**
 创建AliyunVideoCropParam
 */
+ (instancetype)recordConfigWithVideoRatio:(AliyunVideoRatio)ratio
                                 videoSize:(AliyunVideoSize)size;


/**
 创建AliyunVideoCropParam
 */
+ (instancetype)recordConfigWithVideoRatio:(AliyunVideoRatio)ratio
                                 videoSize:(AliyunVideoSize)size
                                outputPath:(NSString *)outputPath
                               minDuration:(CGFloat)minDuration
                               maxDuration:(CGFloat)maxDuration
                                   cutMode:(AliyunVideoCutMode)cutMode
                              videoQuality:(AliyunVideoQuality)videoQuality
                                encodeMode:(AliyunVideoEncodeMode)encodeMode
                                       fps:(int)fps
                                       gop:(int)gop;

@end
