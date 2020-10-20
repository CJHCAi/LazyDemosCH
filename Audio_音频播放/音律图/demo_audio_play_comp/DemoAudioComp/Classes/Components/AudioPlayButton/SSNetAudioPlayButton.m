//
//  SSNetAudioPlayButton.m
//  DemoAudioComp
//
//  Created by SHEN on 2018/9/4.
//  Copyright © 2018年 shj. All rights reserved.
//

#import "SSNetAudioPlayButton.h"
#import "SSAudioPlayProgressBar.h"
#import "SSNetManager.h"
#import "UIColor+hex.h"
#import "SSAudioManager.h"

@interface SSNetAudioPlayButton()

@end

@implementation SSNetAudioPlayButton

- (void)setAuidoUrlString:(NSString *)auidoUrlString {
    _auidoUrlString = auidoUrlString;
}

- (void)preparePlay {
    // 下载过程中，需要停止其他已播放音频播放
    [self stopPlay];
    
    // 下载进度条颜色
    self.progessBar.hidden = NO;
    self.progessBar.barTintColor = [UIColor colorWithHex:0xF44336];
    self.timeLabel.text = @"下载中...";
    
    NSURL *url = [NSURL URLWithString:self.auidoUrlString];
    __weak typeof(self) weakSelf = self;
    [SSNetManager.instance downloadFile:url progress:^(float progress) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.progessBar.percentage = progress;
        });
        
    } complete:^(NSURL *filePathUrl) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.fileUrl = filePathUrl;
        // 播放进度条颜色
        self.progessBar.barTintColor = [UIColor colorWithHex:0x00BFA5];
        // 开始播放
        [strongSelf startPlay];
    }];
}

@end
