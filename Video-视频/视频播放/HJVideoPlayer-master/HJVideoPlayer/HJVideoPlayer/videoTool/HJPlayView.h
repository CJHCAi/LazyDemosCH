//
//  HJPlayView.h
//  HJVideoPlayer
//
//  Created by 黄静静 on 2017/7/19.
//  Copyright © 2017年 HJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HJVideoPlayer.h"
#import "HJPlayerMaskView.h"



typedef NS_ENUM(NSInteger, HJPlayViewType) {
    HJPlayViewTypeDefault,    //
    HJPlayViewTypeForPlay,    //  全屏播放
    HJPlayViewTypeForScan,    //  列表页播放
};

@protocol HJPlayViewDelegate <NSObject>
@optional
- (void)closeVideo;
@end

@interface HJPlayView : UIView
@property (nonatomic, weak) id<HJPlayViewDelegate>delegate;
@property (nonatomic, strong) NSURL *videoUrl; //视频连接
@property (nonatomic, strong) NSURL *coverUrl; //封面图片
@property (nonatomic, strong) HJVideoPlayer *videoPlayer;
@property (nonatomic, strong) HJPlayerMaskView *maskView;

+ (HJPlayView *)playerViewWithFrame:(CGRect)frame withPlayType:(HJPlayViewType)playViewType;


@end
