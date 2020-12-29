//
//  HKVideoPlayView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKVideoPlayView.h"
#import "HKVideoPlayCoverView.h"
#import "HKCoverImagePickView.h"

@interface HKVideoPlayView () <AliyunVodPlayerDelegate,HKVideoPlayCoverViewDelegate>

@property (nonatomic, strong) AliyunVodPlayer *aliPlayer;
@property (nonatomic, strong) HKVideoPlayCoverView *coverView;
@property (nonatomic,strong) UIButton *popButton;

@property (nonatomic, strong) NSMutableArray *coverImages;

@property (nonatomic, strong) HKCoverImagePickView *coverImagePickView; //封面选择视图

@property (nonatomic, weak) NSTimer *timer;                           //计时器

@end

@implementation HKVideoPlayView

- (void)dealloc {
    [self releasePlayerAndTimer];
}

- (void)releasePlayerAndTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (_aliPlayer) {
        [_aliPlayer releasePlayer];
        _aliPlayer = nil;
    }
}

- (void)resume {
    [self.aliPlayer resume];
}

- (void)pause {
    [self.aliPlayer pause];
}

- (AliyunVodPlayerState)playerState {
    return self.aliPlayer.playerState;
}

#pragma mark 懒加载
- (AliyunVodPlayer *)aliPlayer {
    if(!_aliPlayer) {
        _aliPlayer = [[AliyunVodPlayer alloc] init];
        _aliPlayer.playerView.frame = [UIScreen mainScreen].bounds;
        _aliPlayer.autoPlay = YES;
        _aliPlayer.circlePlay = YES;
        _aliPlayer.displayMode = AliyunVodPlayerDisplayModeFitWithCropping;
        
    }
    return _aliPlayer;
}

- (HKVideoPlayCoverView *)coverView {
    if (!_coverView) {
        _coverView = [[HKVideoPlayCoverView alloc] init];
        _coverView.delegate = self;
    }
    return _coverView;
}

- (HKCoverImagePickView *)coverImagePickView {
    if (!_coverImagePickView) {
        _coverImagePickView = [[HKCoverImagePickView alloc] init];
        @weakify(self);
        //取消
        _coverImagePickView.cancelBlock = ^{
            @strongify(self);
            if (self.aliPlayer.playerState == AliyunVodPlayerStatePause) {
                [self.aliPlayer resume];
            }
            [UIView animateWithDuration:0.2f animations:^{
                [self.coverImages removeAllObjects];
                self.coverImagePickView.transform = CGAffineTransformIdentity;
                self.coverView.transform = CGAffineTransformIdentity;
                [self.coverImagePickView reSetView];
            }];
        };
        //截屏
        _coverImagePickView.snapshotBlock = ^{
             @strongify(self);
            if ([self.coverImages count] > 10) {
                [SVProgressHUD showInfoWithStatus:@"已经够多的了"];
            } else {
                [self setCoverImageWithSnapshot];
            }
        };
        
        //确认
        _coverImagePickView.confirmblock = ^(UIImage *image) {
           @strongify(self);
            if (self.aliPlayer.playerState == AliyunVodPlayerStatePause) {
                [self.aliPlayer resume];
            }
            self.coverImage = image;
            [self.coverView setCoverImage:self.coverImage];
            [UIView animateWithDuration:0.2f animations:^{
                [self.coverImages removeAllObjects];
                self.coverImagePickView.transform = CGAffineTransformIdentity;
                self.coverView.transform = CGAffineTransformIdentity;
            }];
            [self.coverImagePickView reSetView];
        };
        
        //cell选中暂停
        _coverImagePickView.cellClickBlock = ^{
             @strongify(self);
            if (self.aliPlayer.playerState == AliyunVodPlayerStatePlay) {
                [self.aliPlayer pause];
            }
        };
        
        _coverImagePickView.backgroundColor = [UIColor clearColor];
    }
    return _coverImagePickView;
}

- (UIButton *)popButton {
    if (!_popButton) {
        _popButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                  frame:CGRectZero
                                                  taget:self
                                                 action:@selector(popButtonClick)
                                                supperView:self];
 
        
        UIImage *image = [UIImage imageNamed:@"back" inBundle:[NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"QPSDK.bundle"]] compatibleWithTraitCollection:nil];
        
        [_popButton setImage:image forState:UIControlStateNormal];
    }
    return _popButton;
}

- (void)popButtonClick {
    [self.timer invalidate];
    self.timer = nil;
    if ([self.delegate respondsToSelector:@selector(back)]) {
        [self.delegate back];
    }
    
}

- (NSMutableArray *)coverImages {
    if (!_coverImages) {
        _coverImages = [NSMutableArray array];
    }
    return _coverImages;
}

-(void)setCoverImage:(UIImage *)coverImage {
    _coverImage = coverImage;
    HKReleaseVideoParam *releaseParm = [HKReleaseVideoParam shareInstance];
    //保存封面
    releaseParm.coverImgSrc = coverImage;
    [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%ld",(NSInteger)(coverImage.size.width)] key:@"coverImgWidth"];
    [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%ld",(NSInteger)(coverImage.size.height)] key:@"coverImgHeight"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // TODO:init
         [self setUpUI];
    }
    return self;
}
- (instancetype)init {
    if (self = [super init]) {
        [self setUpUI];
    }
    return  self;
}

-(void) setUpUI {
    
    self.aliPlayer.delegate = self;
    [self addSubview:self.aliPlayer.playerView];
    
    [self addSubview:self.coverView];
    
    [self addSubview:self.coverImagePickView];
}

- (void)prepareWithURL:(NSURL *)url {
    self.url = url;
    //解析视频
    [self.aliPlayer prepareWithURL:url];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.aliPlayer.playerView.frame = self.bounds;
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_bottom).offset(-150);
        make.bottom.equalTo(self);
    }];
    
    [self.popButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(20);
        make.width.height.mas_equalTo(25);
    }];
    
    [self.coverImagePickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
        make.left.right.height.equalTo(self);
    }];
}

- (void)setCoverImageWithSnapshot {
    [self.coverImages addObject:[self.aliPlayer snapshot]];
    self.coverImagePickView.images = self.coverImages;
}

#pragma mark AliyunVodPlayerDelegate

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event{
    //这里监控播放事件回调
    //主要事件如下：
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:
            //播放准备完成时触发
            break;
        case AliyunVodPlayerEventPlay:
            //暂停后恢复播放时触发
            break;
        case AliyunVodPlayerEventFirstFrame:
        {
            //sdk内部无计时器，需要获取currenttime；注意 NSRunLoopCommonModes
            NSTimer * tempTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:tempTimer forMode:NSRunLoopCommonModes];
            self.timer = tempTimer;
            
            //播放视频首帧显示出来时触发
            self.coverImage = [self.aliPlayer snapshot];
            [self.coverView setCoverImage:self.coverImage];
            [self setCoverImageWithSnapshot];
            
            //保存视频时长
            [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",self.aliPlayer.duration] key:@"vedioLength"];
        }
            break;
        case AliyunVodPlayerEventPause:
            //视频暂停时触发
            break;
        case AliyunVodPlayerEventStop:
            //主动使用stop接口时触发
            break;
        case AliyunVodPlayerEventFinish:
            //视频正常播放完成时触发
            break;
        case AliyunVodPlayerEventBeginLoading:
            //视频开始载入时触发
            break;
        case AliyunVodPlayerEventEndLoading:
            //视频加载完成时触发
            break;
        case AliyunVodPlayerEventSeekDone:
            //视频Seek完成时触发
            break;
        default:
            break;
    }
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(AliyunPlayerVideoErrorModel *)errorModel{
    //播放出错时触发，通过errorModel可以查看错误码、错误信息、视频ID、视频地址和requestId。
}

- (void)vodPlayer:(AliyunVodPlayer*)vodPlayer willSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition{
    //将要切换清晰度时触发
}
- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer didSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition{
    //清晰度切换完成后触发
}
- (void)vodPlayer:(AliyunVodPlayer*)vodPlayer failSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition{
    //清晰度切换失败触发
}
- (void)onCircleStartWithVodPlayer:(AliyunVodPlayer*)vodPlayer{
    //开启循环播放功能，开始循环播放时接收此事件。
}
- (void)onTimeExpiredErrorWithVodPlayer:(AliyunVodPlayer *)vodPlayer{
    //播放器鉴权数据过期回调，出现过期可重新prepare新的地址或进行UI上的错误提醒。
}
/*
 *功能：播放过程中鉴权即将过期时提供的回调消息（过期前一分钟回调）
 *参数：videoid：过期时播放的videoId
 *参数：quality：过期时播放的清晰度，playauth播放方式和STS播放方式有效。
 *参数：videoDefinition：过期时播放的清晰度，MPS播放方式时有效。
 *备注：使用方法参考高级播放器-点播。
 */
- (void)vodPlayerPlaybackAddressExpiredWithVideoId:(NSString *)videoId quality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition{
    //鉴权有效期为2小时，在这个回调里面可以提前请求新的鉴权，stop上一次播放，prepare新的地址，seek到当前位置
}

#pragma mark - timerRun
- (void)timerRun{
    if (self.aliPlayer) {
        NSTimeInterval currentTime = self.aliPlayer.currentTime;
        DLog(@"currentTime:%f",currentTime);
        NSTimeInterval durationTime = self.aliPlayer.duration;
        
         AliyunVodPlayerState state = (AliyunVodPlayerState)self.aliPlayer.playerState;
        
        if (state == AliyunVodPlayerStatePlay || state == AliyunVodPlayerStatePause) {
            [self.coverView updateProgressWithCurrentTime:currentTime durationTime:durationTime];
        }
    }
}


#pragma mark HKVideoPlayCoverViewDelegate
//点击完成
- (void) HKVideoPlayCoverView:(HKVideoPlayCoverView *)view finishButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(finishButtonClickBlock)]) {
        [self.delegate finishButtonClickBlock];
    }
}

//播放，暂停
-(void) HKVideoPlayCoverView:(HKVideoPlayCoverView *)view playButtonClick:(UIButton *)button {
    if (button.selected) {
        [self.aliPlayer pause];
    } else {
        [self.aliPlayer resume];
    }
    DLog(@"%f",self.aliPlayer.currentTime);
}

//点击了封面
- (void) HKVideoPlayCoverView:(HKVideoPlayCoverView *)view coverImageViewClick:(UIButton *)button {
    if ([self.coverImages count] == 0) {
        [self.coverImages addObject:self.coverImage];
    }
    self.coverImagePickView.images = self.coverImages;
    //告知需要更改约束
    [UIView animateWithDuration:0.2 animations:^{
        self.coverImagePickView.transform = CGAffineTransformTranslate(self.coverImagePickView.transform, 0, -self.bounds.size.height);
        self.coverView.transform = CGAffineTransformMakeTranslation(0, -70);
    }];
}

//标签
- (void) HKVideoPlayCoverView:(HKVideoPlayCoverView *)view tagButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(tagButtonClickBlock)]) {
        [self.delegate tagButtonClickBlock];
    }
}

//进度条
- (void)HKVideoPlayCoverView:(HKVideoPlayCoverView *)view dragProgressSliderValue:(float)value event:(UIControlEvents)event {
    switch (event) {
        case UIControlEventTouchDown:
        {
            
        }
            break;
        case UIControlEventValueChanged:
        {
            
        }
            break;
        case UIControlEventTouchUpInside:
        {
            [self.aliPlayer seekToTime:value*self.aliPlayer.duration];
            AliyunVodPlayerState state = self.aliPlayer.playerState;
            if (state == AliyunVodPlayerStatePause) {
                [self.aliPlayer resume];
            }
        }
            break;
        case UIControlEventTouchUpOutside:{
            [self.aliPlayer seekToTime:value*self.aliPlayer.duration];
            AliyunVodPlayerState state = self.aliPlayer.playerState;
            if (state == AliyunVodPlayerStatePause) {
                [self.aliPlayer resume];
            }
        }
            break;
            //点击事件
        case UIControlEventTouchDownRepeat:{
            [self.aliPlayer seekToTime:value*self.aliPlayer.duration];
        }
            break;
            
        default:
            
            break;
    }
}


@end
