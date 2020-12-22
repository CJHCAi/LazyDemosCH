//
//  MyMusicHelper.h
//  Five Stone
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MyMusicHelper : NSObject

// 按照指定的文件名加载音乐文件
+ (AVAudioPlayer *)loadMusicPlayer:(NSString *)fileName;

// 按照指定的文件名加载音效文件
+ (SystemSoundID)loadSystemSound:(NSString *)fileName;

@end
