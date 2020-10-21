//
//  NHPlayerView.m
//  VideoEditDemo
//
//  Created by JSB-hejiamin on 2018/2/24.
//  Copyright © 2018年 JSB-hejiamin. All rights reserved.
//
#import "CHPlayerView.h"
#import <QuartzCore/QuartzCore.h>


@interface CHPlayerView ()

@property(nonatomic, retain)UILabel *timeLabel;
@property(nonatomic, retain)UILabel *durationTimeLabel;
@property(nonatomic, retain)UISlider *progressSlider;
@property(nonatomic, retain)UIView *bottomView;
@property(nonatomic, retain)UIActivityIndicatorView *indicator;
@property(nonatomic,strong)NSURL * playerURL;
@property(nonatomic, assign)CGFloat durationTime;
@property(nonatomic, assign)BOOL isPlaying;


@end

@implementation CHPlayerView
static CGFloat videoToolH=44;
// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor=RGBColor(16, 16, 16);
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    
    [self bottomView];
    [self timeLabel];
    [self durationTimeLabel];
    [self progressSlider];
}


#pragma mark 设置PlayerURLStr
- (void)setPlayerURLStr:(NSURL *)videoUrl{

    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    _playerLayer.frame =CGRectMake(0, 0, self.width,self.height-videoToolH);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:_playerLayer];
    [self playImageView];
    [self addNotificationCenters];
    [self addPlayProgress];
    // 创建轻点手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPauseClicked)];
    [self addGestureRecognizer:tap];
    if (_isPlaying==NO) {
        [self playOrPauseClicked];
    }


}

/**创建layer浮层*/
-(void)createCoverImgV{
    [self CoverImgV];
}

#pragma mark -进度条滑动的响应事件
-(void)sliderBegin{
    if (_isPlaying==YES) {
        [self playOrPauseClicked];
    }
}
- (void)sliderChange{
    double currentTime = self.durationTime * self.progressSlider.value;
    CMTime drage = CMTimeMake(currentTime, 1);
    [self.player seekToTime:drage completionHandler:^(BOOL finished) {
        
    }];
}

-(void)sliderEnd{
    if (_isPlaying==NO) {
        [self playOrPauseClicked];
    }
}



/**重新播放视频*/
- (void)rePlayVideo{

    [self.player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        if (_isPlaying==NO) {
            [self playOrPauseClicked];
        }
    }];
}

#pragma mark 轻点播放视图
- (void)playOrPauseClicked{
    
    if(self.isPlaying == YES){
        [self.player pause];
        [self.playImageView setHidden:NO];
        [self.indicator stopAnimating];
        self.isPlaying = NO;
        
        if ([_delegate respondsToSelector:@selector(CHPlayerView_playerPause)]) {
            [_delegate CHPlayerView_playerPause];
        }
    }else{
        [self.player play];
        [self.playImageView setHidden:YES];
        self.isPlaying=YES;
        if ([_delegate respondsToSelector:@selector(CHPlayerView_playerPlay)]) {
            [_delegate CHPlayerView_playerPlay];
        }
    }
}

#pragma mark 添加监听方式,播放开始,播放结束,屏幕旋转
- (void)addNotificationCenters{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStart:) name:AVPlayerItemTimeJumpedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}


- (void)movieStart:(NSNotification *)notification{
    [self.indicator stopAnimating];
}

- (void)movieEnd:(NSNotification *)notification{
    [self.player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        _isPlaying=NO;
        if (_isPlaying==NO) {
            [self playOrPauseClicked];
        }
        if([_delegate respondsToSelector:@selector(CHPlayerView_playStatusEnd)]){
            [_delegate CHPlayerView_playStatusEnd];
        }
    }];
}
-(void)EnterBackground{
    if (_isPlaying==YES) {
        [self playOrPauseClicked];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark-设置播放进度
- (void)addPlayProgress{
    __weak CHPlayerView *weakself = self;
    // 设置为每一秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 50) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CGFloat durationTime = CMTimeGetSeconds(weakself.playerItem.duration);
        CGFloat currentTime = CMTimeGetSeconds(weakself.playerItem.currentTime);
        

        weakself.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)currentTime / 60,(int)currentTime % 60];
        weakself.durationTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)durationTime / 60, (int)durationTime % 60];
        weakself.progressSlider.value = currentTime / durationTime;
        // 保存总时长,用在手动快进的时候
        weakself.durationTime = durationTime;
        
    }];
}

#pragma mark -播放器播放与暂停
- (void)playerPlay{
    if (_isPlaying==NO) {
        [self playOrPauseClicked];
    }
}

- (void)playerPause{
    if (_isPlaying==YES) {
        [self playOrPauseClicked];
    }
}

-(void)destroyPlayer{
    [_player pause];
    _player=nil;
}
#pragma mark-懒加载
-(UIActivityIndicatorView *)indicator{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _indicator.backgroundColor = [UIColor clearColor];
        _indicator.center = CGPointMake(self.width / 2, self.height / 2);
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:_indicator];
        [self.indicator startAnimating];

    }
    return _indicator;
}
-(UISlider *)progressSlider{
    if (!_progressSlider) {
        
        _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 44/2-15/2-1, self.width - 105, 15)];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateHighlighted];
        _progressSlider.maximumTrackTintColor = [UIColor colorWithRed:73.0f/255.0f green:73.0f/255.0f blue:73.0f/255.0f alpha:1.0];
        _progressSlider.minimumTrackTintColor = [UIColor whiteColor];
        
        // 添加响应事件
        [_progressSlider addTarget:self action:@selector(sliderBegin) forControlEvents:UIControlEventTouchDragInside];
        [_progressSlider addTarget:self action:@selector(sliderChange) forControlEvents:UIControlEventValueChanged];
        [_progressSlider addTarget:self action:@selector(sliderEnd) forControlEvents:UIControlEventTouchUpInside];

        [self.bottomView addSubview:_progressSlider];

    }
    return _progressSlider;
}
-(UILabel *)durationTimeLabel{
    if (!_durationTimeLabel) {
        _durationTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 50, 44/2-15/2, 40, 15)];
        [_durationTimeLabel setTextAlignment:NSTextAlignmentCenter];
        _durationTimeLabel.font = [UIFont systemFontOfSize:12];
        _durationTimeLabel.textColor = [UIColor whiteColor];
        _durationTimeLabel.text = @"00:00";
        [self.bottomView addSubview:_durationTimeLabel];

    }
    return _durationTimeLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44/2-15/2, 40, 15)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor whiteColor];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
        _timeLabel.text = @"00:00";
        [self.bottomView addSubview:_timeLabel];
    }
    return _timeLabel;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - videoToolH, self.width, videoToolH)];
        _bottomView.backgroundColor = RGBColor(16, 16, 16);
        [self addSubview:_bottomView];
    }
    return _bottomView;
}



-(UIImageView *)playImageView{
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _playImageView.center = CGPointMake(self.width / 2, (self.height-videoToolH) / 2);
        [_playImageView setImage:[UIImage imageNamed:@"qushuiyin_play"]];
        [_playImageView setHidden:YES];
        [_playImageView setUserInteractionEnabled:YES];
        [self addSubview:_playImageView];
    }
    return _playImageView;
}

-(UIImageView *)CoverImgV{
    if (!_CoverImgV) {
        _CoverImgV = [[UIImageView alloc]initWithFrame:_playerLayer.videoRect];
        [_CoverImgV setUserInteractionEnabled:YES];
        [_CoverImgV.layer setMasksToBounds:YES];
        [self addSubview:_CoverImgV];
    }
    return _CoverImgV;
}



@end
