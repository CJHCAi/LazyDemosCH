//
//  Mp4VideoWriter.m
//  Inew_Cam
//
//  Created by hjm on 17/2/7.
//  Copyright © 2017年 GaoZhi. All rights reserved.
//

#import "Mp4VideoWriter.h"
#import <sys/time.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height



@interface Mp4VideoWriter()
{
    AVAssetWriter *videoWriter;
    AVAssetWriterInput *videoWriterInput;
    AVAssetWriterInput *audioWriterIput;
    AVAssetWriterInputPixelBufferAdaptor *adaptor;
    unsigned long currentVideoTimeStamp;
    unsigned long startTimeStamp;
    unsigned long startAudioTime;
    
    CGSize videoSize;
    NSFileHandle *fileHandle;
    
}
@property (strong,nonatomic)NSString *Mp4Path;

@end





@implementation Mp4VideoWriter




@synthesize delegate = _delegate;

-(instancetype) initVideoAudioWriterSize:(CGSize)writerVideoSize
{
    self = [super init];
    
    
    if (self) {
        
    }
    
    videoSize = writerVideoSize;
    
    return self;

}

-(void)initAudiowriter{
    
    
    
    
    self.Mp4Path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/YSMovie.mp4"];
    
    
    
    unlink([self.Mp4Path UTF8String]);
    

    unlink([self.Mp4Path UTF8String]);
    
    
    
    NSError *error = nil;
    
    videoWriter = [[AVAssetWriter alloc] initWithURL:
                   [NSURL fileURLWithPath:self.Mp4Path] fileType:AVFileTypeMPEG4
                                               error:&error];
    
    //------------------------------------------------------------------------------------ Create WriterInput
    AudioChannelLayout acl;
    bzero(&acl, sizeof(acl));
    acl.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    
    NSDictionary *outputSettings = @{AVFormatIDKey : [NSNumber numberWithUnsignedInt:kAudioFormatMPEG4AAC],
                                     AVSampleRateKey : [NSNumber numberWithFloat:32000.0],
                                     AVChannelLayoutKey : [NSData dataWithBytes:&acl length:sizeof(acl)]};
    
    audioWriterIput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:outputSettings];
    if (![videoWriter canAddInput:audioWriterIput]) {
 //       exit(4);
    }
    [videoWriter addInput:audioWriterIput];
 //   // GZLog(@"Mark0810: inputs %@", videoWriter.inputs);
    
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:CMTimeMake(0, 8000)];
}

-(void)initVideoWriter
{
    
    self.Mp4Path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp.mp4"];
    unlink([self.Mp4Path UTF8String]);
    
    
    NSError *error = nil;
    
    videoWriter = [[AVAssetWriter alloc] initWithURL:
                   [NSURL fileURLWithPath:self.Mp4Path] fileType:AVFileTypeMPEG4
                                               error:&error];
    
    NSParameterAssert(videoWriter);
    
    if(error)
    {
      //  // GZLog(@"error = %@", [error localizedDescription]);
    }
    
    if (videoSize.width==0||videoSize.height==0) {
        NSLog(@"获取视频宽高错误，不能写入该视频。");
        return;
    }

    //写入视频大小
    NSInteger numPixels = videoSize.width * videoSize.height;
    //每像素比特
    CGFloat bitsPerPixel = 8.0;
    NSInteger bitsPerSecond = numPixels * bitsPerPixel;
    
    // 码率和帧率设置
    NSDictionary *compressionProperties = @{ AVVideoAverageBitRateKey : @(bitsPerSecond),
                                             AVVideoExpectedSourceFrameRateKey : @(_fps),
                                             AVVideoMaxKeyFrameIntervalKey : @(_fps),
                                             AVVideoProfileLevelKey : AVVideoProfileLevelH264BaselineAutoLevel };
    
    
    NSDictionary *attributes = @{ AVVideoCodecKey : AVVideoCodecH264,
                                         AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
                                         AVVideoWidthKey : @(videoSize.width),
                                         AVVideoHeightKey : @(videoSize.height),
                                         AVVideoCompressionPropertiesKey : compressionProperties };
    
    
    videoWriterInput = [AVAssetWriterInput
                        assetWriterInputWithMediaType:AVMediaTypeVideo
                        outputSettings:attributes];
    
    NSParameterAssert(videoWriterInput);
    
    videoWriterInput.expectsMediaDataInRealTime = YES;
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(_transForm / 180.0 * M_PI );
    videoWriterInput.transform = rotate;
    
    adaptor = [AVAssetWriterInputPixelBufferAdaptor
               assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
               sourcePixelBufferAttributes:attributes];
    
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    
    
    // Add the audio input
    
    AudioChannelLayout acl;
    bzero(&acl, sizeof(acl));
    acl.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    
    NSDictionary *outputSettings = @{AVFormatIDKey : [NSNumber numberWithUnsignedInt:kAudioFormatMPEG4AAC],
                                     AVSampleRateKey : [NSNumber numberWithFloat:44100.0],
                                     AVNumberOfChannelsKey : [NSNumber numberWithInt:2],
                                     AVChannelLayoutKey : [NSData dataWithBytes:&acl length:sizeof(acl)]};
    
    audioWriterIput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:outputSettings];
    audioWriterIput.expectsMediaDataInRealTime = YES;
    
    
    if (![videoWriter canAddInput:audioWriterIput]) {
        NSLog(@"i can't add this audioinput");
        return;
    }
    
    
    if (![videoWriter canAddInput:videoWriterInput]) {
        NSLog(@"i can't add this videoinput");
        return;
    }
    
    [videoWriter addInput:videoWriterInput];
    [videoWriter addInput:audioWriterIput];
    //// GZLog(@"Mark0810: inputs %@", videoWriter.inputs);
    
    
    
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:CMTimeMake(0, 44100.0)];
}


-(void)WritevideoBegain
{
    
    [self initVideoWriter];
    self.isStart = YES;
   // [self initAudiowriter];
}






- (void)yaSuoShiPinWithfilepathCompletionHandler:(void (^)(void))handler{
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:_Mp4Path] options:nil];
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = [NSURL fileURLWithPath:_YasuoMp4Path];
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:_YasuoMp4Path]) {
        NSError *error;
        if ([[NSFileManager defaultManager] removeItemAtPath:_YasuoMp4Path error:&error] == NO) {
          //  // GZLog(@"removeitematpath %@ error :%@", _YasuoMp4Path, error);
        }
    }
    
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        NSInteger exportStatus = exportSession.status;
        //       // GZLog(@"%d",exportStatus);
        switch (exportStatus)
        {
            case AVAssetExportSessionStatusFailed:
            {
                // log error to text view
            //    NSError *exportError = exportSession.error;
              //  // GZLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                
                handler();
                
            }
                break;
            case AVAssetExportSessionStatusCompleted:
            {
             //   // GZLog(@"视频转码成功");
                
                
                
                handler();
                
                
                
              //  NSData *data = [NSData dataWithContentsOfFile:self.Mp4Path];
            }
                break;
        }
    }];
}





-(void)WriteVideoEnd
{
    [videoWriterInput markAsFinished];
    [audioWriterIput markAsFinished];
    
    
  //  dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [videoWriter finishWritingWithCompletionHandler:^{
            videoWriter = nil;
            videoWriterInput = nil;
            audioWriterIput = nil;
            adaptor = nil;
            
         //   压缩mp4（暂不使用）
        //    [self yaSuoShiPinWithfilepathCompletionHandler:^{
                
//                if ([[NSFileManager defaultManager] fileExistsAtPath:_Mp4Path]) {
//                    NSError *error;
//                    if ([[NSFileManager defaultManager] removeItemAtPath:_Mp4Path error:&error] == NO) {
//                        // GZLog(@"removeitematpath %@ error :%@", _Mp4Path, error);
//                    }
//                }
            __block PHObjectPlaceholder *placeholder;
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(_Mp4Path))
            {
                NSError *error;
                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                    PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:_Mp4Path]];
                    placeholder = [createAssetRequest placeholderForCreatedAsset];
                } error:&error];
                if (error) {
                    if([_delegate respondsToSelector:@selector(SaveMp4Faild:)]) {
                        [_delegate SaveMp4Faild:error];
                    }
                }
                else{
                    if ([_delegate respondsToSelector:@selector(SaveMp4Succuce:)]) {
                        
                        [_delegate SaveMp4Succuce:error];
                    }
                }
            }
        }];

    self.isStart = NO;
}


-(unsigned long)GetTickCount
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    
    if (gettimeofday(&tv, NULL) != 0)
        return 0;
    return (tv.tv_sec*1000  + tv.tv_usec / 1000);
}




-(unsigned long)GetAudioTickCount
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    
    if (gettimeofday(&tv, NULL) != 0)
        return 0;
    return (tv.tv_sec*8000  + tv.tv_usec / 8000);
}




- (void)writeVideoWithCGImage: (CVPixelBufferRef)frameImage  Time:(CMTime)time
{
    CVPixelBufferRef buffer = NULL;
    
  //  currentVideoTimeStamp=[self GetTickCount]-startTimeStamp;
   // currentVideoTimeStamp++;
    
    
   // CMTime frameTime = CMTimeMake(currentVideoTimeStamp, _fps);
    
    buffer = frameImage;
    if(adaptor.assetWriterInput.readyForMoreMediaData==YES)
    {
        BOOL result = [adaptor appendPixelBuffer:buffer withPresentationTime:time];
        if (result == NO)
        {
            //   printf("failed to append VIDEO buffer\n");
        }
        else{
           //   printf(">>>>>>>>>>>>>>>>>>>append Video buffer\n");
        }
        
    }
}





- (void)writeAudioBytesWithDataBuffer: (CMSampleBufferRef)sampleBuffer
{
@autoreleasepool {
    currentVideoTimeStamp = 0;
    if([audioWriterIput isReadyForMoreMediaData])
    {
        if (sampleBuffer)
        {
            
            if([audioWriterIput appendSampleBuffer:sampleBuffer])
            {
              //  printf("<<<<<<<<<<<<<<<<<<<append Audio buffer\n");
            }
            else{
              //  printf("failed to append Audio buffer\n");
            }
            if(sampleBuffer)
            {
                CFRelease(sampleBuffer);
            }
        }else{
          //  // GZLog(@"SampleBuffer  == null !");
        }
        
    }
}
}

@end
