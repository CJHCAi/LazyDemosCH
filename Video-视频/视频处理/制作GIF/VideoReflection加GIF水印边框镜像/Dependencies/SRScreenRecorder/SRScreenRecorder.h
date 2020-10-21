//
//  SRScreenRecorder
//  VideoReflection
//
//  Created by Johnny Xu(徐景周) on 5/22/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <TargetConditionals.h>

typedef NSString *(^SRScreenRecorderOutputFilenameBlock)();

typedef UIImage *(^SRCaptureViewBlock)();
typedef void (^SRFinishRecordingBlock)(BOOL success, id result);
typedef CMTime (^SRCaptureVideoSampleTime)();
typedef void (^SRExportProgressBlock)(NSNumber *percentage);

@interface SRScreenRecorder : NSObject

@property(nonatomic, copy) NSNumber *audioSampleRate;
@property(nonatomic, copy) NSNumber *numberOfAudioChannels;
@property(nonatomic, copy) NSString *audioOutPath;

@property (nonatomic, strong) NSMutableArray *gifArray;
@property (nonatomic, strong) NSMutableArray *videoArray;

@property (assign, nonatomic) NSInteger frameInterval;
@property (assign, nonatomic) NSUInteger autosaveDuration; // in second, default value is 600 (10 minutes).

@property (copy, nonatomic) SRScreenRecorderOutputFilenameBlock filenameBlock;

@property (copy, nonatomic) SRFinishRecordingBlock finishRecordingBlock;
@property (copy, nonatomic) SRCaptureViewBlock captureViewBlock;
@property (copy, nonatomic) SRCaptureVideoSampleTime captureVideoSampleTimeBlock;
@property (copy, nonatomic) SRExportProgressBlock exportProgressBlock;


+ (SRScreenRecorder *)sharedInstance;

- (void)startRecording:(CGSize)outputSize;
- (void)stopRecording;

- (void)writeExportedVideoToAssetsLibrary:(NSString *)outputPath;

@end
