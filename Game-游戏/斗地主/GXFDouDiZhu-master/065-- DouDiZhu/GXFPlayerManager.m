//
//  GXFPlayerManager.m
//  04-- QQ音乐
//
//  Created by mac on 16/7/16.
//  Copyright © 2016年 GuXuefei. All rights reserved.
//

#import "GXFPlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface GXFPlayerManager () <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *player;

@property (strong, nonatomic) NSString *fileName;

@end

@implementation GXFPlayerManager

GXFPlayerManager *_manager;
+ (instancetype)sharePlayerManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
    
    _manager = [[self alloc] init];
    return _manager;
}

- (void)playMusicWithfileName:(NSString *)fileName {
    
    if (![self.fileName isEqualToString:fileName]) {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.player.delegate = self;
        [self.player prepareToPlay];
        
        self.fileName = fileName;
    }
    
    [self.player play];
}

- (void)pauseMusic {
    
    [self.player pause];
    
}

- (NSTimeInterval)duration {
    
    return self.player.duration;
    
}


- (NSTimeInterval)currentTime {
    
    return self.player.currentTime;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    
    self.player.currentTime = currentTime;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
//    NSLog(@"播放完了");
//    self.player = nil;
    
//    [self playMusicWithfileName:self.fileName];
    if ([player.url isEqual:[[NSBundle mainBundle] URLForResource:@"game_music.mp3" withExtension:nil]]) {
        
        [self playMusicWithfileName:@"game_music.mp3"];
    }
}

@end
