//
//  GXFPlayYinXiao.m
//  065-- DouDiZhu
//
//  Created by 顾雪飞 on 17/6/4.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "GXFPlayYinXiao.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@implementation GXFPlayYinXiao

// 声明要保存音效文件的变量
SystemSoundID soundID;

- (void)playYinXiaoWithFileName:(NSString *)fileName{
    
    // 加载文件
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:nil]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileURL), &soundID);
    
    // 播放短频音效
    AudioServicesPlayAlertSound(soundID);
    
    // 增加震动效果，如果手机处于静音状态，提醒音将自动触发震动
//    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
}


@end
