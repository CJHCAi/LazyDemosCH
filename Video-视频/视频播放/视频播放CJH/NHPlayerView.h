//
//  NHPlayerView.h
//  VideoEditDemo
//
//  Created by JSB-hejiamin on 2018/2/24.
//  Copyright © 2018年 JSB-hejiamin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol NHPlayerViewDelegete <NSObject>
@optional
-(void)playStatusChangeisPlay:(BOOL)isPlay;
-(void)playStatusEnd;

@end

@interface NHPlayerView : UIView
@property(nonatomic, retain)AVPlayer *player;
@property(nonatomic, retain)NSString *playerURLStr;
@property(nonatomic, strong)AVPlayerItem *playerItem;
@property(nonatomic, retain)AVPlayerLayer *playerLayer;
@property (nonatomic,strong)UIImageView *videoView;
@property(assign,nonatomic)NSInteger videoRotation;
@property(nonatomic,assign)CGFloat selectedScale;

@property (weak,nonatomic)id<NHPlayerViewDelegete>delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setPlayerURLStr:(NSString *)playerURLStr;
-(void)createVideoView;
- (void)playerPlay;
- (void)playerPause;
-(void)stopPlayer;
-(void)playerReplace:(AVPlayerItem *)playerItem;


@end
