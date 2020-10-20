//
//  ViewController.m
//  SoundBackProject
//
//  Created by Keyu Zhou on 2017/8/25.
//  Copyright © 2017年 ZCZ. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioPlayerDelegate>

// 后台播放音乐
@property(nonatomic,strong)AVAudioPlayer * audioPlayer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self playVoiceBackground];
}

- (void)playVoiceBackground{
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(dispatchQueue, ^(void) {
        
        NSError *audioSessionError = nil;
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        if ([audioSession setCategory:AVAudioSessionCategoryPlayback error:&audioSessionError]){
            
            NSLog(@"Successfully set the audio session.");
            
        } else {
            
            NSLog(@"Could not set the audio session");
            
        }
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *filePath = [mainBundle pathForResource:@"noVoice" ofType:@"mp3"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
        
        if (self.audioPlayer != nil){
            
            self.audioPlayer.delegate = self;
            
            [self.audioPlayer setNumberOfLoops:-1];
            
            if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]){
                
                NSLog(@"Successfully started playing...");
                
            } else {
                
                NSLog(@"Failed to play.");
                
            }
            
        }
        
    });
}

@end
