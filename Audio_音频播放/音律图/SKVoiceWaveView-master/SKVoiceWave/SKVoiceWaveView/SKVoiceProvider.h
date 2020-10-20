//
//  SKVoiceProvider.h
//  SKVoiceWave
//
//  Created by ac-hu on 2018/10/24.
//  Copyright © 2018年 SK-HU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^SKVoiceDataBlock)(NSData *data);

@interface SKVoiceProvider : NSObject

+(void)loadAudioSamplesFormAsset:(AVAsset *)asset completionBlock:(SKVoiceDataBlock)block;

@end
