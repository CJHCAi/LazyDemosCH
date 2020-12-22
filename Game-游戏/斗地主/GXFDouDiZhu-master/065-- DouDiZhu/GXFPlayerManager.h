//
//  GXFPlayerManager.h
//  04-- QQ音乐
//
//  Created by mac on 16/7/16.
//  Copyright © 2016年 GuXuefei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXFPlayerManager : NSObject

+ (instancetype)sharePlayerManager;

- (void)playMusicWithfileName:(NSString *)fileName;

- (void)pauseMusic;

@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, assign) NSTimeInterval currentTime;

- (void)setCurrentTime:(NSTimeInterval)currentTime;

@end
