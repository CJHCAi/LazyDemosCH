//
//
//  Created by lishan04 on 15-11-1.
//  Copyright (c) 2015 lishan04. All rights reserved.
//


#import "BaiduMobAdNativeVideoView.h"
#import "BaiduMobAdNativeAdObject.h"
#import <AVFoundation/AVFoundation.h>

@interface BaiduMobAdNativeVideoView () {
   //视频播放状态
    enum State {
        INIT,
        PLAYING,
        PAUSING,
        BUFFERING,
        COMPLETE
    } _state;
    
}
@property (nonatomic, retain)   UISlider *progress;//播放进度
@property (nonatomic, retain)   UIButton *btnPlayOrPause; //播放/暂停按钮
@property (nonatomic, retain)   UIButton *btnFullScreen; //fullscreen按钮
@property (nonatomic, retain)   UIButton *btnDone; //全屏时back按钮
@property (nonatomic, retain)   UIView *controlView;//包含fullscreen按钮，播放按钮，进度按钮
@property (nonatomic)   BOOL    isFullScreen;//当前是否全屏
@property (nonatomic)   BOOL    isFirstTimePlay;//是否第一次播放
@property (nonatomic)   BOOL    metaLoaded;//视频是否加载
@property (nonatomic)   CGRect  originFrame;//非全屏视图frame
@property (nonatomic, retain)   UIActivityIndicatorView *indicatorView;

/* 当前videoview对应的BaiduMobAdNativeAdObject，用来发送状态日志*/
@property (nonatomic, retain)   BaiduMobAdNativeAdObject *associatedObject;
@property (nonatomic, retain) UIView            *displayView;//视频展现的view
@property (nonatomic, retain) NSURL             *url;//视频url
@property (nonatomic, retain) AVPlayer          *player;
@property (nonatomic, retain) AVPlayerLayer     *playerLayer;
@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;//点击视频区域隐藏和显示控制条
@property (nonatomic, assign) UIView *originSuperView;//非全屏superview
@property (nonatomic)       id playbackObserver;
//创建和调整ui布局，全屏和恢复时调用，添加播放暂停，进度条，全屏，回退按钮
- (void)setupUI;

#warning 重要，当视频区域可见时才开始播放，当不可见时停止播放
- (void)checkVisible;

//点击监控，当点击视频区域时展现和隐藏进度条
- (void)handleTapGesture:(UIGestureRecognizer*)sender;

//resize 视频区域
- (void)resizePlaybackFrame:(CGRect )rect;

//设置视频区域
- (void)layoutDisplayArea;

//播放前播放器创建和准备
- (void)startPlayback;

//播放后播放器removeObserver
- (void)cleanUp;

//播放视频
- (void)displayVideo;

//关闭视频和视频播放失败
- (void)completePlayback;

//播放速度改变
- (void)onPlayerRateChange;

//播放状态改变
- (void)onPlaybackLikelyToKeepUpChange;

//播放失败
- (void)playbackFail:(NSString *)errorData;

//点击播放/暂停按钮
- (void)playClick:(UIButton *)sender;

// 点击全屏按钮
- (void)clickFullScreen:(UIButton *)sender;

// 点击广告详情按钮
- (void)videoAdClick;

//添加进度条监控
- (void)addProgressObserver;

//添加进度条位置改变
- (void)updateValue:(id)sender;

// 当前播放时间
- (NSTimeInterval)currentTime;

//视频时长
- (NSTimeInterval)duration;

//是否正在播放
- (BOOL)isPlaying;

- (void)onPlayerItemFail:(NSNotification *)notification;

// 视频播放
- (void)onPlayerItemDidReachEnd:(NSNotification *)notification;

// kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

- (UIImage *)imageResoureForName:(NSString*)name;
@end

@implementation BaiduMobAdNativeVideoView

#pragma mark - Public Methods
- (instancetype)initWithFrame:(CGRect)frame andObject:(BaiduMobAdNativeAdObject *)object {
    if (self = [super initWithFrame:frame]) {
        _originFrame = frame;
        _state = INIT;
        _isFullScreen = NO;
        _url = [NSURL URLWithString: object.videoURLString];
        _associatedObject = object;
        _isFirstTimePlay = YES;
        self.hidden = YES;
        _isAutoPlay = YES;
    }
    return self;
}

#pragma mark - clean up Methods

- (void)dealloc {
    [self stop];
    [self cleanUp];
    self.btnLP = nil;
    self.progress = nil;
    self.btnPlayOrPause = nil;
    self.btnFullScreen = nil;
    self.btnDone = nil;
    self.controlView = nil;
    self.indicatorView = nil;
    self.associatedObject = nil;
    self.tapGesture = nil;
    self.displayView = nil;
    self.url = nil;
    self.player = nil;
    self.playerLayer = nil;
    self.originSuperView = nil;
}


- (void)cleanUp {
    self.hidden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkVisible) object:nil];

    if (self.player && _state != COMPLETE) {
        [self.player removeTimeObserver:self.playbackObserver];
        [self.player removeObserver:self forKeyPath:@"rate"];
        [[self.player currentItem] removeObserver:self forKeyPath:@"status"];
        [[self.player currentItem] removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        [self.playerLayer removeObserver:self forKeyPath:@"readyForDisplay"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)setupUI {
    self.backgroundColor = [UIColor blackColor];
    
    if (!self.indicatorView) {
        self.indicatorView =  [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicatorView.frame = CGRectMake(self.displayView.frame.size.width/2 - 20, self.displayView.frame.size.height/2 - 20, 40, 40);
    } else {
        [self.indicatorView removeFromSuperview];
    }
    [self.displayView addSubview:self.indicatorView];

    
    if (!self.controlView) {
        self.controlView = [[UIView alloc]init];
        self.controlView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.controlView.hidden = YES;
        [self.displayView addSubview:self.controlView];
    } else {
        [self.controlView removeFromSuperview];
        [self.displayView addSubview:self.controlView];
    }
    
    
    self.controlView.frame = CGRectMake(0, self.displayView.frame.size.height - 32, self.displayView.frame.size.width, 32);

    if (!self.btnPlayOrPause) {
        self.btnPlayOrPause = [[UIButton alloc]initWithFrame:CGRectMake(10, 2, 32, 32)];
        [_btnPlayOrPause setImage:[self imageResoureForName:@"player_play"] forState:UIControlStateNormal];
        [_btnPlayOrPause addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.controlView addSubview:_btnPlayOrPause];
    }
    
    if (!self.btnFullScreen) {
        self.btnFullScreen = [[UIButton alloc]init];
        [_btnFullScreen setImage:[self imageResoureForName:@"fullscreen"] forState:UIControlStateNormal];
        [_btnFullScreen addTarget:self action:@selector(clickFullScreen:) forControlEvents:UIControlEventTouchUpInside];
        [_controlView addSubview:_btnFullScreen];
    }
    _btnFullScreen.frame = CGRectMake(self.controlView.frame.size.width - 36, 2, 32, 32);
    
    [self addProgressObserver];
    
    if (!self.btnDone) {
        self.btnDone = [[UIButton alloc]initWithFrame:CGRectMake(15, 5, 32, 32)];
        [_btnDone setImage:[self imageResoureForName:@"player_back"] forState:UIControlStateNormal];
        [_btnDone addTarget:self action:@selector(clickFullScreen:) forControlEvents:UIControlEventTouchUpInside];
        _btnDone.hidden = YES;
        [self.displayView addSubview:_btnDone];
    } else  {
        [_btnDone removeFromSuperview];
        [self.displayView addSubview:_btnDone];
    }
    
    
    if (!self.btnLP) {
        self.btnLP = [[UIButton alloc]init];
        BaiduMobNativeAdActionType type = _associatedObject.actType;
        if (type == BaiduMobNativeAdActionTypeDL) {
            [_btnLP setImage:[self imageResoureForName:@"click_download"] forState:UIControlStateNormal];
        } else if (type == BaiduMobNativeAdActionTypeLP){
            [_btnLP setImage:[self imageResoureForName:@"click_lp"] forState:UIControlStateNormal];
        }
        
        [_btnLP addTarget:self action:@selector(videoAdClick) forControlEvents:UIControlEventTouchUpInside];
        _btnLP.hidden = YES;
        [self.displayView addSubview:_btnLP];
    } else {
        [_btnLP removeFromSuperview];
        [self.displayView addSubview:_btnLP];
    
    }
    
    if (self.isFullScreen) {
        _btnFullScreen.hidden = YES;
        _btnDone.hidden = NO;
        self.btnLP.frame = CGRectMake(self.displayView.frame.size.width - 90, self.displayView.frame.size.height - 68, 84, 30);

    } else {
        _btnFullScreen.hidden = NO;
        _btnDone.hidden = YES;
        if (_state != INIT) {
            _btnLP.hidden = NO;
        }
        
        self.btnLP.frame = CGRectMake(self.displayView.frame.size.width - 75, self.displayView.frame.size.height - self.controlView.frame.size.height - 30, 70, 25);

        
    }
}

- (UIImage *)imageResoureForName:(NSString*)name
{
    NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"baidumobadsdk" ofType:@"bundle"];
    NSBundle* b=  [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageWithContentsOfFile: [b pathForResource:name ofType:@"png"]];
}

- (void)checkVisible {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkVisible) object:nil];
    
    if (_state != COMPLETE) {
        [self performSelector:@selector(checkVisible) withObject:self afterDelay:1];
    }

    //一半在屏幕上自动播放,离开屏幕停止播放
    UIView *view_ = self;
    CGRect rect = [[view_ superview] convertRect:view_.frame toView:view_.window];
    CGRect visibleRect = CGRectIntersection (rect,view_.window.frame);
    if (_state == INIT && visibleRect.size.width * visibleRect.size.height >= view_.frame.size.width * view_.frame.size.height /2) {
        [self displayVideo];
    }
    if (_state != COMPLETE && CGRectIsEmpty(visibleRect)) {
        [self stop];
    }
    
}

- (void)handleTapGesture:(UIGestureRecognizer*)sender {
    CGPoint point = [sender locationInView:self.controlView];
    CGPoint point2 = [sender locationInView:self.btnDone];

    if (!CGRectContainsPoint(self.controlView.bounds, point) &&
        !CGRectContainsPoint(self.btnDone.bounds, point2)) {
        self.controlView.hidden = !self.controlView.isHidden;
        if (self.isFullScreen){
            self.btnDone.hidden = self.controlView.isHidden;
        }
    }
}

- (void)play {
    [self sendVideoEvent:onClickToPlay currentTime:0];
    self.hidden = NO;
    if (_state == INIT) {
        [self startPlayback];
    } else if (_state == PAUSING) {
        _state = PLAYING;
        [self.player play];
    } else if (_state == PLAYING) {
        [self.player play];
    } else if (_state == COMPLETE) {
        _state = INIT;
        [self startPlayback];
    }
}

- (void)pause {
    if (_state == PLAYING) {
        _state = PAUSING;
        [self.player pause];
    }
}

- (void)stop {
    if (self.player && _state != COMPLETE) {
        if (_state != INIT) {
            [self sendVideoEvent:onClose currentTime:[self currentTime]];
        }
        [[[self.player currentItem] asset] cancelLoading];
        [self completePlayback];
    }
}

- (NSTimeInterval)duration {
    if (self.metaLoaded) {
        return CMTimeGetSeconds([[self.player currentItem] duration]);
    }
    return -1;
}

- (NSTimeInterval)currentTime {
    if (self.metaLoaded) {
        return CMTimeGetSeconds([[self.player currentItem] currentTime]);
    }
    return -1;
}

- (void)resizePlaybackFrame:(CGRect )rect {
        self.frame= rect;
        [self layoutDisplayArea];
}

#pragma mark - KV Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (object == [self.player currentItem]) {
        if ([keyPath isEqualToString:@"status"]) {
            if ([self.player currentItem].status == AVPlayerItemStatusReadyToPlay) {
                self.metaLoaded = YES;
            }
            if ([self.player currentItem].status == AVPlayerItemStatusFailed) {
                [self playbackFail:@"IO_ERROR"];
            }
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            if (_state == COMPLETE) {
                return;
            }
            [self onPlaybackLikelyToKeepUpChange];
        }
    } else if (object == self.playerLayer) {
        if ([keyPath isEqualToString:@"readyForDisplay"]) {
            if (self.playerLayer.readyForDisplay) {
#warning 先检测可见性再播放
                [self checkVisible];
            }
        }
    } else if (object == self.player) {
        if ([keyPath isEqualToString:@"rate"]) {
            [self onPlayerRateChange];
        }
    }
}

#pragma mark - PlayerItem event handler
- (void)onPlayerItemFail:(NSNotification *)notification {
    NSError *error = [notification.userInfo objectForKey:AVPlayerItemFailedToPlayToEndTimeErrorKey];
    [self playbackFail:[error description]];
}

- (void)onPlayerItemDidReachEnd:(NSNotification *)notification {
    [self cleanUp];
    _state = COMPLETE;
    if (self.isFullScreen) {
        [self clickFullScreen:_btnFullScreen];
    }
    [self sendVideoEvent:onComplete currentTime:[self currentTime]];
}

#pragma mark - Playback related Methods

- (void)startPlayback {
    
    self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:self.tapGesture];
    
    self.metaLoaded = NO;
    self.player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:self.url]];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];

    [self.player addObserver:self forKeyPath:@"rate" options:0 context:nil];
    [[self.player currentItem] addObserver:self forKeyPath:@"status" options:0 context:nil];
    [[self.player currentItem] addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:0 context:nil];
    [self.playerLayer addObserver:self forKeyPath:@"readyForDisplay" options:0 context:nil];
	
    _displayView = [[UIView alloc] init];
    self.displayView.backgroundColor = [UIColor blackColor];
    [[self.displayView layer] addSublayer:self.playerLayer];

    [self layoutDisplayArea];
    
    [self.indicatorView startAnimating];
    self.progress.value = 0.0;
}

- (void)completePlayback {
    [self.player pause];
    [self cleanUp];
    _state = COMPLETE;
}

- (void)displayVideo {
    if (_state == INIT) {
        [self.indicatorView stopAnimating];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeOrientation) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPlayerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPlayerItemFail:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.player.currentItem];
        [self.player play];
    }
}

- (void)layoutDisplayArea {
    if (self.displayView) {
        [self.displayView removeFromSuperview];
        self.displayView.frame = self.bounds;
        self.playerLayer.frame = self.displayView.bounds;
        [self addSubview:self.displayView];
        [self setupUI];
    }
}

- (void)onPlayerRateChange {
    if (_state == INIT && self.player.rate > 0) {
        _state = PLAYING;
        _btnLP.hidden = NO;
        [self sendVideoEvent:onStart currentTime:0];
    }

    if(self.player.rate==0){
        [self.btnPlayOrPause setImage:[self imageResoureForName:@"player_play"] forState:UIControlStateNormal];
    }else {
        [self.btnPlayOrPause setImage:[self imageResoureForName:@"player_pause"] forState:UIControlStateNormal];
    }
}

- (void)onPlaybackLikelyToKeepUpChange {
    Float64 currentTime = CMTimeGetSeconds([self.player currentTime]);
    Float64 duration = CMTimeGetSeconds([[self.player currentItem] duration]);
    Float64 delta = duration - currentTime;
    delta = delta > 0 ? delta : 0;
    if ([self.player currentItem].playbackLikelyToKeepUp) {
        if (_state == BUFFERING) {
            _state = PLAYING;
            [self.player play];
        } else if (_state == INIT) {
            [self displayVideo];
        }
    } else {
        if (_state == PLAYING) {
            _state = BUFFERING;
            [self.player pause];
        }
    }
}

- (void)playbackFail:(NSString *)errorData {
    [self completePlayback];
    [self sendVideoEvent:onError currentTime:[self currentTime]];
}


- (BOOL)isPlaying {
	return _state == PLAYING;
}

#pragma mark - handle rotate
- (void)didChangeOrientation {
    UIInterfaceOrientation currentOrientaion = [[UIApplication sharedApplication]statusBarOrientation];
    CGFloat angle;
    if (!self.isFullScreen) {
        return;
    }
    if ([self newWindowTransform]) {
        switch (currentOrientaion) {
            case UIInterfaceOrientationPortrait:
                angle = M_PI / 2;
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                angle = - M_PI / 2;
                break;
            default:
                break;
        }
        
    } else {
        switch (currentOrientaion) {
            case UIInterfaceOrientationPortrait:
                angle = M_PI / 2;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                angle = - M_PI / 2;
                break;
            case UIInterfaceOrientationLandscapeRight:
                angle = M_PI / 2;
                break;
            default:
                break;
        }
    }
    
    self.transform = CGAffineTransformMakeRotation(angle);
    [self resizePlaybackFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
}

// iOS 9 mainscreen方向会随着UIInterfaceOrientation而改变，在window上加transform
// iOS 6以前mainscreen方向不会随着UIInterfaceOrientation而改变，只会在subview加transform
- (BOOL)newWindowTransform {
    UIInterfaceOrientation currentOrientaion = [UIApplication sharedApplication].statusBarOrientation;
    float screenW = [UIScreen mainScreen].bounds.size.width;
    float screenH = [UIScreen mainScreen].bounds.size.height;
    if (UIInterfaceOrientationIsLandscape(currentOrientaion) && screenW < screenH) {
        return NO;
    }
    return YES;
}

#pragma mark -

- (void)playClick:(UIButton *)sender {
    if(self.player.rate==0){ //说明时暂停
        [sender setImage:[self imageResoureForName:@"player_pause"] forState:UIControlStateNormal];
        [self.player play];
    }else if(self.player.rate==1){//正在播放
        [self.player pause];
        [sender setImage:[self imageResoureForName:@"player_play"] forState:UIControlStateNormal];
    }
}

- (void)clickFullScreen:(UIButton *)sender {
    self.isFullScreen = !self.isFullScreen;
//    
//    [[UIApplication sharedApplication] setStatusBarHidden:!self.isFullScreen withAnimation:UIStatusBarAnimationNone];
    
    if (self.isFullScreen) {
        self.originSuperView = [self superview];
        
        [self didChangeOrientation];
        
        [self removeFromSuperview];
        [[[UIApplication sharedApplication]keyWindow]addSubview:self];

        [self sendVideoEvent:onFullScreen currentTime:[self currentTime]];
        


    } else {
        CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(0);
        self.transform = landscapeTransform;
        
        [self resizePlaybackFrame:_originFrame];
        
        [self removeFromSuperview];
        [self.originSuperView addSubview:self];
    }
}

- (void)videoAdClick {
    [self sendVideoEvent:onClick currentTime:[self currentTime]];
}

- (void)addProgressObserver {
    AVPlayerItem * item = self.player.currentItem;
    if (!self.progress) {
         UIImage *thumbImage = [self imageResoureForName:@"slider"];

        self.progress = [[UISlider alloc]init];
        [self.controlView addSubview:self.progress];
        [self.progress addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
        [self.progress setThumbImage:thumbImage forState:UIControlStateHighlighted];
        [self.progress setThumbImage:thumbImage forState:UIControlStateNormal];
    }
    
    __block UISlider *slider = self.progress;
    self.playbackObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([item duration]);
        if (current) {
            [slider setValue:(current/total) animated:YES];
        }
    }];
    self.progress.frame = CGRectMake(48, 0, self.controlView.frame.size.width - 96, 32);
}

- (void)updateValue:(id)sender {
    if ([sender isKindOfClass:[UISlider class]]) {
        float value = [(UISlider *)sender value];
        AVPlayerItem * item = self.player.currentItem;
        float total = CMTimeGetSeconds([item duration]);
        float target = total * value;
        CMTime timer = CMTimeMake(target, 1);
        [self.player seekToTime:timer];
    }
}

#pragma mark - sendVideoEvent
- (void)sendVideoEvent:(BaiduAdNativeVideoEvent)event currentTime:(NSTimeInterval) currentTime {
    if (event == onClick) {
        [self.associatedObject trackVideoEvent:event withCurrentTime:currentTime];
    } else {
        if (_isFirstTimePlay) {
            [self.associatedObject trackVideoEvent:event withCurrentTime:currentTime];
            if (event == onClose || event == onComplete) {
                _isFirstTimePlay = NO;
            }
        }
    }
}

- (void)didMoveToWindow {
    if (self.window && _isAutoPlay) {
        [self play];
    }
}
@end
