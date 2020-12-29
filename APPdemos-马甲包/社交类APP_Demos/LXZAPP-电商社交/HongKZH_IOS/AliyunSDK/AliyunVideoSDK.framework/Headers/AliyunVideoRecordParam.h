//
//  AliyunVideoRecordParam.h
//  AliyunVideoSDK
//
//  Created by TripleL on 17/5/4.
//  Copyright (C) 2010-2017 Alibaba Group Holding Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 摄像头方向
 */
typedef NS_ENUM(NSInteger, AliyunCameraPosition) {
    AliyunCameraPositionFront = 0,
    AliyunCameraPositionBack,
};

/**
 闪光灯模式
 */
typedef NS_ENUM(NSInteger, AliyunCameraTorchMode) {
    AliyunCameraTorchModeOff  = 0,
    AliyunCameraTorchModeOn   = 1,
    AliyunCameraTorchModeAuto = 2,
};


/**
 视频质量
 */
typedef NS_ENUM(NSInteger, AliyunVideoQuality) {
    AliyunVideoQualityVeryHight,    // 录制视频分辨率 极高
    AliyunVideoQualityHight,        // 录制视频分辨率 高
    AliyunVideoQualityMedium,       // 录制视频分辨率 中等
    AliyunVideoQualityLow,          // 录制视频分辨率 低
    AliyunVideoQualityPoor,
    AliyunVideoQualityExtraPoor
};

/**
 编码方式
 */
typedef NS_ENUM(NSInteger, AliyunVideoEncodeMode) {
    AliyunVideoEncodeModeSoftH264, // 软编
    AliyunVideoEncodeModeHardH264  // 硬编
};

/**
 视频比例
 */
typedef NS_ENUM(NSInteger, AliyunVideoRatio) {
    AliyunVideoVideoRatio3To4,  // 3:4
    AliyunVideoVideoRatio9To16, // 9:16
    AliyunVideoVideoRatio1To1   // 1:1
};

/**
 视频分辨率
 */
typedef NS_ENUM(NSInteger, AliyunVideoSize) {
    AliyunVideoVideoSize360P,   // 360P
    AliyunVideoVideoSize480P,   // 480P
    AliyunVideoVideoSize540P,   // 540P
    AliyunVideoVideoSize720P    // 720P
};

@interface AliyunVideoRecordParam : NSObject

/* 摄像头方向 */
@property (nonatomic, assign) AliyunCameraPosition position;
/* 闪光灯模式 */
@property (nonatomic, assign) AliyunCameraTorchMode torchMode;
/* 美颜状态 */
@property (nonatomic, assign) BOOL beautifyStatus;
/* 设置美颜度 [0,100] */
@property (nonatomic, assign) int beautifyValue;
/* 输出路径 */
@property (nonatomic, strong) NSString *outputPath;
/* 视频分辨率 */
@property (nonatomic, assign) AliyunVideoSize size;
/* 视频比例 */
@property (nonatomic, assign) AliyunVideoRatio ratio;
/* 最小时长 */
@property (nonatomic, assign) CGFloat minDuration;
/* 最大时长 */
@property (nonatomic, assign) CGFloat maxDuration;
/* 视频质量 */
@property (nonatomic, assign) AliyunVideoQuality videoQuality;
/* 编码方式 */
@property (nonatomic, assign) AliyunVideoEncodeMode encodeMode;
/* 帧率 */
@property (nonatomic, assign) int fps;
/* 关键帧间隔 */
@property (nonatomic, assign) int gop;
/** 裁剪码率 */
@property (nonatomic, assign) int bitrate;

/**
 创建AliyunVideoRecordParam
 */
+ (instancetype)recordConfigWithVideoRatio:(AliyunVideoRatio)ratio
                                 videoSize:(AliyunVideoSize)size;


/**
 创建AliyunVideoRecordParam
 */
+ (instancetype)recordConfigWithVideoRatio:(AliyunVideoRatio)ratio
                                 videoSize:(AliyunVideoSize)size
                                  position:(AliyunCameraPosition)position
                                 trochMode:(AliyunCameraTorchMode)torchMode
                            beautifyStatus:(BOOL)beautifyStatus
                             beautifyValue:(int)beautifyValue
                                outputPath:(NSString *)outputPath
                               minDuration:(CGFloat)minDuration
                               maxDuration:(CGFloat)maxDuration
                              videoQuality:(AliyunVideoQuality)videoQuality
                                encodeMode:(AliyunVideoEncodeMode)encodeMode
                                       fps:(int)fps
                                       gop:(int)gop;

@end
