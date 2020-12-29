//
//  AliyunMediaConfig.h
//  AliyunVideo
//
//  Created by Worthy on 2017/3/11.
//  Copyright (C) 2010-2017 Alibaba Group Holding Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger, AliyunMediaQuality) {
    AliyunMediaQualityVeryHight,
    AliyunMediaQualityHight,
    AliyunMediaQualityMedium,
    AliyunMediaQualityLow,
    AliyunMediaQualityPoor,
    AliyunMediaQualityExtraPoor
};

typedef NS_ENUM(NSInteger, AliyunMediaCutMode) {
    AliyunMediaCutModeScaleAspectFill,     // 填充
    AliyunMediaCutModeScaleAspectCut       // 裁剪
};

typedef NS_ENUM(NSInteger, AliyunEncodeMode) {
    AliyunEncodeModeSoftH264,
    AliyunEncodeModeHardH264
};
typedef NS_ENUM(NSInteger, AliyunMediaRatio) {
    AliyunMediaRatio9To16,
    AliyunMediaRatio3To4,
    AliyunMediaRatio1To1,
    AliyunMediaRatio4To3,
    AliyunMediaRatio16To9,
};

typedef enum : NSUInteger {
    kPhotoMediaTypeVideo,
    kPhotoMediaTypePhoto,
} kPhotoMediaType;

@class AVAsset;
@interface AliyunMediaConfig : NSObject

@property (nonatomic, strong) NSString *sourcePath;
@property (nonatomic, assign) CGFloat sourceDuration;
@property (nonatomic, strong) NSString *outputPath;
@property (nonatomic, assign) CGSize outputSize;
@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat endTime;
@property (nonatomic, assign) CGFloat minDuration;
@property (nonatomic, assign) CGFloat maxDuration;
@property (nonatomic, assign) AliyunMediaCutMode cutMode;
@property (nonatomic, assign) AliyunMediaQuality videoQuality;
@property (nonatomic, assign) AliyunEncodeMode encodeMode;
@property (nonatomic, assign) int fps;
@property (nonatomic, assign) int gop;
@property (nonatomic, assign) int bitrate;
@property (nonatomic, strong) AVAsset *avAsset;
@property (nonatomic, strong) PHAsset *phAsset;//相册图片资源
@property (nonatomic, strong) UIImage *phImage;//相册图片实例
@property (nonatomic, assign) BOOL videoOnly;  //是否仅展示视频
@property (nonatomic, assign) int videoRotate; /* 视频角度，以第一段为准 0/90/180/270 */
@property (nonatomic, assign) UIColor *backgroundColor;//填充的背景颜色
@property (nonatomic, assign) BOOL gpuCrop;


+ (instancetype)cutConfigWithOutputPath:(NSString *)outputPath
                             outputSize:(CGSize)outputSize
                            minDuration:(CGFloat)minDuration
                            maxDuration:(CGFloat)maxDuration
                                cutMode:(AliyunMediaCutMode)cutMode
                           videoQuality:(AliyunMediaQuality)videoQuality
                                    fps:(int)fps
                                    gop:(int)gop;

+ (instancetype)recordConfigWithOutpusPath:(NSString *)outputPath
                                outputSize:(CGSize)outputSize
                               minDuration:(CGFloat)minDuration
                               maxDuration:(CGFloat)maxDuration
                              videoQuality:(AliyunMediaQuality)videoQuality
                                    encode:(AliyunEncodeMode)encodeMode
                                       fps:(int)fps
                                       gop:(int)gop;

- (CGSize)updateVideoSizeWithRatio:(CGFloat)r;

- (AliyunMediaRatio)mediaRatio;

- (CGSize)fixedSize;

@end
