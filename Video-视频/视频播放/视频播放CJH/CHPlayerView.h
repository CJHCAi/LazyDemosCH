//
//  NHPlayerView.h
//  VideoEditDemo
//
//  Created by JSB-hejiamin on 2018/2/24.
//  Copyright © 2018年 JSB-hejiamin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol CHPlayerViewDelegete <NSObject>
@optional
-(void)CHPlayerView_playStatusChangeIsPlay:(BOOL)isPlay;
-(void)CHPlayerView_playStatusEnd;
-(void)CHPlayerView_playerPause;
-(void)CHPlayerView_playerPlay;

@end

@interface CHPlayerView : UIView

@property(nonatomic, retain)AVPlayer *player;
@property(nonatomic, strong)AVPlayerItem *playerItem;
@property(nonatomic, retain)AVPlayerLayer *playerLayer;
//layer浮层
@property (nonatomic,strong)UIImageView * CoverImgV;
@property(nonatomic, retain)UIImageView *playImageView;
@property(nonatomic,assign)CGFloat selectedScale;


@property (weak,nonatomic)id<CHPlayerViewDelegete>delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setPlayerURLStr:(NSURL *)videoUrl;
- (void)playerPlay;
- (void)playerPause;
-(void)rePlayVideo;
-(void)destroyPlayer;
/**创建layer浮层*/
-(void)createCoverImgV;

@end
