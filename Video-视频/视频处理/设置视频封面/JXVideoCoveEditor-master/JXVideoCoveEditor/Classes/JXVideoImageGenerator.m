//
//  JXVideoImageGenerator.m
//  JXVideoImagePicker
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXVideoImageGenerator.h"


@implementation JXVideoImage


- (instancetype)initWithImage:(UIImage *)image requestedTime:(CMTime)requestedTime actualTime:(CMTime)actualTime{
    if (self = [super init]) {
        
        self.image = image;
        self.requestedTime = requestedTime;
        self.actualTime = actualTime;
        
    }
    return self;
}

@end



@implementation JXVideoImageGenerator

/**
 生成图片
 
 @param asset AVAsset
 @param second wanted time, default 0
 @param closure 回调block
 */
+ (void)generateSingleImageFromAsset:(AVAsset *)asset second:(Float64)second closure:(SingleImageClosure)closure{
    
    CMTime requestedTime = CMTimeMakeWithSeconds(second, asset.duration.timescale);
    
    [self generateSingleImageFromAsset:asset time:requestedTime closure:closure];
    
}

/// generate image of time
///
/// - parameter asset:   AVAsset
/// - parameter time:    wanted time, default kCMTimeZero
/// - parameter closure: completed handler
+ (void)generateSingleImageFromAsset:(AVAsset *)asset time:(CMTime)time closure:(SingleImageClosure)closure{
    
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    //如果不设置这两个属性为kCMTimeZero，则实际生成的图片和需要生成的图片会有时间差
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    CMTime actualTime = CMTimeMake(0, asset.duration.timescale);
    
    NSError *error = nil;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    
    if (error == nil) {
        UIImage *image = [UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        
        JXVideoImage *videoImage = [[JXVideoImage alloc]initWithImage:image requestedTime:time actualTime:actualTime];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            closure(videoImage);
        });
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            closure(nil);
        });
        
    }
    
    
}


+ (void)generateSequenceOfImages:(AVAsset *)asset seconds:(NSArray <NSNumber *>*)seconds closure:(SequenceOfImagesClosure)closure{
    
    NSMutableArray *times = [NSMutableArray array];
    
    for (NSNumber *number  in seconds) {
        
        CMTime time = CMTimeMakeWithSeconds([number floatValue], asset.duration.timescale);
        
        NSValue *value = [NSValue valueWithCMTime:time];
        
        [times addObject:value];
    }
    
    [self generateSequenceOfImagesFromAsset:asset times:times closure:closure];
    
}

/// generate images of times
///
/// - parameter asset:   AVAsset
/// - parameter times:   [CMTime]
/// - parameter closure: completed handler

+ (void)generateSequenceOfImagesFromAsset:(AVAsset *)asset times:(NSArray <NSValue *>*)times closure:(SequenceOfImagesClosure)closure{
    
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    //如果不设置这两个属性为kCMTimeZero，则实际生成的图片和需要生成的图片会有时间差
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    
    NSMutableArray *keyframeImages = [NSMutableArray array];
    __block NSInteger completedCount = 0;
    
    [imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable cgImage, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        
        completedCount += 1;
        
        if (result == AVAssetImageGeneratorSucceeded) {
            
            UIImage *image = [UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            
            JXVideoImage *keyframeImage = [[JXVideoImage alloc]initWithImage:image requestedTime:requestedTime actualTime:actualTime];
            [keyframeImages addObject:keyframeImage];
            
        }
        
        
        if (completedCount == times.count) {
            /// 正序排序
            NSArray *sortedKeyframeImages = [keyframeImages sortedArrayUsingComparator:^NSComparisonResult(JXVideoImage * _Nonnull obj1, JXVideoImage *   _Nonnull obj2) {
                
                return (obj1.actualTime.value / obj1.actualTime.timescale ) > (obj2.actualTime.value / obj2.actualTime.timescale);
                
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                closure(sortedKeyframeImages);
            });
            
        }
        
    }];
    
    
    
    
}


/// generate default images with asset(like iPhone photo library)
///
/// - parameter asset:   AVAsset
/// - parameter closure: completed handler
+ (void)generateDefaultSequenceOfImagesFromAsset:(AVAsset *)asset closure:(SequenceOfImagesClosure)closure{
    
    
    
    // 这里的规则比较随意
    NSNumber *num = [NSNumber numberWithLong:asset.duration.value / asset.duration.timescale];
    
    int second = [num intValue];
    int maxCount = 20;
    int requestedCount = 0;
    
    if (second <= 5) {
        requestedCount = second + 1;
        
        
    } else {
        requestedCount = MIN(second * 2, maxCount);
    }
    
    
    double spacing = second / (requestedCount * 1.0);
    
    
    NSMutableArray *seconds = [NSMutableArray array];
    
    for (int i = 0; i < requestedCount; i ++) {
        
        double time = i * spacing;
        
        [seconds addObject:[NSNumber numberWithDouble:time]];
        
    }
    
    [self generateSequenceOfImages:asset seconds:seconds closure:closure];
    
}
@end

