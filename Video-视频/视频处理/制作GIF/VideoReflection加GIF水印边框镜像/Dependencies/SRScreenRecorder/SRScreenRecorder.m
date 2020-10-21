//
//  SRScreenRecorder
//  VideoReflection
//
//  Created by Johnny Xu(徐景周) on 5/22/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "SRScreenRecorder.h"
#import "PBJVideoView.h"
#import "StickerView.h"
#import "VideoView.h"

#define DEFAULT_FRAME_INTERVAL 6  // 60/DEFAULT_FRAME_INTERVAL frames/sec
#define DEFAULT_AUTOSAVE_DURATION 60
#define TIME_SCALE 60

#define DefaultOutputVideoName @"outputMovie.mov"
#define DefaultOutputAudioName @"outputAudio.caf"

static NSInteger counter;

@interface SRScreenRecorder ()

@property (strong, nonatomic) AVAssetWriter *writer;
@property (strong, nonatomic) AVAssetWriterInput *writerInput;
@property (strong, nonatomic) AVAssetWriterInputPixelBufferAdaptor *writerInputPixelBufferAdaptor;
@property (strong, nonatomic) CADisplayLink *displayLink;

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;

@property (strong, nonatomic) NSTimer *timerEffect;
@property (strong, nonatomic) AVAssetExportSession *exportSession;

@end

@implementation SRScreenRecorder
{
	CFAbsoluteTime firstFrameTime;
    CFTimeInterval startTimestamp;
    
    dispatch_queue_t queue;
    UIBackgroundTaskIdentifier backgroundTask;
}

+ (SRScreenRecorder *)sharedInstance
{
    static SRScreenRecorder *sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[SRScreenRecorder alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _frameInterval = DEFAULT_FRAME_INTERVAL;
        _autosaveDuration = DEFAULT_AUTOSAVE_DURATION;
        
        _audioOutPath = nil;
        _gifArray = nil;
        _videoArray = nil;
        
        _timerEffect = nil;
        _exportSession = nil;
        
        counter++;
        NSString *label = [NSString stringWithFormat:@"recorder-%ld", (long)counter];
        queue = dispatch_queue_create([label cStringUsingEncoding:NSUTF8StringEncoding], NULL);
        
        [self setupNotifications];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc at SRScreenRecorder");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    _writer = nil;
//    _writerInput = nil;
//    _writerInputPixelBufferAdaptor = nil;
    
    if (_exportSession)
    {
        _exportSession = nil;
    }
    
    if (_displayLink)
    {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    if (_timerEffect)
    {
        [_timerEffect invalidate];
        _timerEffect = nil;
    }
}

#pragma mark Setup

- (void)setupAssetWriterWithURL:(NSURL *)outputURL withOutputSize:(CGSize)outputSize
{
    NSError *error = nil;
    
    self.writer = [[AVAssetWriter alloc] initWithURL:outputURL fileType:AVFileTypeQuickTimeMovie error:&error];
    NSParameterAssert(self.writer);
    if (error)
    {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    
//   UIScreen *mainScreen = [UIScreen mainScreen];
    CGSize size = outputSize; //mainScreen.bounds.size;
    
    NSDictionary *outputSettings = @{AVVideoCodecKey : AVVideoCodecH264, AVVideoWidthKey : @(size.width), AVVideoHeightKey : @(size.height)};
    self.writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:outputSettings];
	self.writerInput.expectsMediaDataInRealTime = YES;
    
    NSDictionary *sourcePixelBufferAttributes = @{(NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32ARGB)};
    self.writerInputPixelBufferAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:self.writerInput
                                                                                                          sourcePixelBufferAttributes:sourcePixelBufferAttributes];
    NSParameterAssert(self.writerInput);
    NSParameterAssert([self.writer canAddInput:self.writerInput]);
    
    [self.writer addInput:self.writerInput];
    
	firstFrameTime = CFAbsoluteTimeGetCurrent();
    
    [self.writer startWriting];
    [self.writer startSessionAtSourceTime:kCMTimeZero];
}

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)setupTimer
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(captureFrame:)];
    self.displayLink.frameInterval = self.frameInterval;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark Recording

- (void)startRecording:(CGSize)outputSize
{
    // Delete file
    unlink([[self getOutputFilePath] UTF8String]);
    
    [self setupAssetWriterWithURL:[NSURL fileURLWithPath:[self getOutputFilePath]] withOutputSize:outputSize];
    
    [self setupTimer];
}

- (void)stopRecording
{
    [self.displayLink invalidate];
    startTimestamp = 0.0;
    
    dispatch_async(queue, ^
                   {
                       if (self.writer.status != AVAssetWriterStatusCompleted && self.writer.status != AVAssetWriterStatusUnknown)
                       {
                           [self.writerInput markAsFinished];
                       }
                       
                       if ([self.writer respondsToSelector:@selector(finishWritingWithCompletionHandler:)])
                       {
                           [self.writer finishWritingWithCompletionHandler:^
                            {
                                [self finishBackgroundTask];
                                
                                if (_audioOutPath || (_videoArray && [_videoArray count] > 0))
                                {
                                    [self addEffectToRecording];
                                }
                                else
                                {
                                    // Save video to Album
                                    [self writeExportedVideoToAssetsLibrary:[self getOutputFilePath]];
                                }
                            }];
                       }
                    });
}

- (void)rotateFile
{
    dispatch_async(queue, ^
                   {
                       [self stopRecording];
                   });
}

- (void)captureFrame:(CADisplayLink *)displayLink
{
    dispatch_async(queue, ^
                   {
                       if (self.writerInput.readyForMoreMediaData)
                       {
                           CVReturn status = kCVReturnSuccess;
                           CVPixelBufferRef buffer = NULL;
                           CFTypeRef backingData;
                           
                           __block UIImage *screenshot = nil;
                           dispatch_sync(dispatch_get_main_queue(), ^{
                               if (_captureViewBlock)
                               {
                                   screenshot = self.captureViewBlock();
                               }
//                               else
//                               {
//                                   screenshot = [self screenshot];
//                               }
                           });
                           
                           if (!screenshot)
                           {
                               return;
                           }
                           
                           CGImageRef imageRef = screenshot.CGImage;
                           
                           CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
                           CFDataRef data = CGDataProviderCopyData(dataProvider);
                           backingData = CFDataCreateMutableCopy(kCFAllocatorDefault, CFDataGetLength(data), data);
                           CFRelease(data);
                           
                           const UInt8 *bytePtr = CFDataGetBytePtr(backingData);
                           status = CVPixelBufferCreateWithBytes(kCFAllocatorDefault,
                                                                 CGImageGetWidth(imageRef),
                                                                 CGImageGetHeight(imageRef),
                                                                 kCVPixelFormatType_32BGRA,
                                                                 (void *)bytePtr,
                                                                 CGImageGetBytesPerRow(imageRef),
                                                                 NULL,
                                                                 NULL,
                                                                 NULL,
                                                                 &buffer);
                           NSParameterAssert(status == kCVReturnSuccess && buffer);
                
                           
                           if (buffer)
                           {
                               CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
                               CFTimeInterval elapsedTime = currentTime - firstFrameTime;
                               CMTime presentTime =  CMTimeMake(elapsedTime * TIME_SCALE, TIME_SCALE);
                               
                               // Sample time setting
                               if (_captureVideoSampleTimeBlock && !CMTIME_IS_INVALID(_captureVideoSampleTimeBlock()))
                               {
                                   presentTime = self.captureVideoSampleTimeBlock();
                               }
                               
                               if(![self.writerInputPixelBufferAdaptor appendPixelBuffer:buffer withPresentationTime:presentTime])
                               {
                                   [self stopRecording];
                               }
                               
                               CVPixelBufferRelease(buffer);
                           }
                           
                           CFRelease(backingData);
                       }
                   });
    
    if (startTimestamp == 0.0)
    {
        startTimestamp = displayLink.timestamp;
    }
    
//    NSTimeInterval dalta = displayLink.timestamp - startTimestamp;
//    if (self.autosaveDuration > 0 && dalta > self.autosaveDuration)
//    {
//        startTimestamp = 0.0;
//        [self rotateFile];
//    }
}

//- (UIImage *)screenshot
//{
//    UIScreen *mainScreen = [UIScreen mainScreen];
//    CGSize imageSize = mainScreen.bounds.size;
//    if (UIGraphicsBeginImageContextWithOptions)
//    {
//        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    }
//    else
//    {
//        UIGraphicsBeginImageContext(imageSize);
//    }
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    NSArray *windows = [[UIApplication sharedApplication] windows];
//    for (UIWindow *window in windows)
//    {
//        if (![window respondsToSelector:@selector(screen)] || window.screen == mainScreen)
//        {
//            CGContextSaveGState(context);
//            
//            CGContextTranslateCTM(context, window.center.x, window.center.y);
//            CGContextConcatCTM(context, [window transform]);
//            CGContextTranslateCTM(context,
//                                  -window.bounds.size.width * window.layer.anchorPoint.x,
//                                  -window.bounds.size.height * window.layer.anchorPoint.y);
//            
//            [window.layer.presentationLayer renderInContext:context];
//            
//            CGContextRestoreGState(context);
//        }
//    }
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return image;
//}

#pragma mark Background tasks

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    UIApplication *application = [UIApplication sharedApplication];
    
    UIDevice *device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)])
    {
        backgroundSupported = device.multitaskingSupported;
    }
    
    if (backgroundSupported)
    {
        backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
            [self finishBackgroundTask];
        }];
    }
    
//    [self stopRecording];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    [self finishBackgroundTask];
//    [self startRecording];
}

- (void)finishBackgroundTask
{
    if (backgroundTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid;
    }
}

#pragma mark Utility methods

- (NSString *)documentDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

- (NSString *)defaultFilename
{
    time_t timer;
    time(&timer);
    NSString *timestamp = [NSString stringWithFormat:@"%ld", timer];
    return [NSString stringWithFormat:@"%@.mov", timestamp];
}

- (BOOL)existsFile:(NSString *)filename
{
    NSString *path = [self.documentDirectory stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDirectory;
    return [fileManager fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory;
}

- (NSString *)nextFilename:(NSString *)filename
{
    static NSInteger fileCounter;
    
    fileCounter++;
    NSString *pathExtension = [filename pathExtension];
    filename = [[[filename stringByDeletingPathExtension] stringByAppendingString:[NSString stringWithFormat:@"-%ld", (long)fileCounter]] stringByAppendingPathExtension:pathExtension];
    
    if ([self existsFile:filename])
    {
        return [self nextFilename:filename];
    }
    
    return filename;
}

- (NSURL *)outputFileURL
{    
    if (!self.filenameBlock)
    {
        __block SRScreenRecorder *wself = self;
        self.filenameBlock = ^(void) {
            return [wself defaultFilename];
        };
    }
    
    NSString *filename = self.filenameBlock();
    if ([self existsFile:filename])
    {
        filename = [self nextFilename:filename];
    }
    
    NSString *path = [self.documentDirectory stringByAppendingPathComponent:filename];
    return [NSURL fileURLWithPath:path];
}

- (NSString*)getOutputFilePath
{
    NSString* mp4OutputFile = [NSTemporaryDirectory() stringByAppendingPathComponent:DefaultOutputVideoName];
    return mp4OutputFile;
    
    //    NSString *path = NSTemporaryDirectory();
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"yyyyMMddHHmmss";
    //    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    //
    //    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@".mp4"];
    //    return fileName;
}

#pragma mark - Export Video
- (void)writeExportedVideoToAssetsLibrary:(NSString *)outputPath
{
    __unsafe_unretained typeof(self) weakSelf = self;
    NSURL *exportURL = [NSURL fileURLWithPath:outputPath];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:exportURL])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:exportURL completionBlock:^(NSURL *assetURL, NSError *error)
         {
             NSString *message;
             if (!error)
             {
                 message = GBLocalizedString(@"MsgSuccess");
             }
             else
             {
                 message = [error description];
             }
             
             NSLog(@"%@", message);
             
             // Output path
             self.filenameBlock = ^(void) {
                 return outputPath;
             };
             
             if (weakSelf.finishRecordingBlock)
             {
                 weakSelf.finishRecordingBlock(YES, message);
             }
         }];
    }
    else
    {
        NSString *message = GBLocalizedString(@"MsgFailed");;
        NSLog(@"%@", message);
        
        if (_finishRecordingBlock)
        {
            _finishRecordingBlock(NO, message);
        }
    }
    
    library = nil;
}

#pragma mark - Audio
//- (void)setupAudioRecord
//{
//    // Setup to be able to record global sounds (preexisting app sounds)
//    NSError *sessionError = nil;
//    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(setCategory:withOptions:error:)])
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDuckOthers error:&sessionError];
//    else
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
//    
//    // Set the audio session to be active
//    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
//    
//    if (sessionError)
//    {
//        self.finishRecordingBlock(NO, sessionError.description);
//        return;
//    }
//    
//    // Set the number of audio channels, using defaults if necessary.
//    NSNumber *audioChannels = (self.numberOfAudioChannels ? self.numberOfAudioChannels : @2);
//    NSNumber *sampleRate    = (self.audioSampleRate       ? self.audioSampleRate       : @44100.f);
//    
//    NSDictionary *audioSettings = @{
//                                    AVNumberOfChannelsKey : (audioChannels ? audioChannels : @2),
//                                    AVSampleRateKey       : (sampleRate    ? sampleRate    : @44100.0f)
//                                    };
//    
//    
//    // Initialize the audio recorder
//    // Set output path of the audio file
//    NSError *error = nil;
//    NSAssert((self.audioOutPath != nil), @"Audio out path cannot be nil!");
//    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.audioOutPath] settings:audioSettings error:&error];
//    if (error)
//    {
//        // Let the delegate know that shit has happened.
//        self.finishRecordingBlock(NO, error.description);;
//        _audioRecorder = nil;
//        
//        return;
//    }
//    
//    [_audioRecorder prepareToRecord];
//    
//    // Start recording :P
//    [_audioRecorder record];
//}
//
//- (void)stopAudioRecord
//{
//    // Stop the audio recording
//    [_audioRecorder stop];
//    _audioRecorder = nil;
//}

- (void)addEffectToRecording
{
    double degrees = 0.0;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:@"vidorientation"])
        degrees = [[prefs objectForKey:@"vidorientation"] doubleValue];
    
    NSString *videoPath = [self getOutputFilePath];
    NSString *audioPath = self.audioOutPath;
    
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    
    NSString *fileName = [audioPath stringByDeletingPathExtension];
    NSLog(@"%@",fileName);
    NSString *fileExt = [audioPath pathExtension];
    NSLog(@"%@",fileExt);
    NSURL *audioURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:fileExt];
    
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:audioURL options:nil];
    
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath])
    {
        NSArray *assetArray = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        if ([assetArray count] > 0)
            assetVideoTrack = assetArray[0];
    }
    
    NSArray *assetArray = [audioAsset tracksWithMediaType:AVMediaTypeAudio];
    if ([assetArray count] > 0)
        assetAudioTrack = assetArray[0];
    
    CGSize videoSize = CGSizeZero;
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    if (assetVideoTrack)
    {
        videoSize = assetVideoTrack.naturalSize;
        
        AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:assetVideoTrack atTime:kCMTimeZero error:nil];
        
        [compositionVideoTrack setPreferredTransform:CGAffineTransformMakeRotation(degreesToRadians(degrees))];
    }
    
    NSLog(@"videoSize width: %f, Height: %f", videoSize.width, videoSize.height);
    if (videoSize.height == 0 || videoSize.width == 0)
    {
        if (self.finishRecordingBlock)
        {
            self.finishRecordingBlock(NO, GBLocalizedString(@"MsgConvertFailed"));
        }
        
        return;
    }
    
    if (assetAudioTrack)
    {
        AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:assetAudioTrack atTime:kCMTimeZero error:nil];
    }
    
    // 4. Effects
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.bounds = CGRectMake(0, 0, videoSize.width, videoSize.height);
    parentLayer.anchorPoint = CGPointMake(0, 0);
    parentLayer.position = CGPointMake(0, 0);
    
    videoLayer.bounds = parentLayer.bounds;
    videoLayer.anchorPoint =  CGPointMake(0.5, 0.5);
    videoLayer.position = CGPointMake(CGRectGetMidX(parentLayer.bounds), CGRectGetMidY(parentLayer.bounds));
    
    parentLayer.geometryFlipped = YES;
    [parentLayer addSublayer:videoLayer];
    
    // Animation effects
//    NSMutableArray *animatedLayers = [[NSMutableArray alloc] init];
//    CALayer *animatedLayer = nil;
    
    // 1. Gifs
//    if (_gifArray && [_gifArray count] > 0)
//    {
//        for (StickerView *view in _gifArray)
//        {
//            NSString *gifPath = view.getFilePath;
//            CGRect frame = view.getInnerFrame;
//            animatedLayer = [GifAnimationLayer layerWithGifFilePath:gifPath withFrame:frame];
//            if (animatedLayer && [animatedLayer isKindOfClass:[GifAnimationLayer class]])
//            {
//                [animatedLayers addObject:(id)animatedLayer];
//            }
//        }
//    }
    
    
    // 2. Videos
//    if (_videoArray && [_videoArray count] > 0)
//    {
//        for (VideoView *view in _videoArray)
//        {
//            NSString *videoPath = view.getFilePath;
//            CGRect frame = view.getInnerFrame;
//            animatedLayer = [VideoAnimationLayer layerWithVideoFilePath:videoPath withFrame:frame];
//            if (animatedLayer && [animatedLayer isKindOfClass:[VideoAnimationLayer class]])
//            {
//                [animatedLayers addObject:(id)animatedLayer];
//            }
//        }
//    }
    
//    if (animatedLayers && [animatedLayers count] > 0)
//    {
//        for (CALayer *animatedLayer in animatedLayers)
//        {
//            [parentLayer addSublayer:animatedLayer];
//        }
//    }
    
    // Video composition.
    AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, [videoAsset duration]);
    
    AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:assetVideoTrack];
    mainInstruciton.layerInstructions = [NSArray arrayWithObject:layerInstruciton];
    
    AVMutableVideoComposition *mainComposition = [AVMutableVideoComposition videoComposition];
    mainComposition.instructions = [NSArray arrayWithObject:mainInstruciton]; //@[mainInstruciton];
    mainComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    mainComposition.frameDuration = CMTimeMake(1, 30);
    mainComposition.renderSize = videoSize;
    
    
    NSString *exportPath = [videoPath substringWithRange:NSMakeRange(0, videoPath.length - 4)];
    exportPath = [NSString stringWithFormat:@"%@.mp4", exportPath];
    NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
    
    // Delete old file
    unlink([exportPath UTF8String]);
    
    _exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    [_exportSession setOutputFileType:[[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 ? AVFileTypeMPEG4 : AVFileTypeQuickTimeMovie];
    [_exportSession setOutputURL:exportURL];
    [_exportSession setShouldOptimizeForNetworkUse:YES];
    
    if (mainComposition)
    {
        _exportSession.videoComposition = mainComposition;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Progress monitor
        _timerEffect = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                                        target:self
                                                      selector:@selector(retrievingExportProgress)
                                                      userInfo:nil
                                                       repeats:YES];
    });
    
    __block typeof(self) blockSelf = self;
    [blockSelf.exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        switch ([blockSelf.exportSession status])
        {
            case AVAssetExportSessionStatusCompleted:
            {
                [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
                
                // Close timer
                [blockSelf.timerEffect invalidate];
                blockSelf.timerEffect = nil;

                // Save video to Album
                [self writeExportedVideoToAssetsLibrary:exportPath];
                
                NSLog(@"Export Successful: %@", exportPath);
                break;
            }
                
            case AVAssetExportSessionStatusFailed:
            {
                // Close timer
                [blockSelf.timerEffect invalidate];
                blockSelf.timerEffect = nil;

                if (_finishRecordingBlock)
                {
                    self.finishRecordingBlock(NO, GBLocalizedString(@"MsgConvertFailed"));
                }
                
                NSLog(@"Export failed: %@, %@", [[blockSelf.exportSession error] localizedDescription], [blockSelf.exportSession error]);
                break;
            }
                
            case AVAssetExportSessionStatusCancelled:
            {
                NSLog(@"Canceled: %@", blockSelf.exportSession.error);
                break;
            }
            default:
                break;
        }
    }];
}

// Export progress callback
- (void)retrievingExportProgress
{
    if (_exportSession && _exportProgressBlock)
    {
        self.exportProgressBlock([NSNumber numberWithFloat:_exportSession.progress]);
    }
}

@end
