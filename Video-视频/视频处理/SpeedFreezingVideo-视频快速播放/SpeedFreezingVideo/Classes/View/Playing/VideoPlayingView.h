//
//  VideoPlayingView.h
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/18.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayer;
@interface VideoPlayingView : UIView

- (void)setPlayer:(AVPlayer *)player;
- (void)setVideoGravity:(NSString *)videoGravity;

@end
