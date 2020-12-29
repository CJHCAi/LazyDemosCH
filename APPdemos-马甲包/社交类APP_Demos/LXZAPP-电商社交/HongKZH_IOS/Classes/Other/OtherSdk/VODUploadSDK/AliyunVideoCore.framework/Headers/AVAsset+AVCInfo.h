//
//  AVAsset+avcSDKInfo.h
//  QUSDK
//
//  Created by Worthy on 2017/9/29.
//  Copyright © 2017年 Alibaba Group Holding Limited. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAsset (AVCInfo)

- (CGSize)avcNaturalSize;

- (CGFloat)avcFrameRate;

- (CGFloat)avcBitrate;

- (CGFloat)avcDuration;

- (CGFloat)avcVideoDuration;

- (CGFloat)avcAudioDuration;

@end
