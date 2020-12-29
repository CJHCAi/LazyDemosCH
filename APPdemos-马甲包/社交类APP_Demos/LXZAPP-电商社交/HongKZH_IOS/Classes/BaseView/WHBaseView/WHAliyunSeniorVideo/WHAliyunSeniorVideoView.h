//
//  WHAliyunSeniorVideoView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayerVideo.h>

@interface WHAliyunSeniorVideoView : UIView
@property(nonatomic, assign)HKPalyStaue staue;
@property (nonatomic, strong)UIView *playView;
@property (nonatomic, strong)AliyunVodPlayer *aliPlayer;
@property (nonatomic, copy)NSString *vid;
-(void)playWithVid:(NSString*)vid;
-(void)playWithVid:(NSString*)vid playView:(UIView*)view;
-(void)pause;
-(void)stop;
-(void)resume;
-(void)timerRun;
//播放准备完成时触发
-(void) AliyunVodPlayerEventPrepareDone;

//暂停后恢复播放时触发
-(void) AliyunVodPlayerEventPlay;

//播放视频首帧显示出来时触发
-(void) AliyunVodPlayerEventFirstFrame;

//视频暂停时触发
-(void) AliyunVodPlayerEventPause;

//主动使用stop接口时触发
-(void) AliyunVodPlayerEventStop;

//视频正常播放完成时触发
-(void) AliyunVodPlayerEventFinish;

//视频开始载入时触发
-(void) AliyunVodPlayerEventBeginLoading;

//视频加载完成时触发
-(void) AliyunVodPlayerEventEndLoading;

//视频Seek完成时触发
-(void) AliyunVodPlayerEventSeekDone;


-(NSString*)getTime:(NSInteger)time;

-(void)reset;
-(void)releasePlayer;
-(void)viewTransparentView;
@end
