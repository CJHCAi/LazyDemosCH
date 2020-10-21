//
//  NHPlayerView.h
//  VideoEditDemo
//
//  Created by JSB-hejiamin on 2018/2/24.
//  Copyright © 2018年 JSB-hejiamin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GPUImageMovie.h"
#import "GPUImageView.h"
@protocol PlayaerDelegete <NSObject>

-(void)playStatusChangeisPlay:(BOOL)isPlay;

-(void)playStatusEnd;

@end


@interface NHPlayerView : UIView
// 播放器
@property(nonatomic, retain)AVPlayer *player;

@property(nonatomic, retain)NSString *playerURLStr;
// 播放器的承载对象
@property(nonatomic, retain)AVPlayerLayer *playerLayer;

@property(nonatomic, retain)GPUImageView *gpuImageView;

// 视频项目对象
@property(nonatomic, strong)AVPlayerItem *playerItem;

@property (nonatomic,retain)UIImageView *videoView;

@property (nonatomic,retain)GPUImageMovie *gpuImageMovie;

@property (weak,nonatomic)id<PlayaerDelegete>delegate;

@property(assign,nonatomic)NSInteger videoRotation;
// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame;

- (void)setPlayerURLStr:(NSString *)playerURLStr isEdit:(BOOL)isEdit;

-(void)createVideoView;
// 开始播放
- (void)playerPlay;
// 暂停播放
- (void)playerPause;

-(void)stopPlayer;

-(void)playerReplace:(AVPlayerItem *)playerItem;

-(void)resetRotation;


@end
