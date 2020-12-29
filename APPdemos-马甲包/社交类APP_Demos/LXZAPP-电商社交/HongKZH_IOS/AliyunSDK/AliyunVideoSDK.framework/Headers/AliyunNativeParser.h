//
//  AliyunNativeParser.h
//  QUSDK
//
//  Created by Worthy on 2017/6/29.
//  Copyright © 2017年 Alibaba Group Holding Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALIYUN_VIDEO_STREAM_DIC_KEY_START                       0
#define ALIYUN_VIDEO_STREAM_INDEX                               (ALIYUN_VIDEO_STREAM_DIC_KEY_START)
#define ALIYUN_VIDEO_CODEC                                      (ALIYUN_VIDEO_STREAM_DIC_KEY_START + 1)
#define ALIYUN_VIDEO_START_TIME                                 (ALIYUN_VIDEO_STREAM_DIC_KEY_START + 2)
#define ALIYUN_VIDEO_DURATION                                   (ALIYUN_VIDEO_STREAM_DIC_KEY_START + 3)
#define ALIYUN_VIDEO_FRAME_COUNT                                (ALIYUN_VIDEO_STREAM_DIC_KEY_START + 4)
#define ALIYUN_VIDEO_BIT_RATE                                   (ALIYUN_VIDEO_STREAM_DIC_KEY_START + 5)
#define ALIYUN_VIDEO_WIDTH                                      (ALIYUN_VIDEO_STREAM_DIC_KEY_START + 6)
#define ALIYUN_VIDEO_HEIGHT                                     (ALIYUN_VIDEO_STREAM_DIC_KEY_START + 7)
#define ALIYUN_VIDEO_CODEC_WIDTH                                (ALIYUN_VIDEO_STREAM_DIC_KEY_START + 8)
#define ALIYUN_VIDEO_CODEC_HEIGHT                               (ALIYUN_VIDEO_STREAM_DIC_KEY_START + 9)
#define ALIYUN_VIDEO_FORMAT                                     (ALIYUN_VIDEO_STREAM_DIC_KEY_START + 10)
#define ALIYUN_VIDEO_GOP                                        (ALIYUN_VIDEO_STREAM_DIC_KEY_START + 11)
#define ALIYUN_VIDEO_MAX_BFRAME                                 (ALIYUN_VIDEO_STREAM_DIC_KEY_START + 12)
#define ALIYUN_VIDEO_FPS                                        (ALIYUN_VIDEO_STREAM_DIC_KEY_START+ 13) //
#define ALIYUN_VIDEO_ROTATION                                   (ALIYUN_VIDEO_STREAM_DIC_KEY_START+ 14) //

#define ALIYUN_AUDIO_STREAM_DIC_KEY_START                       15
#define ALIYUN_AUDIO_STREAM_INDEX                               (ALIYUN_AUDIO_STREAM_DIC_KEY_START + 0)
#define ALIYUN_AUDIO_CODEC                                      (ALIYUN_AUDIO_STREAM_DIC_KEY_START + 1)
#define ALIYUN_AUDIO_START_TIME                                 (ALIYUN_AUDIO_STREAM_DIC_KEY_START + 2)
#define ALIYUN_AUDIO_DURATION                                   (ALIYUN_AUDIO_STREAM_DIC_KEY_START + 3)
#define ALIYUN_AUDIO_FRAME_COUNT                                (ALIYUN_AUDIO_STREAM_DIC_KEY_START + 4)
#define ALIYUN_AUDIO_BIT_RATE                                   (ALIYUN_AUDIO_STREAM_DIC_KEY_START + 5)
#define ALIYUN_AUDIO_CHANNELS                                   (ALIYUN_AUDIO_STREAM_DIC_KEY_START + 6)
#define ALIYUN_AUDIO_SAMPLE_RATE                                (ALIYUN_AUDIO_STREAM_DIC_KEY_START + 7)
#define ALIYUN_AUDIO_FORAMT                                     (ALIYUN_AUDIO_STREAM_DIC_KEY_START + 8)
#define ALIYUN_AUDIO_FRAME_SAMPLES                              (ALIYUN_AUDIO_STREAM_DIC_KEY_START + 9) //PER CHANNEL

#define ALIYUN_FILE_DIC_KEY_START                               25
#define ALIYUN_FILE_NAME                                        (ALIYUN_FILE_DIC_KEY_START + 0)
#define ALIYUN_FILE_FORMAT                                      (ALIYUN_FILE_DIC_KEY_START + 1)
#define ALIYUN_FILE_START_TIME                                  (ALIYUN_FILE_DIC_KEY_START + 2)
#define ALIYUN_FILE_DURATION                                    (ALIYUN_FILE_DIC_KEY_START + 3)
#define ALIYUN_FILE_BIT_RATE                                    (ALIYUN_FILE_DIC_KEY_START + 4)
#define DIC_KEY_END                                             30



@interface AliyunNativeParser : NSObject
-(instancetype)initWithPath:(NSString *)path;
-(NSString *)getValueForKey:(NSInteger)key;
@end
