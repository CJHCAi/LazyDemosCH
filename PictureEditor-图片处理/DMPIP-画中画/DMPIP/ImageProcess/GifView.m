//
//  GifView.m
//  GifDemo
//
//  Created by Rick on 15/5/26.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import "GifView.h"

@implementation GifView
//- (id)initWithCenter:(CGPoint)center fileURL:(NSURL*)fileURL;
//{
//    self = [super initWithFrame:CGRectZero];
//    if (self) {
//        
//        _frames = [[NSMutableArray alloc] init];
//        _frameDelayTimes = [[NSMutableArray alloc] init];
//        
//        _width = 0;
//        _height = 0;
//        frameCenter = center;
//        [self initFileURL:fileURL];
//    }
//    return self;
//}
//
//- (void)initFileURL:(NSURL*)fileURL
//{
//    if (fileURL) {
//        getFrameInfo((__bridge CFURLRef)fileURL, _frames, _frameDelayTimes, &_totalTime, &_width, &_height, _loopCount);
//    }
//    self.frame = CGRectMake(0, 0, _width, _height);
//    self.center = frameCenter;
//    self.backgroundColor = [UIColor clearColor];
//    if(_frames && _frames[0]){
//        self.layer.contents = (__bridge id)([_frames[0] CGImage]);
//    }
//}

//使用displayLink播放
//- (void)startGif
//{
//    frameIndex = 0;
//    _currentLoop = 1;
//    frameDelay =[_frameDelayTimes[0] doubleValue];
//    
//    [self stopGif];
//    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplay:)];
//    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//}
//每秒60帧刷新视图
//- (void)updateDisplay:(CADisplayLink *)link
//{
//    if(frameDelay<=0){
//        frameIndex ++;
//        if(_loopCount!=0){
//            if (_currentLoop>=_loopCount) {
//                [self stopGif];
//            }else{
//                _currentLoop ++;
//            }
//        }
//        if(frameIndex>=_frames.count){
//            frameIndex = 0;
//        }
//        frameDelay = [_frameDelayTimes[frameIndex] doubleValue]+frameDelay;
//        self.layer.contents = (__bridge id)([_frames[frameIndex] CGImage]);
//    }
//    frameDelay -= fmin(displayLink.duration, 1);   //To avoid spiral-o-death
//}

//- (void)willMoveToSuperview:(UIView *)newSuperview
//{
//    if(newSuperview){
//        [self startGif];
//    }else{
//        [self stopGif];  //视图将被移除
//    }
//}

/*
//使用Animation方式播放Gif
- (void)startGifAnimation
{
    [self stopGif];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    
    NSMutableArray *times = [NSMutableArray arrayWithCapacity:3];
    CGFloat currentTime = 0;
    NSInteger count = _frameDelayTimes.count;
    for (NSInteger i = 0; i < count; ++i) {
        [times addObject:[NSNumber numberWithFloat:(currentTime / _totalTime)]];
        currentTime += [[_frameDelayTimes objectAtIndex:i] floatValue];
    }
    [animation setKeyTimes:times];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger i = 0; i < count; ++i) {
        [images addObject:(__bridge id)[[_frames objectAtIndex:i] CGImage]];
    }
    
    [animation setValues:images];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = _totalTime;
    animation.delegate = self;
    if(_loopCount<=0){
        animation.repeatCount = INFINITY;
    }else{
        animation.repeatCount = _loopCount;
    }
    [self.layer addAnimation:animation forKey:@"gifAnimation"];
}

- (void)stopGif
{
    [self.layer removeAllAnimations];
    [self removeDisplayLink];
    
    if(_frames && _frames[0]){
        self.layer.contents = (__bridge id)([_frames[0] CGImage]);
    }
}
*/
//- (void)removeDisplayLink
//{
//    [displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    [displayLink invalidate];
//    displayLink = nil;
//}

// remove contents when animation end
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    if(_frames && _frames[0]){
//        self.layer.contents = (__bridge id)([_frames[0] CGImage]);
//    }
//}

/*
 * @brief 获取gif图中每一帧的信息
 */
+ (NSDictionary *)getGifInfo:(NSURL *)fileURL
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *delays = [NSMutableArray arrayWithCapacity:3];
    NSUInteger loopCount = 0;
    CGFloat totalTime;         // seconds
    CGFloat width = 0;
    CGFloat height = 0;
    
    getFrameInfo((__bridge CFURLRef)fileURL, frames, delays, &totalTime, &width, &height, loopCount);
    CGRect imageBounds = CGRectMake(0, 0, width, height);
    NSDictionary *gifDic = @{@"images":frames,          //图片数组
                             @"delays":delays,          //每一帧对应的延迟时间数组
                             @"duration":@(totalTime),  //GIF图播放一遍的总时间
                             @"loopCount":@(loopCount), //GIF图播放次数  0-无限播放
                             @"bounds": NSStringFromCGRect(imageBounds)}; //GIF图的宽高
    return gifDic;
}
/*
 * @brief 指定每一帧播放时长把多张图片合成gif图
 */
+ (NSString *)exportGifImages:(NSArray *)images delays:(NSArray *)delays loopCount:(NSUInteger)loopCount
{
    NSString *fileName = [@"tempGIF" stringByAppendingPathExtension:@"gif"];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:filePath],
                                                                        kUTTypeGIF, images.count, NULL);
    if(!loopCount){
        loopCount = 0;
    }
    NSDictionary *gifProperties = @{ (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @(loopCount), // 0 means loop forever
                                             }
                                     };
    float delay = 0.1; //默认每一帧间隔0.1秒
    for (int i=0; i<images.count; i++) {
        UIImage *itemImage = images[i];
        if(delays && i<delays.count){
            delay = [delays[i] floatValue];
        }
        //每一帧对应的延迟时间
        NSDictionary *frameProperties = @{(__bridge id)kCGImagePropertyGIFDictionary: @{
                                                  (__bridge id)kCGImagePropertyGIFDelayTime: @(delay), // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                                  }
                                          };
        CGImageDestinationAddImage(destination,itemImage.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifProperties);
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    return filePath;
}

/*
 * @brief resolving gif information
 */
void getFrameInfo(CFURLRef url, NSMutableArray *frames, NSMutableArray *delayTimes, CGFloat *totalTime,CGFloat *gifWidth, CGFloat *gifHeight,NSUInteger loopCount)
{
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL(url, NULL);
    
    //获取gif的帧数
    size_t frameCount = CGImageSourceGetCount(gifSource);
    
    //获取GfiImage的基本数据
    NSDictionary *gifProperties = (__bridge NSDictionary *) CGImageSourceCopyProperties(gifSource, NULL);
    //由GfiImage的基本数据获取gif数据
//    NSDictionary *gifDictionary =[gifProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary];
    //获取gif的播放次数 0-无限播放
//    loopCount = [[gifDictionary objectForKey:(NSString*)kCGImagePropertyGIFLoopCount] integerValue];
    CFRelease((__bridge CFTypeRef)(gifProperties));
    
    for (size_t i = 0; i < frameCount; ++i) {
        //得到每一帧的CGImage
        CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        [frames addObject:[UIImage imageWithCGImage:frame]];
        CGImageRelease(frame);
        
        //获取每一帧的图片信息
        NSDictionary *frameDict = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL);
        
        //获取Gif图片尺寸
        if (gifWidth != NULL && gifHeight != NULL) {
            *gifWidth = [[frameDict valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
            *gifHeight = [[frameDict valueForKey:(NSString*)kCGImagePropertyPixelHeight] doubleValue];
        }
        
        //由每一帧的图片信息获取gif信息
        NSDictionary *gifDict = [frameDict valueForKey:(NSString*)kCGImagePropertyGIFDictionary];
        //取出每一帧的delaytime
        [delayTimes addObject:[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime]];
        
        if (totalTime) {
            *totalTime = [[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime] doubleValue];
        }
        CFRelease((__bridge CFTypeRef)(frameDict));
    }
    CFRelease(gifSource);
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
@end
