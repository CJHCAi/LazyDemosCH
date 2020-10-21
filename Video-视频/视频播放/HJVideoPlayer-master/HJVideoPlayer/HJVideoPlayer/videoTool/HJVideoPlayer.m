//
//  HJVideoPlayer.m
//  HJVideoPlayer
//
//  Created by 黄静静 on 2017/7/18.
//  Copyright © 2017年 HJing. All rights reserved.
//

#import "HJVideoPlayer.h"


@interface HJVideoPlayer()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) id playbackTimeObserver;
@end

@implementation HJVideoPlayer

- (void)dealloc {
    [self removeObserver];
}

+ (HJVideoPlayer *)videoPlayerWithPlayerLayer:(AVPlayerLayer *)playerLayer {
    HJVideoPlayer *videoPlayer = [[HJVideoPlayer alloc] init];
    videoPlayer.playerLayer = playerLayer;
    return videoPlayer;
}

- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (void)seekToTime:(float)time completionHandler:(void (^)(BOOL finished))completionHandler
{
    [self.player seekToTime:CMTimeMakeWithSeconds(time, 600) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    
    [self removeObserver];
    if (!videoUrl) return;
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    [self.playerLayer setPlayer:self.player];
    [self addPlaybackTimeObserver];
    [self addObserver];
}

- (void)addObserver {
    // 监听播放状态
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听缓冲进度
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidEndNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)removeObserver {
    [self removePeriodicTimeObserver];
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

// KVO 方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] integerValue];
        if (status == AVPlayerStatusReadyToPlay) {
            // 停止缓存动画，开始播放
            // 设置视频的总时长
            if ([self.delegate respondsToSelector:@selector(videoTotalTime:)]) {
                [self.delegate videoTotalTime:CMTimeGetSeconds(self.player.currentItem.duration)];
            }
            
        } else if (status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed == %@", playerItem.error);
            return;
        } else if (status == AVPlayerStatusUnknown) {
            return;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 处理缓冲进度条
        NSTimeInterval bufferTime = [self currentVideoLoadedTime];
        NSTimeInterval totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
        CGFloat progress = bufferTime/totalTime;
        if ([self.delegate respondsToSelector:@selector(videoPlayer: loadProgress:)]) {
            [self.delegate videoPlayer:self loadProgress:progress];
        }
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
    
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        
    }
}

- (NSTimeInterval)currentVideoLoadedTime {
    NSArray *array = self.player.currentItem.loadedTimeRanges;
    CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //获取缓存区域
    NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval endSeconds = CMTimeGetSeconds(timeRange.duration);
    return startSeconds + endSeconds;
}

- (void)playDidEndNotification:(NSNotification *)notification {
    self.playEnd = YES;
    [self.delegate isVideoEnd:self.playEnd];
    // 自动重播
    [self.player seekToTime:CMTimeMakeWithSeconds(0, 600) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
}

- (void)addPlaybackTimeObserver {
//    if (self.playbackTimeObserver) return;
    
    __weak typeof(self) weakSelf = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:NULL usingBlock:^(CMTime time) {
        // 播放进度条以及时间的显示
        if ([weakSelf.delegate respondsToSelector:@selector(videoCurrentTime:)]) {
            Float64 durationTime = CMTimeGetSeconds(weakSelf.playerItem.currentTime);
            [weakSelf.delegate videoCurrentTime:durationTime];
        }
    }];
}

- (void)removePeriodicTimeObserver {
    if (_playbackTimeObserver) {
        [self.player removeTimeObserver:self.playbackTimeObserver];
        _playbackTimeObserver = nil;
    }
}


@end
