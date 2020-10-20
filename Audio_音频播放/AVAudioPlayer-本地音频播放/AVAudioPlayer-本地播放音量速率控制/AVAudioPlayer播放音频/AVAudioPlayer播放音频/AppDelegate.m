//
//  AppDelegate.m
//  AVAudioPlayer播放音频
//
//  Created by shibin on 15/10/14.
//  Copyright © 2015年 shibin. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //配置音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    //添加会话分类功能（音频的行为）有好多种默认行为
    if (![session setCategory:AVAudioSessionCategoryPlayback error:&error]) {
        NSLog(@"%@",error);
    }
    if (![session setActive:YES error:&error]) {
        NSLog(@"%@",error);
    }
    
    
    return YES;
}



@end
