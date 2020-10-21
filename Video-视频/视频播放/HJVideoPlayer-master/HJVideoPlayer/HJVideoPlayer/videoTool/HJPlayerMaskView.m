//
//  HJPlayerMaskView.m
//  HJVideoPlayer
//
//  Created by 黄静静 on 2017/7/19.
//  Copyright © 2017年 HJing. All rights reserved.
//

#import "HJPlayerMaskView.h"  

#define HJScreenWidth [UIScreen mainScreen].bounds.size.width
#define HJScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HJPlayerMaskView()
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton *screenControlBtn;
@property (nonatomic, strong) UILabel *totltTimeLab;
@property (nonatomic, strong) UILabel *currentTimenlab;
@property (nonatomic, assign) BOOL isPlayEnd; //是否播放完毕
@property (nonatomic, assign) BOOL isFullScreen; //是否全屏播放

@end

@implementation HJPlayerMaskView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

#pragma mark -

- (void)pauseVideo {
    if (!self.isForcePause) {
        self.isForcePause = YES;
        [self.delegate replayVideo];
        [self.playBtn setImage:[UIImage imageNamed:@"gww_pause"] forState:UIControlStateNormal];
    } else {
        self.isForcePause = NO;
        [self.playBtn setImage:[UIImage imageNamed:@"gww_play"] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(pauseVideo)]) {
            [self.delegate pauseVideo];
        }
    }
}

- (void)fullScreenControl {
    if (!self.isFullScreen) {
        self.isFullScreen = YES;
        self.backBtn.hidden = YES;
        [self.screenControlBtn setImage:[UIImage imageNamed:@"gww_normalScreen"] forState:UIControlStateNormal];
    } else {
        self.isFullScreen = NO;
        self.backBtn.hidden = NO;
        [self.screenControlBtn setImage:[UIImage imageNamed:@"gww_fullScreen"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(isFullScreen:)]) {
        [self.delegate isFullScreen:self.isFullScreen];
    }
}

- (void)sliderTouchBegin {
    [self.delegate pauseVideo];
}

- (void)sliderTouch {
    [self setCurrentTime:self.slider.value];
}

- (void)endslider {
    [self.delegate seekToTime:self.slider.value withBlock:^(BOOL finished) {
        
    }];
//    [self.delegate replayVideo];
}

- (void)loadProgress:(CGFloat)progress {
    [self.progressView setProgress:progress];
}

- (void)setTotaltTime:(Float64)time {
    self.totltTimeLab.text = [HJPlayerMaskView convertVideoDuration:time];
    self.slider.maximumValue = time;
}

- (void)setCurrentTime:(Float64)time {
    self.currentTimenlab.text = [HJPlayerMaskView convertVideoDuration:time];
    [self.slider setValue:time animated:YES];
}

- (void)backBtnAction {
    if ([self.delegate respondsToSelector:@selector(closeVideo)]) {
        [self.delegate closeVideo];
    }
}

#pragma mark - UI

- (void)setUpUI {
    
    self.isForcePause = YES;
    
    [self addSubview:self.backBtn];
    [self.backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.bottomView];
    
    [self.bottomView addSubview:self.playBtn];
    [self.playBtn addTarget:self action:@selector(pauseVideo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:self.screenControlBtn];
    [self.screenControlBtn addTarget:self action:@selector(fullScreenControl) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:self.totltTimeLab];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"/";
    lab.font = [UIFont systemFontOfSize:12];
    lab.textColor = [UIColor whiteColor];
    lab.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
    lab.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 78, 21,35, 20);
    [self.bottomView addSubview:lab];
    
    [self.bottomView addSubview:self.currentTimenlab];
    
    CGFloat sliderWidth = [UIScreen mainScreen].bounds.size.width - 48 - 117- 4;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50 , 30.5, sliderWidth-2, 2.5)];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha = 0.5;
    lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lineView.layer.cornerRadius = 1;
    [self.bottomView addSubview:lineView];
    
    UIProgressView *progressView = [[UIProgressView alloc] init];
    self.progressView = progressView;
    progressView.frame = CGRectMake(50 , 31, sliderWidth-2, 2.5);
    progressView.layer.cornerRadius = 1;
    progressView.tintColor = [UIColor grayColor];
    progressView.trackTintColor = [UIColor clearColor];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.bottomView addSubview:progressView];
    
    [self.bottomView addSubview:self.slider];
    [self.slider addTarget:self action:@selector(sliderTouchBegin) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(sliderTouch) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(endslider) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchCancel|UIControlEventTouchDragExit|UIControlEventTouchUpInside];
    
}

#pragma mark - Get
- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _backBtn.backgroundColor = [UIColor clearColor];
        _backBtn.frame = CGRectMake(0, 15, 50, 40);
        [_backBtn setImage:[UIImage imageNamed:@"gww_closeVideo"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 55, HJScreenWidth , 55)];
        _bottomView.backgroundColor = [UIColor clearColor];
        _bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    }
    return _bottomView;
}

- (UIButton *)playBtn {
    if (_playBtn == nil) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"gww_pause"] forState:UIControlStateNormal];
        _playBtn.frame = CGRectMake(15-15*0.5, 23-17*0.5, 30, 34);
    }
    return _playBtn;
}

- (UISlider *)slider{
    if (_slider == nil) {
        _slider = [[UISlider alloc] init];
        _slider.frame = CGRectMake(48, 30, HJScreenWidth - 48 - 117- 4, 4);
        _slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_slider setThumbImage:[UIImage imageNamed:@"gww_slidericon"]forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"gww_slidericon"]forState:UIControlStateHighlighted];
        [_slider setMaximumTrackTintColor:[UIColor clearColor]];
        [_slider setMinimumTrackTintColor:[UIColor orangeColor]];
    }
    return _slider;
}

- (UIButton *)screenControlBtn {
    if (_screenControlBtn == nil) {
        _screenControlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _screenControlBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        _screenControlBtn.frame = CGRectMake(HJScreenWidth - 30-15*0.5, 23-15*0.5, 30, 30);
        [_screenControlBtn setImage:[UIImage imageNamed:@"gww_fullScreen"] forState:UIControlStateNormal];
    }
    return _screenControlBtn;
}

- (UILabel *)totltTimeLab{
    if (_totltTimeLab == nil) {
        _totltTimeLab = [[UILabel alloc] init];
        _totltTimeLab.frame = CGRectMake(HJScreenWidth - 73, 21,35, 20);
        _totltTimeLab.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
        _totltTimeLab.text = @"00:00";
        _totltTimeLab.backgroundColor = [UIColor clearColor];
        _totltTimeLab.font = [UIFont systemFontOfSize:12];
        _totltTimeLab.textColor = [UIColor whiteColor];
    }
    return _totltTimeLab;
}

- (UILabel *)currentTimenlab{
    if (_currentTimenlab == nil) {
        _currentTimenlab = [[UILabel alloc] init];
        _currentTimenlab.frame = CGRectMake(HJScreenWidth - 111, 21,35, 20);
        _currentTimenlab.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
        _currentTimenlab.text = @"00:00";
        _currentTimenlab.font = [UIFont systemFontOfSize:12];
        _currentTimenlab.textColor = [UIColor whiteColor];
    }
    return _currentTimenlab;
}

@end
