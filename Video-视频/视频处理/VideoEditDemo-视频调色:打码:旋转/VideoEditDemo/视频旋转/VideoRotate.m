//
//  VideoRotate.m
//  VideoEditDemo
//
//  Created by JSB-hejiamin on 2018/3/14.
//  Copyright © 2018年 JSB-hejiamin. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "VideoRotate.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )


@implementation VideoRotate



- (void)exportWithAsset:(AVAsset *)asset completion:(void(^)(NSError * error))completion
{
    // Step 1
    // Create an outputURL to which the exported movie will be saved
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *outputURL = paths[0];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    outputURL = [outputURL stringByAppendingPathComponent:@"output.mp4"];
    // Remove Existing File
    [manager removeItemAtPath:outputURL error:nil];

    // Step 2
    // Create an export session with the composition and write the exported movie to the photo library
//    if (@available(iOS 11.0, *)) {
//        //iOS11 使用H.265压缩编码
//        self.exportSession = [[AVAssetExportSession alloc] initWithAsset:[self.mutableComposition copy] presetName:AVAssetExportPresetHEVCHighestQuality];
//    }else{
    self.exportSession = [[AVAssetExportSession alloc] initWithAsset:[self.mutableComposition copy] presetName:AVAssetExportPresetHighestQuality];
        
   // }

    self.exportSession.videoComposition = self.mutableVideoComposition;
    self.exportSession.outputURL = [NSURL fileURLWithPath:outputURL];
    self.exportSession.outputFileType=AVFileTypeQuickTimeMovie;
    [self.exportSession exportAsynchronouslyWithCompletionHandler:^(void){
        
        switch (self.exportSession.status) {
            case AVAssetExportSessionStatusCompleted:
                [self writeVideoToPhotoLibrary:[NSURL fileURLWithPath:outputURL]];
                // Step 3
                // Notify AVSEViewController about export completion
                completion(self.exportSession.error);
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"Failed:%@",self.exportSession.error);
                completion(self.exportSession.error);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Canceled:%@",self.exportSession.error);
                completion(self.exportSession.error);
                break;
            default:
                break;
        }
    }];
}


- (void)writeVideoToPhotoLibrary:(NSURL *)url
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            NSLog(@"Video could not be saved");
        }
    }];
}

- (void)videoChangeRotateWithAsset:(AVAsset*)asset Rotate:(VideoRotateEnum)degrees completion:(void(^)(CGAffineTransform transform))completion
{

    
    AVMutableVideoCompositionInstruction *instruction = nil;
    AVMutableVideoCompositionLayerInstruction *layerInstruction = nil;
    CGAffineTransform translateToCenter;
    CGAffineTransform mixedTransform = CGAffineTransformIdentity;
    CGAffineTransform reslutTransfrom;
    CGSize renderSize = CGSizeZero;

    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    // Check if the asset contains video and audio tracks
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    CMTime insertionPoint = kCMTimeZero;
    NSError *error = nil;
    
    
    if (!self.mutableComposition) {
        self.mutableComposition = [AVMutableComposition composition];
        if (assetVideoTrack != nil) {
            AVMutableCompositionTrack *compositionVideoTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetVideoTrack atTime:insertionPoint error:&error];
        }
        if (assetAudioTrack != nil) {
            AVMutableCompositionTrack *compositionAudioTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetAudioTrack atTime:insertionPoint error:&error];
        }
    }
    
    switch (degrees) {
        case VideoRotate0:{
            ///默认角度
            NSLog(@"默认角度");
            mixedTransform = CGAffineTransformIdentity;
            reslutTransfrom = CGAffineTransformMake(mixedTransform.a, mixedTransform.b, mixedTransform.c, mixedTransform.d, 0, 0);
            renderSize = CGSizeMake(assetVideoTrack.naturalSize.width,assetVideoTrack.naturalSize.height);
        }
            break;
        case VideoRotate90:{
            
            //顺时针旋转90°
            NSLog(@"视频旋转90度,home按键在左");
            translateToCenter = CGAffineTransformMakeTranslation(assetVideoTrack.naturalSize.height,0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
            reslutTransfrom = CGAffineTransformMake(mixedTransform.a, mixedTransform.b, mixedTransform.c, mixedTransform.d, 0, 0);
            renderSize = CGSizeMake(assetVideoTrack.naturalSize.height,assetVideoTrack.naturalSize.width);
            
        }
            break;
        case VideoRotate180:{
            //顺时针旋转180°
            NSLog(@"视频旋转180度，home按键在上");
            translateToCenter = CGAffineTransformMakeTranslation(assetVideoTrack.naturalSize.width, assetVideoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
            reslutTransfrom = CGAffineTransformMake(mixedTransform.a, mixedTransform.b , mixedTransform.c, mixedTransform.d, 0, 0);
            renderSize = CGSizeMake(assetVideoTrack.naturalSize.width,assetVideoTrack.naturalSize.height);
            
        }
            break;
        case VideoRotate270:{
            //顺时针旋转270°
            NSLog(@"视频旋转270度，home按键在右");
            translateToCenter = CGAffineTransformMakeTranslation(0.0, assetVideoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
            reslutTransfrom = CGAffineTransformMake(mixedTransform.a, mixedTransform.b, mixedTransform.c, mixedTransform.d, 0, 0);
            renderSize = CGSizeMake(assetVideoTrack.naturalSize.height,assetVideoTrack.naturalSize.width);
            
        }
            break;
        default:{
            NSLog(@"默认角度");
            mixedTransform = CGAffineTransformIdentity;
            reslutTransfrom = CGAffineTransformMake(mixedTransform.a, mixedTransform.b, mixedTransform.c, mixedTransform.d, 0, 0);
            renderSize = CGSizeMake(assetVideoTrack.naturalSize.width,assetVideoTrack.naturalSize.height);
        }
            break;
    }
    
    
    if (!self.mutableVideoComposition) {
        
        // Create a new video composition
        self.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
        self.mutableVideoComposition.renderSize = renderSize;
        self.mutableVideoComposition.frameDuration = CMTimeMake(1, 30);
        
        // The rotate transform is set on a layer instruction
        instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [self.mutableComposition duration]);
        layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:(self.mutableComposition.tracks)[0]];
        [layerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        
    } else {
        self.mutableVideoComposition.renderSize = renderSize;
        
        // Extract the existing layer instruction on the mutableVideoComposition
        instruction = (AVMutableVideoCompositionInstruction *)(self.mutableVideoComposition.instructions)[0];
        layerInstruction = (AVMutableVideoCompositionLayerInstruction *)(instruction.layerInstructions)[0];
        CGAffineTransform existingTransform;
        
        if (![layerInstruction getTransformRampForTime:[self.mutableComposition duration] startTransform:&existingTransform endTransform:NULL timeRange:NULL]) {
            [layerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        }else{
            
            [layerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        }
    }
    instruction.layerInstructions = @[layerInstruction];
    self.mutableVideoComposition.instructions = @[instruction];
    completion(reslutTransfrom);
}






@end
