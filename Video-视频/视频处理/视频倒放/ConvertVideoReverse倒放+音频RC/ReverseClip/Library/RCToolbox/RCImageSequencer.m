// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist

#import "RCImageSequencer.h"

#import <CoreMedia/CoreMedia.h>
#import "RCToolbox.h"
#import "RCConstants.h"
#import "SVProgressHUD.h"

#define FRAME_WIDTH 640
#define FRAME_HEIGHT 360
#define FRAMES_PER_SEC 25
#define FRAME_SCALE 600

@interface RCImageSequencer ()
{
    int totalCount;
    int index;
    dispatch_source_t _timer;
    
    float witdh,hight;
}

@property AVAssetImageGenerator *imageGenerator;
@property AVAssetWriter *assetWriter;
@property AVAssetWriterInput *assetWriterInput;
@property AVAssetWriterInputPixelBufferAdaptor *assetWriterPixelBufferAdaptor;
@property CFAbsoluteTime firstFrameWallClockTime;
@property BOOL firstImageSent;
@property float percentageDone;
@property NSMutableArray *imageSequence;
@property Float64 fakeTimeElapsed;
@property Float64 incrementTime;
@property NSString *currentFileName;
@property NSMutableArray *timeSequence;
@end

@implementation RCImageSequencer

- (id)init
{
    self = [super init];
    if (self) {
        _incrementTime = (Float64)1/FRAMES_PER_SEC;
        _fakeTimeElapsed = 0.0;
        witdh=-1;
    }
    return self;
}

-(void) createImageSequenceWithAsset:(AVURLAsset*)urlAsset {

    _percentageDone = 0;
    _fakeTimeElapsed = 0.0;
    _imageSequence = [[NSMutableArray alloc] init];
    _timeSequence = [[NSMutableArray alloc] init];
    
    AVURLAsset *myAsset = urlAsset;
    
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:myAsset];
    _imageGenerator.maximumSize = CGSizeMake(FRAME_WIDTH, FRAME_HEIGHT);
    Float64 durationSeconds = CMTimeGetSeconds([myAsset duration]);
    
    Float64 clipTime = _incrementTime;
    NSMutableArray *times = [[NSMutableArray alloc] init];
    
    while(clipTime < durationSeconds) {
        CMTime frameTime = CMTimeMakeWithSeconds(durationSeconds - clipTime, FRAME_SCALE);
        NSValue *frameTimeValue = [NSValue valueWithCMTime:frameTime];
        
        [times addObject:frameTimeValue];
        NSLog(@"frameTimeValue-- %@ -- ",frameTimeValue);
        clipTime += _incrementTime;
    };

    __block BOOL isComplete = NO;
    [_imageGenerator generateCGImagesAsynchronouslyForTimes:times
                                         completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime,
                                                             AVAssetImageGeneratorResult result, NSError *error) {
                                             
                                             if (result == AVAssetImageGeneratorSucceeded) {
                                                 [_imageSequence addObject:(__bridge id)image];
                                                 [_timeSequence addObject:[NSValue valueWithCMTime:requestedTime]];
                                                 
                                                 _percentageDone = ((Float32)[_imageSequence count] / (Float32)[times count])*100;

                                                 if([_delegate respondsToSelector:@selector(imageSequencerProgress:)]){
                                                     [_delegate imageSequencerProgress:_percentageDone];
                                                 }
                                                 if(witdh<=0.0)
                                                 {
                                                     hight = CGImageGetHeight(image);
                                                     witdh = CGImageGetWidth(image);
                                                 }
                                                 
                                                 
                                                 /*if (!isComplete && [_imageSequence count] == [times count]) {
                                                     [self startWritingTheSamples];
                                                 }*/
                                                 NSLog(@"generateCGImages-- %lld -- %lld",requestedTime.value,actualTime.value);
                                                 if(!isComplete && _percentageDone==100.0){
                                                     isComplete = YES;
                                                     [self startWritingTheSamples];
                                                 }
                                             }
                                             
                                             if (result == AVAssetImageGeneratorFailed) {
                                                 NSLog(@"Image Capture %lu of %lu Failed with error: %@", (unsigned long)[_imageSequence count], (unsigned long)[times count],[error localizedFailureReason]);
                                             }
                                             if (result == AVAssetImageGeneratorCancelled) {
                                                 NSLog(@"Canceled");
                                             }
                                         }];
}

-(void)cancel:(NSNotification*)notification
{
    [_imageGenerator cancelAllCGImageGeneration];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

dispatch_source_t CreateDispatchTimer(double interval, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}


-(void) startWritingTheSamples {
    
    [self startRecording];
    totalCount = (int)_timeSequence.count -1;
    index=0;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    double secondsToFire = 0.005f;
    
    _timer = CreateDispatchTimer(secondsToFire, queue, ^{
        
        [self writeSample:nil Time:kCMTimeZero];
        
        if(totalCount==index)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self cancelTimer];
                [SVProgressHUD dismiss];

            });
            
        }
        
    });
    
    
    
    /*for (id image in _imageSequence){
        
        NSLog(@"-- %@",_timeSequence[added]);
        CMTime tTime = [_timeSequence[count-added] CMTimeValue];
        [self writeSample:(CGImageRef)image Time:tTime];
        added++;
        _percentageDone = .8f + .2f * ((Float32)added / (Float32)[_imageSequence count]);
    }*/
    
   
    
    
    
    
}

- (void)cancelTimer
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        // Remove this if you are on a Deployment Target of iOS6 or OSX 10.8 and above
        //dispatch_release(_timer);
        _timer = nil;
        
        [self stopRecording];
    }
}

-(void) writeSample: (CGImageRef)image Time:(CMTime)timePresent {
    
    if (_assetWriterInput.readyForMoreMediaData) {
        
        timePresent = [_timeSequence[totalCount-index] CMTimeValue];
        id timage = _imageSequence[index];
        image = (__bridge CGImageRef)timage;
        
        index++;
        
        NSLog(@"writeSample-- %d  %d",index,totalCount);
        
		// prepare the pixel buffer
		CVPixelBufferRef pixelBuffer = NULL;
		CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(image));
        
        //kCVPixelFormatType_32BGRA
        CVPixelBufferCreateWithBytes(kCFAllocatorDefault,
                                     witdh,
                                     hight,
                                     kCVPixelFormatType_32ARGB,
                                     (void*)CFDataGetBytePtr(imageData),
                                     CGImageGetBytesPerRow(image),
                                     NULL,
                                     NULL,
                                     NULL,
                                     &pixelBuffer);
        
        //CVPixelBufferCreate(kCFAllocatorDefault, witdh, hight, kCVPixelFormatType_32BGRA, NULL, &pixelBuffer);
        
		// calculate the time
//		CFTimeInterval elapsedTime = _fakeTimeElapsed;
//		CMTime presentationTime =  CMTimeMake (elapsedTime * FRAME_SCALE, FRAME_SCALE);
       // NSLog(@"-PreseTime - %lld",presentationTime.value);

		// write the sample
		BOOL appended = [_assetWriterPixelBufferAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:timePresent];
        
        CFRelease(imageData);
        CVPixelBufferRelease(pixelBuffer);
        
        _fakeTimeElapsed += _incrementTime;
		if (appended) {
            [_delegate imageSequencerProgress:_percentageDone];
		}
	}
    
}


// Asset recorder
-(void) startRecording {
    RCFileHandler *fileHandler = [[RCToolbox sharedToolbox] fileHandler];
    
    _currentFileName = !_currentFileName ? k_exportedSequenceName : _currentFileName;
	NSString *moviePath = [[fileHandler pathToDocumentsDirectory] stringByAppendingPathComponent:_currentFileName];
	if ([[NSFileManager defaultManager] fileExistsAtPath:moviePath]) {
		[[NSFileManager defaultManager] removeItemAtPath:moviePath error:nil];
	}
	
    
	NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
	NSError *movieError = nil;

	_assetWriter = [[AVAssetWriter alloc] initWithURL:movieURL
                                            fileType: AVFileTypeQuickTimeMovie
                                               error: &movieError];
    
	NSDictionary *assetWriterInputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
											  AVVideoCodecH264, AVVideoCodecKey,
											  [NSNumber numberWithInt:witdh], AVVideoWidthKey,
											  [NSNumber numberWithInt:hight], AVVideoHeightKey,
											  nil];
    
	_assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType: AVMediaTypeVideo outputSettings:assetWriterInputSettings];
	_assetWriterInput.expectsMediaDataInRealTime = YES;
	[_assetWriter addInput:_assetWriterInput];

	_assetWriterPixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:_assetWriterInput sourcePixelBufferAttributes:nil];
	[_assetWriter startWriting];
	
	_firstFrameWallClockTime = CFAbsoluteTimeGetCurrent();
	[_assetWriter startSessionAtSourceTime: CMTimeMake(0, FRAME_SCALE)];
	
}
-(void) stopRecording {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [_assetWriter finishWritingWithCompletionHandler:^void{
        _assetWriter = nil;
        _imageSequence = nil;
        if(_delegate && [_delegate respondsToSelector:@selector(exportedImageSequenceToFileName:)]) {
             [_delegate imageSequencerProgress:1.0f];
            [_delegate exportedImageSequenceToFileName:_currentFileName];
        }
    _currentFileName = nil;
    }];
}

@end
