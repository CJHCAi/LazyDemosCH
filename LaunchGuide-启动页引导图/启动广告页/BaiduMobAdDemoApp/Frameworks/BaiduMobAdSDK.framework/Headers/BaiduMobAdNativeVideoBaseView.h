//
//  BaiduMobAdNativeVideoBaseView.h
//  BaiduMobAdNativeSDKSample
//
//  Created by lishan04 on 15/11/16.
//  Copyright © 2015年 lishan04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMobAdCommonConfig.h"

//自定义视频播放器需要实现的接口
@interface BaiduMobAdNativeVideoBaseView : UIView

- (void)play;
- (void)pause;
- (void)stop;

#warning 重要，一定要向BaiduMobAdNativeAdObject发送视频状态事件和当前视频播放的位置，只有在第一次播放才需要发送
- (void)sendVideoEvent:(BaiduAdNativeVideoEvent)event currentTime:(NSTimeInterval) currentTime;

@end