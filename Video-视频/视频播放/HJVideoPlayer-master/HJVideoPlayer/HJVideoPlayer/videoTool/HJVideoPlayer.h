//
//  HJVideoPlayer.h
//  HJVideoPlayer
//
//  Created by 黄静静 on 2017/7/18.
//  Copyright © 2017年 HJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class HJVideoPlayer ;

@protocol HJVideoPlayerDelegate<NSObject>
@optional
- (void)videoPlayer:(HJVideoPlayer *)videoPlayer loadProgress:(CGFloat)progress;
- (void)videoTotalTime:(Float64)totalTime;
- (void)videoCurrentTime:(Float64)currentTime;
- (void)isVideoEnd:(BOOL)isPlayEnd;
@end

@interface HJVideoPlayer : NSObject
@property (nonatomic, weak) id<HJVideoPlayerDelegate>delegate;
@property (nonatomic, strong) NSURL *videoUrl;  //视频链接
@property (nonatomic) float rate;
@property (nonatomic) BOOL playEnd;


+ (HJVideoPlayer *)videoPlayerWithPlayerLayer:(AVPlayerLayer *)playerLayer;

- (void)play;
- (void)pause;
- (void)seekToTime:(float)time completionHandler:(void (^)(BOOL finished))completionHandler;



@end
