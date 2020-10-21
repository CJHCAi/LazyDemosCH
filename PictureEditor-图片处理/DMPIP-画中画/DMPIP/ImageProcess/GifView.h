//
//  GifView.h
//  GifDemo
//
//  Created by Rick on 15/5/26.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface GifView : UIView
{
    NSMutableArray *_frames;
    NSMutableArray *_frameDelayTimes;
    
    CGPoint frameCenter;
    CADisplayLink *displayLink;
    int frameIndex;
    double frameDelay;
    
    NSUInteger _loopCount;
    NSUInteger _currentLoop;
    CGFloat _totalTime;         // seconds
    CGFloat _width;
    CGFloat _height;
}

//- (id)initWithCenter:(CGPoint)center fileURL:(NSURL*)fileURL;
//- (void)initFileURL:(NSURL*)fileURL;

//- (void)startGif;
//- (void)stopGif;

/*
 * @brief 获取gif图中每一帧的信息
 */
+ (NSDictionary *)getGifInfo:(NSURL *)fileURL;

/*
 * @brief 指定每一帧播放时长把多张图片合成gif图
 */
+ (NSString *)exportGifImages:(NSArray *)images delays:(NSArray *)delays loopCount:(NSUInteger)loopCount;
@end
