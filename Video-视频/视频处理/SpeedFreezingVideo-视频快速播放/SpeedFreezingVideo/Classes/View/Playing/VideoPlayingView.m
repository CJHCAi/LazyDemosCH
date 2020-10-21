//
//  VideoPlayingView.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/18.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "VideoPlayingView.h"
#import <AVFoundation/AVPlayerLayer.h>

@implementation VideoPlayingView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureView];
}

- (void)configureView {
    //默认填充 用autoLayout约束限制横竖屏的视频播放Layer size
    ((AVPlayerLayer *)self.layer).videoGravity = AVLayerVideoGravityResizeAspectFill;
}

- (void)setVideoGravity:(NSString *)videoGravity {
    ((AVPlayerLayer *)self.layer).videoGravity = videoGravity;
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)self.layer setPlayer:player];
}

@end
