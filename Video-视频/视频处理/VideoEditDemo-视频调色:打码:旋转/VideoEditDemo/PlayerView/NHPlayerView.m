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



@end

@implementation NHPlayerView

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){

    }
    return self;
}

#pragma mark 设置PlayerURLStr
- (void)setPlayerURLStr:(NSString *)playerURLStr isEdit:(BOOL)isEdit{
    if(_playerURLStr != playerURLStr){
        _playerURLStr = playerURLStr;
    }
    // 创建播放器
    [self createPlayerIsEdit:isEdit];
    
    // 启动播放器
   // [self playerPlay];
}

-(UIImageView *)videoView{
    if (!_videoView) {
        //播放界面视图
        _videoView = [[UIImageView alloc]initWithFrame:_playerLayer.videoRect];
        [_videoView setUserInteractionEnabled:YES];
        [_videoView.layer setMasksToBounds:YES];
        [[self.subviews lastObject] addSubview:_videoView];
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


-(void)resetRotation{
    if (_videoRotation == 90) {
        [self.gpuImageView setInputRotation:kGPUImageRotateRight atIndex:0];
    }else if (_videoRotation == 0){
        
        [self.gpuImageView setInputRotation:kGPUImageNoRotation atIndex:0];
    }else if (_videoRotation == 180){
        [self.gpuImageView setInputRotation:kGPUImageRotate180 atIndex:0];
        
    }else if (_videoRotation == 270){
        
        [self.gpuImageView setInputRotation:kGPUImageRotateLeft atIndex:0];
    }
    
}




#pragma mark 创建播放视图
- (void)createPlayerIsEdit:(BOOL)isEdit{
    // 对播放网址进行编码
    _playerURLStr = [self.playerURLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *playerURL = [NSURL URLWithString:self.playerURLStr];
    // 创建视频项目对象
    self.playerItem = [[AVPlayerItem alloc] initWithURL:playerURL];
    // 创建播放器对象
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    _videoRotation = [self degressFromVideoFileWithURL:[AVAsset assetWithURL:playerURL]];
    
    if (isEdit) {
        self.gpuImageView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, Width , Height-49)];
        [self addSubview:self.gpuImageView];
        self.gpuImageMovie = [[GPUImageMovie alloc] initWithPlayerItem:self.playerItem];
        self.gpuImageMovie.runBenchmark = NO;
        [self resetRotation];
        
        
        // 创建播放按钮
        self.playButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.playButtonImageView.center = CGPointMake(Width / 2, (Height) / 2);
        [self.playButtonImageView setImage:[UIImage imageNamed:@"qushuiyin_play"]];
        self.playButtonImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.playButtonImageView];
        // 隐藏
        [self.playButtonImageView setHidden:YES];
    }else{
        // 创建播放器承载对象
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        // 设置承载对象尺寸
        //   self.playerLayer.frame = CGRectMake(5, 5, Width - 10, Height - 10);
        self.playerLayer.frame = CGRectMake(0, 0, Width , Height-49);
        // 设置填充方式为填满
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        
        
        [self.layer addSublayer:self.playerLayer];
        
        // 创建播放按钮
        self.playButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.playButtonImageView.center = CGPointMake(Width / 2, (Height-49) / 2);
        [self.playButtonImageView setImage:[UIImage imageNamed:@"qushuiyin_play"]];
        self.playButtonImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.playButtonImageView];
        // 隐藏
        [self.playButtonImageView setHidden:YES];
    }
    
    
    
    
    

    
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
    self.bottomView.backgroundColor = [UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:1.0];
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
        
        // 如果读取到了视频的数据,就显示下面的滑动条
//        if(self.isPlay != 0){
//            [UIView animateWithDuration:1 animations:^{
//
//                self.bottomView.alpha = 0.8;
//            }];
//        }
        self.isTap = YES;
    }
    else{
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
    // 下面这样写,不安全
//    self.isTap = !self.isTap;
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
    NSLog(@"EnterBackground");
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
    // 0 的时候表示当前视频第一次开始播放
    if(self.isPlay == 0){
        // 停止加载动画
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
- (void)playerPlay{
    if(self.player != nil){
        if ([_delegate respondsToSelector:@selector(playStatusChangeisPlay:)]) {
            [_delegate playStatusChangeisPlay:YES];
        }
        [self.player play];
    }
    else{
        NSLog(@"播放器为空,不能启动!");
    }
}

#pragma mark 暂停播放器
- (void)playerPause{
    if(self.player != nil){
        if ([_delegate respondsToSelector:@selector(playStatusChangeisPlay:)]) {
            [_delegate playStatusChangeisPlay:NO];
        }
        [self.player pause];
    }
    else{
        NSLog(@"播放器为空,不能暂停!");
    }
}



-(void)stopPlayer{
    // 暂停视频
    if(self.player != nil){
        [self.player pause];
    }
    else{
        NSLog(@"播放器为空,不能暂停!");
    }
    // 显示播放按钮
    [self.playButtonImageView setHidden:NO];
    // 隐藏加载按钮
    [self stopIndicator];
    self.isPlay= 0;
    self.isTap = YES;

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
    NSLog(@"playerView delloc");
}


@end
