//
//  WHAliyunSeniorVideoView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "WHAliyunSeniorVideoView.h"
#import "HKBaseViewModel.h"
#import "HKUploadRespone.h"
#import "UIView+Extend.h"
#import "HKBaseViewModel.h"
@interface WHAliyunSeniorVideoView()<AliyunVodPlayerDelegate>

@property (nonatomic, strong)NSTimer *timer;
@end

@implementation WHAliyunSeniorVideoView
- (instancetype)init
{
    self = [super init];
    if (self) {
      [self initAliyunPlay];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initAliyunPlay];
    }
    return self;
}
-(void)initAliyunPlay{
//    [self.aliPlayer.playerView transparentView];
}
- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event{
    //这里监控播放事件回调
    //主要事件如下：
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:
            //播放准备完成时触发
            [self AliyunVodPlayerEventPrepareDone];
            break;
        case AliyunVodPlayerEventPlay:
            //暂停后恢复播放时触发
            [self AliyunVodPlayerEventPlay];
            break;
        case AliyunVodPlayerEventFirstFrame:
            //播放视频首帧显示出来时触发
            [self AliyunVodPlayerEventFirstFrame];
            break;
        case AliyunVodPlayerEventPause:
            //视频暂停时触发
            [self AliyunVodPlayerEventPause];
            break;
        case AliyunVodPlayerEventStop:
            [self AliyunVodPlayerEventStop];
            //主动使用stop接口时触发
            break;
        case AliyunVodPlayerEventFinish:
            //视频正常播放完成时触发
            [self AliyunVodPlayerEventFinish];
            break;
        case AliyunVodPlayerEventBeginLoading:
            //视频开始载入时触发
            [self AliyunVodPlayerEventBeginLoading];
            break;
        case AliyunVodPlayerEventEndLoading:
            //视频加载完成时触发
            [self AliyunVodPlayerEventEndLoading];
            break;
        case AliyunVodPlayerEventSeekDone:
            //视频Seek完成时触发
            [self AliyunVodPlayerEventSeekDone];
            break;
        default:
            break;
    }
}

//播放准备完成时触发
-(void) AliyunVodPlayerEventPrepareDone{
    if (self.staue == HKPalyStaue_play||self.staue == HKPalyStaue_resume) {
        
        [self.aliPlayer start];
        [self.aliPlayer seekToTime:0];
        [self startTimer];
    }
}

//暂停后恢复播放时触发
-(void) AliyunVodPlayerEventPlay{
    
}

//播放视频首帧显示出来时触发
-(void) AliyunVodPlayerEventFirstFrame{
    
}

//视频暂停时触发
-(void) AliyunVodPlayerEventPause{
    
}

//主动使用stop接口时触发
-(void) AliyunVodPlayerEventStop{
    
}

//视频正常播放完成时触发
-(void) AliyunVodPlayerEventFinish;
{
    [self timerRun];
    [self closeTimer];
    
    [self stop];
}

//视频开始载入时触发
-(void) AliyunVodPlayerEventBeginLoading{
    
}

//视频加载完成时触发
-(void) AliyunVodPlayerEventEndLoading{
    
}

//视频Seek完成时触发
-(void) AliyunVodPlayerEventSeekDone{
    
}
- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(AliyunPlayerVideoErrorModel *)errorModel{
    //播放出错时触发，通过errorModel可以查看错误码、错误信息、视频ID、视频地址和requestId。
    if (errorModel.errorCode == 4002) {
        
    }
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


-(void)prepareSuc:(void(^)(BOOL suc))suc{
    [HKBaseViewModel initUploadSuccess:^(BOOL isSave, HKUploadRespone *respone) {
        if (respone.responeSuc) {
            [self.aliPlayer prepareWithVid:self.vid.length>0?self.vid: @"7e76bf499a7247a78be1965b61a2f3e5" accessKeyId:respone.data.accessKeyId accessKeySecret:respone.data.accessKeySecret securityToken:respone.data.securityToken];
            suc(YES);
        }else{
            suc(NO);
        }
        
    }];
}
-(void)playWithVid:(NSString*)vid{
    if(self.staue == HKPalyStaue_pause){
        [self pause];
    }else{
        self.staue = HKPalyStaue_play;
        self.vid = vid;
    }
    
}
-(void)playWithVid:(NSString*)vid playView:(UIView*)view{
    [self stop];
    [self removeFromSuperview];
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    self.staue = HKPalyStaue_play;
    self.vid = vid;
}
-(void)resume{
    [self startTimer];
    self.staue = HKPalyStaue_resume;
    [self.aliPlayer resume];
}

-(void)pause{
    [self closeTimer];
    self.staue = HKPalyStaue_pause;
    [self.aliPlayer pause];
}
-(void)stop{
    [self closeTimer];
    self.staue = HKPalyStaue_stop;
    [self.aliPlayer stop];
}
-(void)reset{
    [self closeTimer];
    self.staue = HKPalyStaue_close;
    [self.aliPlayer reset];
}
-(void)setVid:(NSString *)vid{
    _vid = vid;
    [self prepareSuc:^(BOOL suc) {
        
    }];
}
-(void)releasePlayer{
    [self.aliPlayer releasePlayer];
}
-(void)setPlayView:(UIView *)playView{
    _playView = playView;
    [self.aliPlayer.playerView removeFromSuperview];
    if (playView) {
        [playView addSubview:self.aliPlayer.playerView];
        [self.aliPlayer.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(playView);
        }];
    }
    [self viewTransparentView];
    
}
-(void)viewTransparentView{
   [self.aliPlayer.playerView transparentView];
}
-(void)timerRun{}
-(void)closeTimer{
    [self.timer invalidate];
    self.timer = nil;
}
-(void)startTimer{
    [self closeTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(AliyunVodPlayer *)aliPlayer{
    if (!_aliPlayer) {
        AliyunVodPlayer *aliPlayer = [[AliyunVodPlayer alloc] init];
        _aliPlayer = aliPlayer;
        [_aliPlayer setDisplayMode:AliyunVodPlayerDisplayModeFit];

        _aliPlayer.delegate = self;
    }
    return _aliPlayer;
}
-(void)dealloc{
    if (self.staue == HKPalyStaue_play||self.staue == HKPalyStaue_resume) {
         [self releasePlayer];
    }
   
}
-(NSString*)getTime:(NSInteger)time{
    NSString *timeStr ;
    if (time > 60) {
        if (time < 3600) {
            NSString*m ;
            if (time/60>9) {
                m = [NSString stringWithFormat:@"%ld",time/60];
            }else{
                m = [NSString stringWithFormat:@"0%ld",time/60];
            }
            NSString*s;
            if (time%60>9) {
                s = [NSString stringWithFormat:@"%ld",time%60];
            }else{
                s = [NSString stringWithFormat:@"0%ld",time%60];
            }
            timeStr = [NSString stringWithFormat:@"%@:%@",m,s];
        }else{
            NSString*h;
            if (time/3600>9) {
                h  =   [NSString stringWithFormat:@"%ld",time/3600];
            }else{
                h  =   [NSString stringWithFormat:@"%0ld",time/3600];
            }
            time =   time - 3600;
            NSString*m ;
            if (time/60>9) {
                m = [NSString stringWithFormat:@"%ld",time/60];
            }else{
                m = [NSString stringWithFormat:@"0%ld",time/60];
            }
            NSString*s;
            if (time%60>9) {
                s = [NSString stringWithFormat:@"%ld",time%60];
            }else{
                s = [NSString stringWithFormat:@"0%ld",time%60];
            }
            timeStr = [NSString stringWithFormat:@"%@:%@:%@",h,m,s];
            
        }
    }else{
        timeStr = [NSString stringWithFormat:@"00:%ld",time];
    }
    return timeStr;
}

@end
