//
//  MyMusicHelper.m
//  Five Stone
//


#import "MyMusicHelper.h"

@implementation MyMusicHelper

// 按照指定的文件名加载音乐文件
+ (AVAudioPlayer *)loadMusicPlayer:(NSString *)fileName
{
    NSURL *url = [[NSBundle mainBundle]URLForResource:fileName withExtension:nil];
    
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    [player prepareToPlay];
    
    return player;
}

// 按照指定的文件名加载音效文件
+ (SystemSoundID)loadSystemSound:(NSString *)fileName
{
    SystemSoundID soundId;
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:fileName withExtension:nil];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundId);
    
    return soundId;
}

@end
