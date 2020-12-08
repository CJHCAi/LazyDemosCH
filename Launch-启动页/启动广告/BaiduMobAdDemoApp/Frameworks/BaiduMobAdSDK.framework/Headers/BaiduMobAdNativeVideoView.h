//
//
//  Created by lishan04 on 15-11-1.
//  Copyright (c) 2015 lishan04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMobAdCommonConfig.h"
#import "BaiduMobAdNativeVideoBaseView.h"

@class BaiduMobAdNativeAdObject;
@interface BaiduMobAdNativeVideoView : BaiduMobAdNativeVideoBaseView

@property (nonatomic, retain)   UIButton *btnLP;//点击查看详情按钮
/* 视频是否自动播放
 * 默认自动播放，当视频展现50%时播放
 * 如果非自动播放，则点击大图时开始播放
 */
@property (nonatomic)   BOOL  isAutoPlay;

// 初始化方法，需要传入广告返回的BaiduMobAdNativeAdObject
- (instancetype)initWithFrame:(CGRect)frame andObject:(BaiduMobAdNativeAdObject *)object;

- (void)play;
- (void)pause;
- (void)stop;


#warning 重要，一定要向BaiduMobAdNativeAdObject发送视频状态事件和当前视频播放的位置，只有在第一次播放才需要发送
- (void)sendVideoEvent:(BaiduAdNativeVideoEvent)event currentTime:(NSTimeInterval) currentTime;

@end
