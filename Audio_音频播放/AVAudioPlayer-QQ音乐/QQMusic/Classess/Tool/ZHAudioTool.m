//
//  ZHAudioTool.m
//  QQMusic
//
//  Created by niugaohang on 15/9/11.
//  Copyright (c) 2015年 niu. All rights reserved.
//

#import "ZHAudioTool.h"

@implementation ZHAudioTool

static NSMutableDictionary *_player;

+(void)initialize
{
    _player = [NSMutableDictionary dictionary];

}

+ (AVAudioPlayer *)playMusicWithMuiscName:(NSString *)musicName
{

    // 1.从字典中取出对应的数据
    AVAudioPlayer *player = _player[musicName];
    
    // 2.如果取出为nil,创建对应播放器,并存入字典
    if (player == nil) {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        // 将播放器存入字典中
        [_player setObject:player forKey:musicName];
    }
    
    // 播放歌曲
    [player play];
    return player;

}

+ (void)pauseMusicWithMusicName:(NSString *)musicName
{
    // 1.取出播放器
    AVAudioPlayer *player = _player[musicName];
    
    // 2.如果不为nil,则暂停
    if (player) {
        [player pause];
    }

}

+ (void)stopMusicWithMusicName:(NSString *)musicName
{

    // 1.取出播放器
    AVAudioPlayer *player = _player[musicName];
    
    // 2.如果不为nil,则停止
    if (player) {
        [player stop];
        [_player removeObjectForKey:musicName];
        player = nil;
    }


}

@end
