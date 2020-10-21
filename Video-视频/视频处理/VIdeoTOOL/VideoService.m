//
//  VideoService.m
//  YouJia
//
//  Created by aa on 14-4-18.
//
//

#import "VideoService.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@implementation VideoService


#pragma mark--------------视频文件处理方法--------------------------

/*获取视频时间长度
 *@param  URL    视频存放的url
 *@return  float类型
 */
+ (CGFloat) getVideoDuration:(NSURL*) URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}

/*获取视频文件的大小
 *@param   path   视频存放的路径
 *@return   单位为kb的数值
 */
+ (NSInteger) getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[[NSFileManager alloc]init] autorelease];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue]/1024;  //返回的是kb单位的大小
    }
    return 0;
}

/*获取视频缩略图
 *@param   videoURL   视频存放的路径
 *@return   image
 */
+(UIImage *)getImage:(NSURL *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    [asset release];
    [gen release];
    return [thumb autorelease];
    
}

//获取某一帧的图片
+(UIImage *) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError * thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
    {
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    }else{
        UIImage *thumbImage = [[UIImage alloc] initWithCGImage:thumbnailImageRef];
        CGImageRelease(thumbnailImageRef);
        return thumbImage;
    }
    
    return nil;
}


#pragma mark-----------------------------------

/*用mp4编码格式进行编码
 *@param  url    原视频存放url
 *@param  encodeUrl   编码后的视频存放路径
 *@return
 */
+ (void)encodeMP4WithVideoUrl:(NSURL *)url
               outputVideoUrl:(NSString *)encodeUrl
                 blockHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                          presetName:AVAssetExportPresetMediumQuality];
    
    exportSession.outputURL = [NSURL fileURLWithPath:encodeUrl];
    exportSession.shouldOptimizeForNetworkUse = NO;
    BOOL isMp4=NO;
    for (NSString *str in exportSession.supportedFileTypes)
    {
        NSLog(@"output file type=%@",str);
        if ([str isEqualToString:AVFileTypeMPEG4]) {
            isMp4=YES;
            break;
        }
    }
    if (isMp4)
    {
        exportSession.outputFileType = AVFileTypeMPEG4;
    }
    else
    {
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    }
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        handler(exportSession);
        
        [exportSession release];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL isDeleteOk = [fm removeItemAtURL:url error:nil];
        NSLog(@"删除缓存 %d",isDeleteOk);
    }];
}


/*视频压缩并转码成mp4
 *@param   inputURL  需要压缩的视频地址
 *@param   outputURL   压缩后的视频存放地址
 *@param    handler   block模块
 */
+ (void) lowQuailtyWithInputURL:(NSURL*)inputURL
                      outputURL:(NSURL*)outputURL
                   blockHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                          presetName:AVAssetExportPresetMediumQuality];
    
    exportSession.outputURL = outputURL;
    exportSession.shouldOptimizeForNetworkUse = NO;
    BOOL isMp4=NO;
    for (NSString *str in exportSession.supportedFileTypes)
    {
        NSLog(@"output file type=%@",str);
        if ([str isEqualToString:AVFileTypeMPEG4]) {
            isMp4=YES;
            break;
        }
    }
    if (isMp4) {
        exportSession.outputFileType = AVFileTypeMPEG4;
    }
    else{
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    }
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        handler(exportSession);
        
        [exportSession release];
    }];
}

/*视频合成
 *@param  firstUrl   第一段视频的url
 *@param   secondUrl   第二段视频的url
 *@param   outputUrl   合成后视频存放的url
 *@param   size       视频size
 *
 */
+ (void)mergeVideoFromFristVideoUrl:(NSURL *)firstUrl
                     secondVideoUrl:(NSURL *)secondUrl
                 withOutputVideoUrl:(NSURL *)outputUrl
                       andVideoSize:(CGSize)size
                       blockHandler:(void (^)(AVAssetExportSession*))handler
{
    AVAsset *firstAsset = [AVAsset assetWithURL:firstUrl];
    AVAsset *secondAsset = [AVAsset assetWithURL:secondUrl];
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    //第一段视频处理
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *firstAssetTrack=[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:firstAssetTrack atTime:kCMTimeZero error:nil];
    //第二段视频处理，第二段视频插在第一段视频结束后
    AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *secondAssetTrack=[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:secondAssetTrack atTime:firstAsset.duration error:nil];
    
    AVMutableVideoCompositionInstruction *MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration));
    
    AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
    //    UIImageOrientation FirstAssetOrientation_ = UIImageOrientationUp;
    //    BOOL isFirstAssetPortrait_ = NO;
    //    CGAffineTransform firstTransform = firstAssetTrack.preferredTransform;
    //    if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0) {FirstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;}
    //    if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0) {FirstAssetOrientation_ = UIImageOrientationLeft; isFirstAssetPortrait_ = YES;}
    //    if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0) {FirstAssetOrientation_ = UIImageOrientationUp;}
    //    if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0) {FirstAssetOrientation_ = UIImageOrientationDown;}
    //    CGFloat FirstAssetScaleToFitRatio = 320.0 / firstAssetTrack.naturalSize.width;
    //    if(isFirstAssetPortrait_) {
    //        FirstAssetScaleToFitRatio = 320.0 / firstAssetTrack.naturalSize.height;
    //        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
    //        [FirstlayerInstruction setTransform:CGAffineTransformConcat(firstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
    //    } else {
    //        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
    //        [FirstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(firstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
    //    }
    [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
    
    AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
    //    UIImageOrientation SecondAssetOrientation_ = UIImageOrientationUp;
    //    BOOL isSecondAssetPortrait_ = NO;
    //    CGAffineTransform secondTransform = secondAssetTrack.preferredTransform;
    //    if(secondTransform.a == 0 && secondTransform.b == 1.0 && secondTransform.c == -1.0 && secondTransform.d == 0) {SecondAssetOrientation_= UIImageOrientationRight; isSecondAssetPortrait_ = YES;}
    //    if(secondTransform.a == 0 && secondTransform.b == -1.0 && secondTransform.c == 1.0 && secondTransform.d == 0) {SecondAssetOrientation_ = UIImageOrientationLeft; isSecondAssetPortrait_ = YES;}
    //    if(secondTransform.a == 1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == 1.0) {SecondAssetOrientation_ = UIImageOrientationUp;}
    //    if(secondTransform.a == -1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == -1.0) {SecondAssetOrientation_ = UIImageOrientationDown;}
    //    CGFloat SecondAssetScaleToFitRatio = 320.0 / secondAssetTrack.naturalSize.width;
    //    if(isSecondAssetPortrait_) {
    //        SecondAssetScaleToFitRatio = 320.0 / secondAssetTrack.naturalSize.height;
    //        CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
    //        [SecondlayerInstruction setTransform:CGAffineTransformConcat(secondAssetTrack.preferredTransform, SecondAssetScaleFactor) atTime:firstAsset.duration];
    //    } else {
    //        ;
    //        CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
    //        [SecondlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(secondAssetTrack.preferredTransform, SecondAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:firstAsset.duration];
    //    }
    
    MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,SecondlayerInstruction, nil];;
    
    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
    MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
    MainCompositionInst.frameDuration = CMTimeMake(1, 30);
    MainCompositionInst.renderSize = size;
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                           presetName:AVAssetExportPresetMediumQuality];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:outputUrl.path]) {  //如果文件存在，先移除
        [fm removeItemAtURL:outputUrl error:nil];
    }
    
    //输出成影片格式
    exportSession.outputURL = outputUrl;
    exportSession.shouldOptimizeForNetworkUse = NO;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.videoComposition = MainCompositionInst;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        handler(exportSession);
        
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtURL:firstUrl error:nil];
        [fm removeItemAtURL:secondUrl error:nil];
        
        [exportSession release];
    }];
}


/*视频添加水印
 *@param  videoUrl   视频的url
 *@param   img        水印图片
 *@param   outputPath   处理后视频存放的路径
 *@param   size       视频size
 *@param   imgRect    水印图片在视频中的位置
 *
 */
+ (void) loadVideoByUrl:(NSURL *)videoUrl
           andOutputUrl:(NSString *)outputPath
               andImage:(UIImage *)img
           andVideoSize:(CGSize)size
             andImgRect:(CGRect)imgRect
           blockHandler:(void (^)(AVAssetExportSession*))handler
{
    AVAsset *avAsset = [AVAsset assetWithURL:videoUrl];
    CMTime assetTime = [avAsset duration];
    Float64 duration = CMTimeGetSeconds(assetTime);
    NSLog(@"视频时长 %f\n",duration);
    
    AVMutableComposition *avMutableComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *avMutableCompositionTrack =[avMutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *avAssetTrack = [[avAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize videoSize=CGSizeMake([avAssetTrack naturalSize].height, [avAssetTrack naturalSize].width);
    NSLog(@"videoWidth=%f   videoHeight=%f",videoSize.width,videoSize.height);
    NSError *error = nil;
    // 这块是裁剪,rangtime .前面的是开始时间,后面是裁剪多长
    [avMutableCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration, 30))
                                       ofTrack:avAssetTrack
                                        atTime:kCMTimeZero
                                         error:&error];
    //音频
    AVMutableCompositionTrack *audioCompositionTrack =[avMutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    NSArray *audioSetList=[avAsset tracksWithMediaType:AVMediaTypeAudio];
    if ([audioSetList count]>0) {  //避免用户拍摄没有声音的视频
        AVAssetTrack *audioAssetTrack = [[avAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration, 30))
                                       ofTrack:audioAssetTrack
                                        atTime:kCMTimeZero
                                         error:&error];
    }
    
    AVMutableVideoComposition *avMutableVideoComposition = [AVMutableVideoComposition videoComposition];
    avMutableVideoComposition.renderSize = videoSize;
    avMutableVideoComposition.frameDuration = CMTimeMake(1, 30);
    
  
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    if(img)
    {
        CALayer *waterMarkLayer = [CALayer layer];
        waterMarkLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
        waterMarkLayer.contents = (id)img.CGImage;
        [parentLayer addSublayer:waterMarkLayer];
    }
   
    avMutableVideoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    AVMutableVideoCompositionInstruction *avMutableVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    [avMutableVideoCompositionInstruction setTimeRange:CMTimeRangeMake(kCMTimeZero, [avMutableComposition duration])];
    
    AVMutableVideoCompositionLayerInstruction *avMutableVideoCompositionLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:avAssetTrack];
    [avMutableVideoCompositionLayerInstruction setTransform:avAssetTrack.preferredTransform atTime:kCMTimeZero];
    
    avMutableVideoCompositionInstruction.layerInstructions = [NSArray arrayWithObject:avMutableVideoCompositionLayerInstruction];
    
    
    avMutableVideoComposition.instructions = [NSArray arrayWithObject:avMutableVideoCompositionInstruction];
    
    
    NSFileManager *fm = [NSFileManager defaultManager] ;
    if ([fm fileExistsAtPath:outputPath]) {
        NSLog(@"video is have. then delete that");
        if ([fm removeItemAtPath:outputPath error:&error]) {
            NSLog(@"delete is ok");
        }else {
            NSLog(@"delete is no error = %@",error.description);
        }
    }
    
    AVAssetExportSession *avAssetExportSession = [[AVAssetExportSession alloc] initWithAsset:avMutableComposition presetName:AVAssetExportPresetMediumQuality];
    [avAssetExportSession setVideoComposition:avMutableVideoComposition];
    [avAssetExportSession setOutputURL:[NSURL fileURLWithPath:outputPath]];
    BOOL isMp4=NO;
    for (NSString *str in avAssetExportSession.supportedFileTypes)
    {
        NSLog(@"output file type=%@",str);
        if ([str isEqualToString:AVFileTypeMPEG4]) {
            isMp4=YES;
            break;
        }
    }
    if (isMp4) {
        avAssetExportSession.outputFileType = AVFileTypeMPEG4;
    }
    else{
        avAssetExportSession.outputFileType = AVFileTypeQuickTimeMovie;
    }
    [avAssetExportSession setShouldOptimizeForNetworkUse:NO];
    [avAssetExportSession exportAsynchronouslyWithCompletionHandler:^(void){
        handler(avAssetExportSession);  //通过block的方式给其他页面处理
        
        [avAssetExportSession release];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL isDeleteOk = [fm removeItemAtURL:videoUrl error:nil];
        NSLog(@"删除缓存 %d",isDeleteOk);
    }];
}

@end
