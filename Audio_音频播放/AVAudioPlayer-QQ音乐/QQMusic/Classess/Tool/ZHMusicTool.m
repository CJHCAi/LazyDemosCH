//
//  ZHMusicTool.m
//  QQMusic
//
//  Created by niugaohang on 15/9/11.
//  Copyright (c) 2015年 niu. All rights reserved.
//

#import "ZHMusicTool.h"
#import "ZHMusic.h"
#import "MJExtension.h"


@implementation ZHMusicTool

static NSArray *_music;
static ZHMusic *_playingMusic;

+(void)initialize
{

    _music = [ZHMusic objectArrayWithFilename:@"Musics.plist"];
    _playingMusic = _music[7];

}

+ (NSArray *)musics
{

    return _music;

}

+ (void)setPlayingMusic:(ZHMusic *)playingMusic
{

     _playingMusic = playingMusic;

}

+ (ZHMusic *)playingMusic
{
    return _playingMusic;

}

+ (ZHMusic *)nextMusic
{

    // 1.先获取当前歌曲的下标值
    NSInteger currentIndex = [_music indexOfObject:_playingMusic];
    
    // 2.获取下一首歌的下标值
    NSInteger nextIndex = currentIndex + 1;
    if (nextIndex > _music.count - 1) {
        nextIndex = 0;
    }
    
    // 3.获取下一首歌曲
    ZHMusic *nextMusic = _music[nextIndex];
    
    return nextMusic;
    
}

+ (ZHMusic *)previousMusic
{
    
    // 1.先获取当前歌曲的下标值
    NSInteger currentIndex = [_music indexOfObject:_playingMusic];
    
    // 2.获取下一首歌的下标值
    NSInteger previousIndex = currentIndex - 1;
    if (previousIndex < 0) {
        previousIndex = _music.count - 1;
    }
    
    // 3.获取下一首歌曲
    ZHMusic *previousMusic  = _music[previousIndex];
    
    return previousMusic ;

}

@end
