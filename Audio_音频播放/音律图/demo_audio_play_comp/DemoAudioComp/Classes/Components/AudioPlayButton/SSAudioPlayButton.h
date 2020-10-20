//
//  SSAudioPlayButton.h
//  DemoAudioComp
//
//  Created by SHEN on 2018/9/3.
//  Copyright © 2018年 shj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSAudioPlayProgressBar.h"

@class SSAudioPlayButton;

@protocol SSAudioPlayButtonDelegate <NSObject>
- (void)audioPlayButtonDidFinishDownload:(SSAudioPlayButton *)playButton;
- (void)audioPlayButtonDidStartPlay:(SSAudioPlayButton *)playButton;
- (void)audioPlayButtonDidStopPlay:(SSAudioPlayButton *)playButton;
@end

@interface SSAudioPlayButton : UIView
// 代理
@property (weak, nonatomic) id<SSAudioPlayButtonDelegate> delegate;

// 背景色
@property (strong, nonatomic) UIColor *normalBackgroundColor;

// 点击高亮背景色
@property (strong, nonatomic) UIColor *hightlightBackgroundColor;

// 文件url，来源：1.main bundle 2.沙盒
@property (strong, nonatomic) NSURL *fileUrl;

// 时间
@property (strong, readonly, nonatomic) UILabel *timeLabel;

// 进度条
@property (strong, readonly, nonatomic) SSAudioPlayProgressBar *progessBar;

// 开始播放
- (void)startPlay;

// 停止播放
- (void)stopPlay;

// 强制更新界面
- (void)forceUpdateAppearance:(BOOL)isPlaying row:(NSInteger)row;

@end
