//
//  VideoAnimationLayer
//  VideoReflection
//
//  Created by Johnny Xu(徐景周) on 5/22/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//

#import "VideoAnimationLayer.h"
#import "MIMovieVideoSampleAccessor.h"

@interface VideoAnimationLayer()
{
}

@property (nonatomic,assign) NSUInteger currentVideoFrameIndex;
@property (strong, nonatomic) NSMutableArray *imageVideoFrames;
@property (assign, nonatomic) CGFloat videoDuration;

@end

@implementation VideoAnimationLayer

+ (VideoAnimationLayer *)sharedInstance
{
    static VideoAnimationLayer *sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[VideoAnimationLayer alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _currentVideoFrameIndex = NSNotFound;
        _videoDuration = 0;
        _imageVideoFrames = nil;
        
        self.cornerRadius = CGRectGetWidth(self.frame)/2;
        self.borderWidth = 2.0;
        self.borderColor = kLightBlue.CGColor;
        self.masksToBounds = YES;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc at VideoAnimationLayer");
    
    _currentVideoFrameIndex = NSNotFound;
    _videoDuration = 0;
    if (_imageVideoFrames)
    {
        [_imageVideoFrames removeAllObjects];
        _imageVideoFrames = nil;
    }
}

+ (id)layerWithVideoFilePath:(NSString *)filePath withFrame:(CGRect)frame
{
    VideoAnimationLayer *layer = [self layer];
    layer.frame = frame;
//    layer.cornerRadius = CGRectGetWidth(frame)/2;
//    layer.borderWidth = 2.0;
//    layer.borderColor = kLightBlue.CGColor;
//    layer.masksToBounds = YES;
    layer.videoFilePath = filePath;
    
    return layer;
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    return [key isEqualToString:@"currentVideoFrameIndex"];
}

- (void)display
{
    NSUInteger index = [(VideoAnimationLayer *)[self presentationLayer] currentVideoFrameIndex];
    if (index == NSNotFound)
    {
        return;
    }
    
    NSLog(@"display frame index: %lu", (unsigned long)index);
    
    if (_imageVideoFrames && [_imageVideoFrames count] > 0)
    {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.contents = (id)_imageVideoFrames[index];
        [CATransaction commit];
    }
}

- (void)setVideoFilePath:(NSString *)videoFilePath
{
    if (!isStringEmpty(videoFilePath))
    {
        _videoFilePath = videoFilePath;
        _videoDuration = [self captureVideoSample:getFileURL(_videoFilePath) saveToCGImage:YES];
        
        [self setCurrentVideoFrameIndex:0];
        [self display];
        
        [self startAnimation];
    }
}

#pragma mark - Animation
- (void)startAnimation
{
    CGFloat repeatCount = INFINITY;
    CFTimeInterval interval = 0.1;
    CAKeyframeAnimation *animContents = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animContents.duration = _videoDuration;
    animContents.values = [NSArray arrayWithArray:_imageVideoFrames];
    animContents.beginTime = interval;
    animContents.repeatCount = repeatCount;
    animContents.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animContents.removedOnCompletion = NO;
    animContents.delegate = self;
    [animContents setValue:@"stop" forKey:@"TAG"];
    [self addAnimation:animContents forKey:@"contents"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString *tag = [anim valueForKey:@"TAG"];
    if ([tag isEqualToString:@"stop"])
    {
//        self.contents = nil;
        _currentVideoFrameIndex = NSNotFound;
        
        NSLog(@"animationDidStop for Video");
    }
}

#pragma mark - Capture Video Sample
- (CGFloat)captureVideoSample:(NSURL *)videoURL saveToCGImage:(BOOL)saveToCGImage
{
    if (_imageVideoFrames)
    {
        [_imageVideoFrames removeAllObjects];
        _imageVideoFrames = nil;
    }
    _imageVideoFrames = [[NSMutableArray alloc] initWithCapacity:10];
    
    AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    MIMovieVideoSampleAccessor *sampleAccessor = [[MIMovieVideoSampleAccessor alloc]  initWithMovie:videoAsset
                                                                                    firstSampleTime:kCMTimeZero
                                                                                             tracks:nil
                                                                                      videoSettings:nil
                                                                                   videoComposition:nil];
    
    // Calc & Show precentage
    CGFloat totalSeconds = sampleAccessor.assetDuration.value / sampleAccessor.assetDuration.timescale;
    _videoDuration = totalSeconds;
    NSLog(@"_videoDuration: %f", _videoDuration);
    
    while (TRUE)
    {
        MICMSampleBuffer *buffer = [sampleAccessor nextSampleBuffer];
        if (!buffer)
        {
            return totalSeconds;
        }
        
        // Get frame image
        CMSampleBufferRef sampleBuffer = buffer.CMSampleBuffer;
        UIImage *thumbnail = imageFixOrientation(imageFromSampleBuffer(sampleBuffer));
        if (thumbnail)
        {
            if (saveToCGImage)
            {
                // Only used to embeded video so that reduce size by "generateThumbnailPhoto()"
                [_imageVideoFrames addObject:(id)[generateThumbnailPhoto(thumbnail) CGImage]];
            }
            else
            {
                [_imageVideoFrames addObject:generateThumbnailPhoto(thumbnail)];
            }
        }
    }
    
    return totalSeconds;
}

- (CGFloat)getVideoDuration
{
    return _videoDuration;
}

- (NSMutableArray *)getImageVideoFrames
{
    return _imageVideoFrames;
}

@end
