//
//  NHPlayerView.m
//  VideoEditDemo
//
//  Created by JSB-hejiamin on 2018/2/24.
//  Copyright © 2018年 JSB-hejiamin. All rights reserved.
//
#import "NHPlayerView.h"


#define Width self.frame.size.width
#define Height self.frame.size.height

@interface NHPlayerView ()

// 显示进度时间的Label
@property(nonatomic, retain)UILabel *timeLabel;
// 显示总时间的Label
@property(nonatomic, retain)UILabel *durationTimeLabel;
// 显示进度的进度条
@property(nonatomic, retain)UISlider *progressSlider;
// 底部进度显示视图
@property(nonatomic, retain)UIView *bottomView;
// 显示播放按钮
@property(nonatomic, retain)UIImageView *playButtonImageView;
// 保存视频的总时长
@property(nonatomic, assign)CGFloat durationTime;
// 判断是否点击了播放视图
@property(nonatomic, assign)BOOL isTap;
// 判断当前视频是否开始播放了
@property(nonatomic, assign)NSInteger isPlay;
// 加载视频时候出现的加载图标
@property(nonatomic, retain)UIActivityIndicatorView *indicator;
@property(nonatomic,strong)NSURL * playerURL;


@end

@implementation NHPlayerView

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor=[UIColor blackColor];
    }
    return self;
}

#pragma mark 设置PlayerURLStr
- (void)setPlayerURLStr:(NSString *)playerURLStr{
    if(_playerURLStr != playerURLStr){
        _playerURLStr = playerURLStr;
    }
    // 创建播放器
    [self createPlayer];
    // 启动播放器
    [self playerPlay];
}

-(UIImageView *)videoView{
    if (!_videoView) {
        UIImage * currentImage=[VideoService GetThumbnailImageForVideo:_playerURL atTime:0];
        CGFloat videoH=self.height-44;
        CGFloat currentImageW=currentImage.size.width;
        CGFloat currentImageH=currentImage.size.height;
        
        if (currentImageW>SCREEN_WIDTH && currentImageH>videoH) {
            CGFloat scaleW=SCREEN_WIDTH/currentImageW;
            CGFloat scaleH=videoH/currentImageH;
            _selectedScale=MIN(scaleW, scaleH);
        }else if (currentImageW>SCREEN_WIDTH&&currentImageH<=videoH){
            _selectedScale=SCREEN_WIDTH/currentImageW;
        }else if (currentImageH>videoH&&currentImageW<SCREEN_WIDTH){
            _selectedScale=videoH/currentImageH;
        }else{
            _selectedScale=1;
        }
        CGFloat viewW=currentImageW*_selectedScale;
        CGFloat viewH=currentImageH*_selectedScale;
        //播放界面视图
        _videoView = [[UIImageView alloc]initWithFrame:CGRectMake((self.width-viewW)/2,(videoH-viewH)/2,viewW,viewH)];
        [_videoView setUserInteractionEnabled:YES];
    }
    return _videoView;
}
-(void)createVideoView{
    [self addSubview:self.videoView];
}


-(NSUInteger)degressFromVideoFileWithURL:(AVAsset *)asset
{
    NSUInteger degress = 0;
    
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    
    return degress;
}



#pragma mark 创建播放视图
- (void)createPlayer{
    
    
    // 对播放网址进行编码
    _playerURLStr = [self.playerURLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *playerURL = [NSURL URLWithString:self.playerURLStr];
    _playerURL=playerURL;
    // 创建视频项目对象
    self.playerItem = [[AVPlayerItem alloc] initWithURL:playerURL];
    // 创建播放器对象
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    _videoRotation = [self degressFromVideoFileWithURL:[AVAsset assetWithURL:playerURL]];
    
        // 创建播放器承载对象
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        // 设置承载对象尺寸
        self.playerLayer.frame =CGRectMake(0, 0, self.videoView.width, self.videoView.height);
        // 设置填充方式为填满
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self addSubview:self.videoView];
        [self.videoView.layer addSublayer:self.playerLayer];
        
        // 创建播放按钮
        self.playButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.playButtonImageView.center = CGPointMake(Width / 2, (Height-44) / 2);
        [self.playButtonImageView setImage:[UIImage imageNamed:@"qushuiyin_play"]];
        self.playButtonImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.playButtonImageView];
        // 隐藏
        [self.playButtonImageView setHidden:YES];
    
    // 创建底部的进度显示视图
    [self createBottomView];
    
    // 创建轻点手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlayerView:)];
    [self addGestureRecognizer:tap];
    self.isTap = NO;
    
    // 添加监听方式
    [self addNotificationCenters];
    
    // 设置播放进度
    [self addPlayProgress];
    
}
#pragma mark 创建底部的进度显示视图
- (void)createBottomView{
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Height - 44, Width, 44)];
    self.bottomView.backgroundColor = RGBColor(16, 16, 16);
    [self addSubview:self.bottomView];
    
    // 进度时间Label
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44/2-15/2, 40, 15)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor whiteColor];
    [self.timeLabel setTextAlignment:NSTextAlignmentCenter];
    self.timeLabel.text = @"00:00";
    [self.bottomView addSubview:self.timeLabel];
    // 总时间
    self.durationTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(Width - 50, 44/2-15/2, 40, 15)];
    [self.durationTimeLabel setTextAlignment:NSTextAlignmentCenter];
    self.durationTimeLabel.font = [UIFont systemFontOfSize:12];
    self.durationTimeLabel.textColor = [UIColor whiteColor];
    self.durationTimeLabel.text = @"00:00";
    [self.bottomView addSubview:self.durationTimeLabel];
    
    
    // 进度条
    self.progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 44/2-15/2-1, Width - 105, 15)];
    [self.bottomView addSubview:self.progressSlider];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateHighlighted];
    // 最初的颜色
    self.progressSlider.maximumTrackTintColor = [UIColor colorWithRed:73.0f/255.0f green:73.0f/255.0f blue:73.0f/255.0f alpha:1.0];
    // 划过之后的颜色
    self.progressSlider.minimumTrackTintColor = [UIColor whiteColor];
    
    // 添加响应事件
    [self.progressSlider addTarget:self action:@selector(sliderChange) forControlEvents:UIControlEventValueChanged];
    [self.progressSlider addTarget:self action:@selector(sliderEnd) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 进度条滑动的响应事件
- (void)sliderChange{
    // 暂停播放器
    [self playerPause];
    self.isPlay = NO;
    self.isTap = YES;
    // 获取当前时间
    double currentTime = self.durationTime * self.progressSlider.value;
    // 设置将要跳转的时间
    CMTime drage = CMTimeMake(currentTime, 1);
    // 对player进行设置
    [self.player seekToTime:drage completionHandler:^(BOOL finished) {
        
    }];
    
}

#pragma mark - 进度条滑动结束事件
-(void)sliderEnd{
    self.isPlay = YES;
    self.isTap = NO;
    // 启动播放器
    [self playerPlay];
    // 隐藏播放按钮
    [self.playButtonImageView setHidden:YES];
    
}



// 重新播放视频
- (void)rePlayVideo{
    // 设置Player的播放时间是0
    [self.player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        // 启动播放器
        [self playerPlay];
        // 隐藏播放按钮
        [self.playButtonImageView setHidden:YES];
    }];

}

#pragma mark 轻点播放视图
- (void)tapPlayerView:(UIGestureRecognizer *)tap{
    if(self.isTap == NO){
        // 暂停视频
        [self playerPause];
        // 显示播放按钮
        [self.playButtonImageView setHidden:NO];
        // 隐藏加载按钮
        [self stopIndicator];
        self.isTap = YES;
    }else{
        // 启动播放视频
        [self playerPlay];
        // 隐藏播放按钮
        [self.playButtonImageView setHidden:YES];
        // 如果还没有读取到视频的数据,启动加载按钮
        if(self.isPlay == 0){
            [self showIndicator];
            
        }
        self.isTap = NO;
    }
}
#pragma mark 添加监听方式,播放开始,播放结束,屏幕旋转
- (void)addNotificationCenters{
    // 初始化当前视频是否开始播放0表示第一次开始播放
    self.isPlay = 0;
    
    // 显示加载动画
    [self showIndicator];
    
    // 监听播放开始
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStart:) name:AVPlayerItemTimeJumpedNotification object:nil];
    
    // 监听播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    
    //监听挂起时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

-(void)EnterBackground{
    // 暂停视频
    [self playerPause];
    // 显示播放按钮
    [self.playButtonImageView setHidden:NO];
    // 隐藏加载按钮
    [self stopIndicator];
    self.isTap = YES;
}

// 移除监听
- (void)removeNotificationCenters{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 视频开始播放的时候触发的方法
- (void)movieStart:(NSNotification *)notification{
    if(self.isPlay == 0){
        [self stopIndicator];
    }
    // 改变判断量的值
    self.isPlay ++;
}

// 视频播放结束的时候触发的方法
- (void)movieEnd:(NSNotification *)notification{
    [self stopPlayer];
    [self.player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        if([_delegate respondsToSelector:@selector(playStatusEnd)]){
            [_delegate playStatusEnd];
        }
    }];
    
    NSLog(@"视频播放完毕!");
}
#pragma mark 设置播放进度
- (void)addPlayProgress{
    __weak NHPlayerView *weakself = self;
    // 设置为每一秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 50) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        // 视频的总时间
        CGFloat durationTime = CMTimeGetSeconds(weakself.playerItem.duration);
        
        // 当前时间
        CGFloat currentTime = CMTimeGetSeconds(weakself.playerItem.currentTime);
        
        // 给Label赋值
        weakself.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)currentTime / 60,(int)currentTime % 60];
        weakself.durationTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)durationTime / 60, (int)durationTime % 60];
        // 移动Slider
        weakself.progressSlider.value = currentTime / durationTime;
        
        // 保存总时长,用在手动快进的时候
        weakself.durationTime = durationTime;
        
    }];
}

-(void)playerReplace:(AVPlayerItem *)playerItem{
    self.playerItem = playerItem;
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    
}

#pragma mark 启动播放器
/**返回正在播放的状态*/
- (void)playerPlay{
    
    [self.player play];
    [self.playButtonImageView setHidden:YES];
    [self stopIndicator];
    self.isPlay= 0;
    self.isTap = YES;

    if(self.player != nil){
        if ([_delegate respondsToSelector:@selector(playStatusChangeisPlay:)]) {
            [_delegate playStatusChangeisPlay:YES];
        }
    }
}

#pragma mark 暂停播放器
/**返回暂停的播放状态*/
- (void)playerPause{
    
    [self.player pause];
    [self.playButtonImageView setHidden:NO];
    [self stopIndicator];
    self.isPlay= NO;
    self.isTap = YES;

    if(self.player != nil){
        if ([_delegate respondsToSelector:@selector(playStatusChangeisPlay:)]) {
            [_delegate playStatusChangeisPlay:NO];
        }
    }
}
-(void)stopPlayer{
    // 暂停视频
    if(self.player != nil){
        [self.player pause];
    }
    
}

#pragma mark 加载动画
// 显示加载动画
- (void)showIndicator{
    if(self.indicator == nil){
        self.indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.indicator.backgroundColor = [UIColor clearColor];
        self.indicator.center = CGPointMake(Width / 2, Height / 2);
        // 加载动画的样式
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:self.indicator];
    }
    [self.indicator startAnimating];
}

// 停止加载动画
- (void)stopIndicator{
    [self.indicator stopAnimating];
}

-(void)dealloc{
    [self removeNotificationCenters];
}


@end
