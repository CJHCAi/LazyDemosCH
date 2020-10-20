//
//  ZHAudioTool.h
//  QQMusic
//
//  Created by niugaohang on 15/9/11.
//  Copyright (c) 2015年 niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface ZHAudioTool : NSObject

+ (AVAudioPlayer *)playMusicWithMuiscName:(NSString *)musicName;

+ (void)pauseMusicWithMusicName:(NSString *)musicName;

+ (void)stopMusicWithMusicName:(NSString *)musicName;

@end
