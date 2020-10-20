//
//  PlayerView.h
//  仿抖音
//
//  Created by ireliad on 2018/3/19.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayerView;

typedef NS_ENUM(NSUInteger, PlayerLoadStatus) {
    PlayerLoadStatusError, //item错误
    PlayerLoadStatusAlready, //准备好了
    PlayerLoadStatusUnknown, //未知错误
};

@protocol PlayerViewDelegate <NSObject>

//当视频加载status状态发生改变时回调
-(void)playerView:(PlayerView*)playerView loadStatus:(PlayerLoadStatus)loadStatus;
//缓存回调
-(void)playerView:(PlayerView*)playerView currentTime:(NSTimeInterval)currentTime;
//播放完成
-(void)playerViewDidFinish:(PlayerView*)playerView;
@end

@interface PlayerView : UIView
@property(nonatomic,weak)id<PlayerViewDelegate> delegate;
@property(nonatomic,strong)NSString *url;
-(instancetype)initWithUrl:(NSString*)url;

-(void)play;
-(void)pause;

-(void)refreshPlay;
@end
