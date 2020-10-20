//
//  ZHMusicTool
//  QQMusic
//
//  Created by niugaohang on 15/9/11.
//  Copyright (c) 2015年 niu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZHMusic;

@interface ZHMusicTool : NSObject

+ (NSArray *)musics;

+ (void)setPlayingMusic:(ZHMusic *)playingMusic;

+ (ZHMusic *)playingMusic;

+ (ZHMusic *)nextMusic;

+ (ZHMusic *)previousMusic;



@end
