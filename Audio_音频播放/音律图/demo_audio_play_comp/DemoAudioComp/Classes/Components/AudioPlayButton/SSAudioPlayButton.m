//
//  SSAudioPlayButton.m
//  DemoAudioComp
//
//  Created by SHEN on 2018/9/3.
//  Copyright © 2018年 shj. All rights reserved.
//

#import "SSAudioPlayButton.h"
#import <AVFoundation/AVFoundation.h>
#import "SSPlayWaveForm.h"
#import "UIColor+hex.h"
#import "SSAudioManager.h"


@interface SSAudioPlayButton() <AVAudioPlayerDelegate>
// 动画
@property (strong, nonatomic) UIImageView *animatedVoiceImageView;
// 时间
@property (strong, nonatomic) UILabel *timeLabel;
// 音频波纹
@property (strong, nonatomic) SSPlayWaveForm *waveForm;
// 播放进度条
@property (strong, nonatomic) SSAudioPlayProgressBar *progessBar;
// 播放进度
@property (assign, nonatomic) CGFloat playPercentage;

@end

@implementation SSAudioPlayButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
        [self initGesture];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"[%@ dealloc]", [self class]);
    [self stopPlay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayout];
}

- (void)initData {
    self.playPercentage = 0;
}

- (void)initView {
    self.normalBackgroundColor = [UIColor colorWithHex:0x2196F3];
    self.hightlightBackgroundColor = [UIColor colorWithHex:0x64B5F6];
    
    [self addSubview:self.animatedVoiceImageView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.waveForm];
    [self addSubview:self.progessBar];
    
    self.backgroundColor = self.backgroundColor;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

- (void)initGesture {
    UILongPressGestureRecognizer *tapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    tapGesture.minimumPressDuration = 0;
    [self addGestureRecognizer:tapGesture];
}

- (void)updateLayout {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat marginH = 10;
    CGFloat marginV = 8;
    CGFloat barHeight = 3;
    self.animatedVoiceImageView.frame = CGRectMake(marginH, marginV, height - 2 * marginV, height - 2 * marginV);
    self.timeLabel.frame = CGRectMake(height + marginH, 0, width - height, height);
    self.waveForm.frame = CGRectMake(width - 60, marginV, 60 - marginH, height - 2 * marginV);
    self.progessBar.frame = CGRectMake(0, height - barHeight, width, barHeight);
}

- (void)bindNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyTimerCounting:) name:@"TimerCounting" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyAudioStartPlay) name:@"AudioDidStartPlay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyAudioDidStopPlay) name:@"AudioDidStopPlay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyAudioDidStopPlay) name:@"AudioDidForceStopPlay" object:nil];
}

- (void)unbindNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TimerCounting" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AudioDidStartPlay" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AudioDidStopPlay" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AudioDidForceStopPlay" object:nil];
}

#pragma mark - set / get

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor {
    _normalBackgroundColor = normalBackgroundColor;
    self.backgroundColor = normalBackgroundColor;
}

- (void)setPlayPercentage:(CGFloat)playPercentage {
    _playPercentage = playPercentage;
    self.progessBar.percentage = playPercentage;
}

#pragma mark - Public

- (void)startPlay {
    NSLog(@"startPlay");
    if (!self.fileUrl) {
        return;
    }
    SSAudioManager *audioManager = SSAudioManager.instance;
    
    // 波纹
    self.waveForm.hidden = NO;
    // 进度条
    self.progessBar.hidden = NO;
    // 动画
    [self.animatedVoiceImageView startAnimating];
    // 播放
    [audioManager play:self.fileUrl];
    // 时间
    self.timeLabel.text = [NSString stringWithFormat:@"%.1f 秒", audioManager.duration];
    
    // 调用代理
    if (_delegate && [_delegate respondsToSelector:@selector(audioPlayButtonDidStartPlay:)]) {
        [_delegate audioPlayButtonDidStartPlay:self];
    }
    
    // 通知
    [self bindNotification];
}

- (void)stopPlay {
    [SSAudioManager.instance stopPlay];
    
    // 停止动画
    [self.animatedVoiceImageView stopAnimating];
    // 隐藏波纹和进度条
    self.waveForm.hidden = YES;
    self.progessBar.hidden = YES;
    
    if (_delegate && [_delegate respondsToSelector:@selector(audioPlayButtonDidStopPlay:)]) {
        [_delegate audioPlayButtonDidStopPlay:self];
    }
    
    // 通知
    [self unbindNotification];
}

- (void)preparePlay {
    [self stopPlay];
    [self startPlay];
}

- (void)forceUpdateAppearance:(BOOL)isPlaying row:(NSInteger)row {
    SSAudioManager *audioManager = SSAudioManager.instance;
    if (isPlaying) {
        [self.animatedVoiceImageView startAnimating];
        self.waveForm.hidden = NO;
        self.progessBar.hidden = NO;
        self.timeLabel.hidden = NO;

        self.timeLabel.text = [NSString stringWithFormat:@"%.1f 秒", audioManager.duration];
        [self bindNotification];
    } else {
        [self.animatedVoiceImageView stopAnimating];
        self.waveForm.hidden = YES;
        self.progessBar.hidden = YES;
        self.timeLabel.hidden = YES;
        [self unbindNotification];
    }
}

#pragma mark - Notification

- (void)notifyStopPlaying {
    [self stopPlay];
}

- (void)notifyTimerCounting:(NSNotification *)notification {
    CGFloat power = [notification.object floatValue];
    [self updateMeters:power];
}

- (void)notifyAudioStartPlay {
//    [self startPlay];
}

- (void)notifyAudioDidStopPlay {
    NSLog(@"notifyAudioDidStopPlay");
    [self stopPlay];
}

#pragma mark - Private

- (NSURL *)fileUrlName:(NSString *)filepath{ 
    return [NSURL fileURLWithPath:filepath];
}

- (NSURL *)mainBundleFileUrl:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    return [NSURL fileURLWithPath:path];
}

- (void)updateMeters:(CGFloat)power {
    SSAudioManager *audioManager = SSAudioManager.instance;
    // 波纹
    [self.waveForm addPower:power];
    // 播放进度
    self.playPercentage = audioManager.currentTime / audioManager.duration;
}


#pragma mark - Gesture

- (void)gestureTap:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.backgroundColor = self.hightlightBackgroundColor;
            break;
        case UIGestureRecognizerStateEnded: {
            self.backgroundColor = self.normalBackgroundColor;
            /* 只有点击在自身区域内才触发播放 */
            CGPoint point = [gesture locationInView:self];
            if (CGRectContainsPoint(self.bounds, point)) {
                [self preparePlay];
            }
            break;
        }
        default:
            break;
        }
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.playPercentage = 1.0;
    [self stopPlay];
}

#pragma mark - Object

- (UIImageView *)animatedVoiceImageView {
    if (_animatedVoiceImageView) {
        return _animatedVoiceImageView;
    }
    _animatedVoiceImageView = [[UIImageView alloc] init];
    _animatedVoiceImageView.contentMode = UIViewContentModeScaleAspectFit;
    _animatedVoiceImageView.animationDuration = 1.0;
    _animatedVoiceImageView.animationRepeatCount = 0;
    NSBundle *bundle = [NSBundle mainBundle];
    UIImage *image1 = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"voice_animation_white1" ofType:@"png"]];
    UIImage *image2 = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"voice_animation_white2" ofType:@"png"]];
    UIImage *image3 = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"voice_animation_white3" ofType:@"png"]];
    _animatedVoiceImageView.animationImages = @[image1, image2, image3];
    _animatedVoiceImageView.image = image3;
    return _animatedVoiceImageView;
}

- (UILabel *)timeLabel {
    if (_timeLabel) {
        return _timeLabel;
    }
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor whiteColor];
    return _timeLabel;
}

- (SSPlayWaveForm *)waveForm {
    if (_waveForm) {
        return _waveForm;
    }
    _waveForm = [[SSPlayWaveForm alloc] init];
//    _waveForm.backgroundColor = [UIColor blueColor];
    return _waveForm;
}

- (SSAudioPlayProgressBar *)progessBar {
    if (_progessBar) {
        return _progessBar;
    }
    _progessBar = [[SSAudioPlayProgressBar alloc] init];
    _progessBar.backgroundColor = [UIColor colorWithHex:0xBBDEFB];
    return _progessBar;
}

@end















