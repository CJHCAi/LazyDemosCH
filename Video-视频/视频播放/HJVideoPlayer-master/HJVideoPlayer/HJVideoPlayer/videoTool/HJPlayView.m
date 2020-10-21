//
//  HJPlayView.m
//  HJVideoPlayer
//
//  Created by 黄静静 on 2017/7/19.
//  Copyright © 2017年 HJing. All rights reserved.
//

#import "HJPlayView.h"

#define degreesToRadians(x) (M_PI * x / 180.0f)

@interface HJPlayView()<HJVideoPlayerDelegate,HJMaskViewDelegate>
@property (nonatomic, assign) HJPlayViewType type;
@property (nonatomic) UIInterfaceOrientation visibleInterfaceOrientation;
@property (nonatomic) CGRect portraitFrame;
@property (nonatomic) CGRect landscapeFrame;
@end

@implementation HJPlayView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

+ (HJPlayView *)playerViewWithFrame:(CGRect)frame withPlayType:(HJPlayViewType)playViewType {
    HJPlayView *view = [[HJPlayView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor blackColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.type = playViewType;
    return view;
}

- (void)setCoverUrl:(NSURL *)coverUrl {
    _coverUrl = coverUrl;
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    if (videoUrl) {
        [self createVideoPlayer];
        [self.videoPlayer play];
    }
}

- (void)setType:(HJPlayViewType)type {
    if (type == HJPlayViewTypeForPlay) {
        _maskView = [self maskView];
    }
    if (type == HJPlayViewTypeForScan) {
        
    }
}

- (HJPlayerMaskView *)maskView {
    if (!_maskView) {
        _maskView = [[HJPlayerMaskView alloc] initWithFrame:self.bounds];
        _maskView.delegate = self;
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_maskView];
    }
    return _maskView;
}

- (HJVideoPlayer *)createVideoPlayer {
    if (!_videoPlayer) {
        _videoPlayer = [HJVideoPlayer videoPlayerWithPlayerLayer:(AVPlayerLayer *)[self layer]];
        _videoPlayer.delegate = self;
    }
    _videoPlayer.videoUrl = self.videoUrl;
    return _videoPlayer;
}

#pragma mark - HJMaskViewDelegate

- (void)closeVideo {
    if ([self.delegate respondsToSelector:@selector(closeVideo)]) {
        [self.delegate closeVideo];
    }
}

- (void)pauseVideo {
    [self.videoPlayer pause];
}

- (void)replayVideo {
    [self.videoPlayer play];
}

- (void)seekToTime:(float)time withBlock:(void (^)(BOOL))completionHandler {
    [self.videoPlayer seekToTime:time completionHandler:completionHandler];
}

- (void)isFullScreen:(BOOL)isFullScreen {
    if (isFullScreen) {
        [self performOrientationChange:UIInterfaceOrientationLandscapeRight];
    } else {
        [self performOrientationChange:UIInterfaceOrientationPortrait];
    }
}

- (void)performOrientationChange:(UIInterfaceOrientation)deviceOrientation
{
    CGFloat degrees = [self degreesForOrientation:deviceOrientation];
    __weak __typeof(self) weakSelf = self;
    self.visibleInterfaceOrientation = deviceOrientation;
    [UIView animateWithDuration:0.3f animations:^{
        CGRect bounds = [[UIScreen mainScreen] bounds];
        CGRect parentBounds;
        CGRect viewBoutnds;
        if (UIInterfaceOrientationIsLandscape(deviceOrientation))
        {
            viewBoutnds  = CGRectMake(0, 0, CGRectGetWidth(self.landscapeFrame), CGRectGetHeight(self.landscapeFrame));
            parentBounds = CGRectMake(0, 0, CGRectGetHeight(bounds), CGRectGetWidth(bounds));
        } else {
            viewBoutnds  = CGRectMake(0, 0, CGRectGetWidth(self.portraitFrame), CGRectGetHeight(self.portraitFrame));
            parentBounds = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        }
        UIView *p = weakSelf;
        p.transform = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        p.bounds = parentBounds;
        
        [weakSelf setFrameOriginX:0.0 newY:0 view:p];
    }];
}

- (CGFloat)degreesForOrientation:(UIInterfaceOrientation)deviceOrientation
{
    switch (deviceOrientation)
    {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortrait:
            return 0;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return 90;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            return -90;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            return 180;
            break;
    }
    return 0;
}

- (void)setFrameOriginX:(CGFloat)newX newY:(CGFloat)newY view:(UIView *)view
{
    CGRect f = view.frame;
    f.origin.x = newX;
    f.origin.y = newY;
    view.frame = f;
}


#pragma mark - HJVideoPlayerDelegate
- (void)videoPlayer:(HJVideoPlayer *)videoPlayer loadProgress:(CGFloat)progress {
    [self.maskView loadProgress:progress];
}

- (void)videoTotalTime:(Float64)totalTime {
    [self.maskView setTotaltTime:totalTime];
}

- (void)videoCurrentTime:(Float64)currentTime {
    [self.maskView setCurrentTime:currentTime];
}

- (void)isVideoEnd:(BOOL)isPlayEnd {
    
}

@end
