//
//  SHJFirstViewController.m
//  TestBasicProjectOC
//
//  Created by shj on 2018/2/19.
//  Copyright © 2018年 shj. All rights reserved.
//

#import "SSFirstViewController.h"
#import "UIColor+hex.h"
#import "SSAudioPlayButton.h"
#import "SSNetAudioPlayButton.h"
#import "SSTimerManager.h"
#import "SSAudioManager.h"

@interface SSFirstViewController ()
@property (strong, nonatomic) SSAudioPlayButton *bundleAudioPlayButton;
@property (strong, nonatomic) SSAudioPlayButton *bundleAudioPlayButton2;
@property (strong, nonatomic) SSNetAudioPlayButton *netAudioPlayButton;

@property (strong, nonatomic) UIButton *stopPlayButton;
@end

@implementation SSFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self initLayout];
}

- (void)initData {
    [SSTimerManager.instance start];
}

- (void)initView {
    [self.view addSubview:self.bundleAudioPlayButton];
    [self.view addSubview:self.bundleAudioPlayButton2];
    [self.view addSubview:self.netAudioPlayButton];
    [self.view addSubview:self.stopPlayButton];
    
    // background-music-aac.caf
    // pew-pew-lei.caf
    self.bundleAudioPlayButton.fileUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bleeps.wav" ofType:@""]];
    self.bundleAudioPlayButton2.fileUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"background-music-aac.caf" ofType:@""]];
    self.netAudioPlayButton.auidoUrlString = @"音频播放地址";
    
    [self.stopPlayButton addTarget:self action:@selector(actionStopPlay:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initLayout {
    self.bundleAudioPlayButton.frame = CGRectMake(10, 74, 200, 36);
    self.bundleAudioPlayButton2.frame = CGRectMake(10, CGRectGetMaxY(self.bundleAudioPlayButton.frame) + 10, 200, 36);
    self.netAudioPlayButton.frame = CGRectMake(10, CGRectGetMaxY(self.bundleAudioPlayButton2.frame) + 10, 200, 36);
    self.stopPlayButton.frame = CGRectMake(10, CGRectGetMaxY(self.netAudioPlayButton.frame) + 10, 200, 36);
}

#pragma mark - Action

- (void)actionStopPlay:(id)sender {
    [SSAudioManager.instance stopPlay];
}


#pragma mark - Object

- (SSAudioPlayButton *)bundleAudioPlayButton {
    if (_bundleAudioPlayButton) {
        return _bundleAudioPlayButton;
    }
    _bundleAudioPlayButton = [[SSAudioPlayButton alloc] init];
    _bundleAudioPlayButton.backgroundColor = [UIColor colorWithHex:0x2196F3];
    return _bundleAudioPlayButton;
}

- (SSAudioPlayButton *)bundleAudioPlayButton2 {
    if (_bundleAudioPlayButton2) {
        return _bundleAudioPlayButton2;
    }
    _bundleAudioPlayButton2 = [[SSAudioPlayButton alloc] init];
    _bundleAudioPlayButton2.backgroundColor = [UIColor colorWithHex:0x2196F3];
    return _bundleAudioPlayButton2;
}

- (SSAudioPlayButton *)netAudioPlayButton {
    if (_netAudioPlayButton) {
        return _netAudioPlayButton;
    }
    _netAudioPlayButton = [[SSNetAudioPlayButton alloc] init];
    _netAudioPlayButton.backgroundColor = [UIColor colorWithHex:0x2196F3];
    return _netAudioPlayButton;
}

- (UIButton *)stopPlayButton {
    if (_stopPlayButton) {
        return _stopPlayButton;
    }
    _stopPlayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_stopPlayButton setTitle:@"停止播放" forState:UIControlStateNormal];
    return _stopPlayButton;
}


@end












