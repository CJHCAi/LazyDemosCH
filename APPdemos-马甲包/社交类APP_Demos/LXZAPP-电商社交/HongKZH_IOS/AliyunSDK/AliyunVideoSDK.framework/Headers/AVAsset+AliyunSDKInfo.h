//
//  AVAsset+AliyunSDKInfo.h
//  QUSDK
//
//  Created by Worthy on 2017/9/29.
//  Copyright © 2017年 Alibaba Group Holding Limited. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAsset (AliyunSDKInfo)
- (CGSize)aliyunNaturalSize;
- (CGFloat)aliyunFrameRate;
- (CGFloat)aliyunBitrate;
- (CGFloat)aliyunDuration;
- (CGFloat)aliyunVideoDuration;
- (CGFloat)aliyunAudioDuration;
- (CGFloat)aliyunEstimatedKeyframeInterval;


@end
