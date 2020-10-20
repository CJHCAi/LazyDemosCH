//
//  SSAuidoManager.m
//  DemoAudioComp
//
//  Created by SHEN on 2018/9/6.
//  Copyright © 2018年 shj. All rights reserved.
//

#import "SSAudioManager.h"
#import <AVFoundation/AVFoundation.h>

@interface SSAudioManager() <AVAudioPlayerDelegate>
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSURL *fileUrl;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation SSAudioManager

+ (instancetype)instance {
    static SSAudioManager *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[SSAudioManager alloc] init];
        [obj initData];
    });
    return obj;
}

- (void)dealloc {
    [self stopPlay];
}

- (void)initData {
    self.isPlaying = NO;
}

- (void)play:(NSURL *)fileUrl {
    self.fileUrl = fileUrl;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    self.audioPlayer.meteringEnabled = YES; // 需要启用
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
    
    self.isPlaying = YES;
    
    // 定时器
    [self startTimer];
    
    // 通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioDidStartPlay" object:nil];
}

- (void)stopPlay {
    if (self.audioPlayer) {
        if (self.audioPlayer.isPlaying) {
            [self.audioPlayer stop];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioDidForceStopPlay" object:nil];
        }
    }
    [self stopTimer];
    self.isPlaying = NO;
}

#pragma mark - get / set

- (CGFloat)currentTime {
    if (self.audioPlayer) {
        return self.audioPlayer.currentTime;
    }
    return 0.0001;
}

- (CGFloat)duration {
    if (self.audioPlayer) {
        return self.audioPlayer.duration;
    }
    return 0.0;
}

#pragma mark - Private

- (CGFloat)getAudioDuration {
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:self.fileUrl options:nil];
    CMTime audioDuration = asset.duration;
    return CMTimeGetSeconds(audioDuration);
}


- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(couting:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)couting:(NSTimer *)timer {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer updateMeters];
    }
    CGFloat power = [self.audioPlayer averagePowerForChannel:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TimerCounting" object:@(power)];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    // 通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioDidStopPlay" object:nil]; 
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"%@", error);
}

@end

















