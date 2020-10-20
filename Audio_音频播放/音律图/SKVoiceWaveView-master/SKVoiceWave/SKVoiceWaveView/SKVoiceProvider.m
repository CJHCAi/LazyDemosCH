//
//  SKVoiceProvider.m
//  SKVoiceWave
//
//  Created by ac-hu on 2018/10/24.
//  Copyright © 2018年 SK-HU. All rights reserved.
//

#import "SKVoiceProvider.h"

@implementation SKVoiceProvider
+(void)loadAudioSamplesFormAsset:(AVAsset *)asset completionBlock:(SKVoiceDataBlock)block{
    NSString *tracks = @"tracks";
    [asset loadValuesAsynchronouslyForKeys:@[tracks] completionHandler:^{
        int status = [asset statusOfValueForKey:tracks error:nil];
        NSData *sampleData;
        if (status == AVKeyValueStatusLoaded) {
            sampleData = [self readAudioSamplesFromAVsset:asset];
            if (sampleData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(sampleData);
                });
            }else{
                block(nil);
                //            读取音频数据失败
            }
        }
    }];
}

+(NSData *)readAudioSamplesFromAVsset:(AVAsset *)asset{
    NSError *error;
    AVAssetReader *assetReader = [[AVAssetReader alloc]initWithAsset:asset error:&error];
    if (error) {
        return nil;
    }
    AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    if (!track) {
        return nil;
    }
    //读取配置
    NSDictionary *dic = @{AVFormatIDKey :@(kAudioFormatLinearPCM),
                          AVLinearPCMIsBigEndianKey:@NO,
                          AVLinearPCMIsFloatKey:@NO,
                          AVLinearPCMBitDepthKey :@(16)
                          };
    //读取输出，在相应的轨道和输出对应格式的数据
    AVAssetReaderTrackOutput *output = [[AVAssetReaderTrackOutput alloc]initWithTrack:track outputSettings:dic];
    [assetReader addOutput:output];
    [assetReader startReading];
    
    NSMutableData *sampleData = [[NSMutableData alloc]init];
    while (assetReader.status == AVAssetReaderStatusReading) {
        
        CMSampleBufferRef sampleBuffer = [output copyNextSampleBuffer]; //读取到数据
        if (sampleBuffer) {
            
            CMBlockBufferRef blockBUfferRef = CMSampleBufferGetDataBuffer(sampleBuffer);//取出数据
            size_t length = CMBlockBufferGetDataLength(blockBUfferRef); //返回一个大小，size_t针对不同的品台有不同的实现，扩展性更好
            SInt16 sampleBytes[length];
            CMBlockBufferCopyDataBytes(blockBUfferRef, 0, length, sampleBytes); //将数据放入数组
            [sampleData appendBytes:sampleBytes length:length]; //将数据附加到data中
            CMSampleBufferInvalidate(sampleBuffer);//销毁
            CFRelease(sampleBuffer); //释放
        }
    }
    if (assetReader.status == AVAssetReaderStatusCompleted) {
        return sampleData;
    }
    return nil;
}
@end
