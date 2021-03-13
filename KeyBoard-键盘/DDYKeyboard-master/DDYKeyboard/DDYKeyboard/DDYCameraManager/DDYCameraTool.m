#import "DDYCameraTool.h"

@implementation DDYCameraTool

#pragma mark 转码压缩
+ (void)ddy_CompressVideo:(NSURL *)videoURL presetName:(NSString *)presetName saveURL:(NSURL *)saveURL progress:(void (^)(CGFloat))progress complete:(void (^)(NSError *))complete {
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSArray *presetsArray = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    
    void (^compress)(NSString *) = ^(NSString *effectPresetName) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:effectPresetName];
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputURL = saveURL;
        NSArray *fileTypesArray = exportSession.supportedFileTypes;
        if ([fileTypesArray containsObject:AVFileTypeMPEG4]) {
            exportSession.outputFileType = AVFileTypeMPEG4;
        } else if (fileTypesArray.count > 0) {
            exportSession.outputFileType = [fileTypesArray objectAtIndex:0];
        }
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                    if (complete) complete(nil);
                } else if (exportSession.status == AVAssetExportSessionStatusFailed) {
                    if (complete) complete(exportSession.error);
                } else {
                    if (progress) progress(exportSession.progress);
                }
            });
        }];
    };
    
    if ([presetsArray containsObject:presetName]) {
        compress(presetName);
    } else if ([presetsArray containsObject:AVAssetExportPresetMediumQuality]) {
        compress(AVAssetExportPresetMediumQuality);
    }
}

#pragma mark 截取缩略图
+ (UIImage *)ddy_ThumbnailImageInVideo:(NSURL *)videoURL andTime:(CGFloat)time {
    AVURLAsset *videoAsset = [AVURLAsset assetWithURL:videoURL];
    AVAssetImageGenerator *imgGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:videoAsset];
    imgGenerator.appliesPreferredTrackTransform = YES;
    CMTime requestTime = CMTimeMakeWithSeconds(time, 600);
    CMTime actualTime;
    NSError *error;
    CGImageRef cgImage = [imgGenerator copyCGImageAtTime:requestTime actualTime:&actualTime error:&error];
    if (error) {
        return nil;
    }
    CMTimeShow(actualTime);
    UIImage *thumbnailImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return thumbnailImage;
}

#pragma mark 添加背景音乐
+ (void)ddy_AddMusicInVideo:(NSURL *)videoPath music:(NSURL *)musicPath keepOrignalSound:(BOOL)isKeep complete:(void (^)(NSURL *))complete {
    
}

-(void)videoCompression{
    
    NSLog(@"begin");
    NSURL *tempurl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.mov"]];
    //加载视频资源
    AVAsset *asset = [AVAsset assetWithURL:tempurl];
    //创建视频资源导出会话
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    //创建导出视频的URL
    session.outputURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tempLow.mov"]];
    //必须配置输出属性
    session.outputFileType = @"com.apple.quicktime-movie";
    //导出视频
    [session exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"end");
    }];
    
}


@end
