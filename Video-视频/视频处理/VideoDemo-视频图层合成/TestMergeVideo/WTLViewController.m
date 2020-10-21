//
//  WTLViewController.m
//  TestMergeVideo
//
//  Created by zang qilong on 14/8/25.
//  Copyright (c) 2014年 Worktile. All rights reserved.
//

#import "WTLViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface WTLViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSURL *videoURL;
    AVURLAsset *firstAsset;
    AVURLAsset *secondAsset;
    AVMutableVideoComposition *mainComposition;
    AVMutableComposition *mixComposition;
}
@property (nonatomic, strong) UIImagePickerController *picker;
@end

@implementation WTLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)openLibrary:(id)sender
{
    _picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    self.picker.allowsEditing = YES;
    self.picker.delegate = self;
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)mergeVideo:(id)sender
{
    if (videoURL!= nil) {
        
        /* 合成视频套路就是下面几条，跟着走就行了，具体函数意思自行google
         1.不用说，肯定加载。用ASSET
         2.这里不考虑音轨，所以只获取video信息。用track 获取asset里的视频信息，一共两个track,一个track是你自己拍的视频，第二个track是特效视频,因为两个视频需要同时播放，所以起始时间相同，都是timezero,时长自然是你自己拍的视频时长。然后把两个track都放到mixComposition里。
         3.第三步就是最重要的了。instructionLayer,看字面意思也能看个七七八八了。架构图层，就是告诉系统，等下合成视频，视频大小，方向，等等。这个地方就是合成视频的核心。我们只需要更改透明度就行了，把特效track的透明度改一下，让他能显示底下你自己拍的视屏图层就行了。
         4.
        **/
        NSLog(@"First Asset = %@",firstAsset);
        
        // 1
        firstAsset = [AVAsset assetWithURL:videoURL];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"rain" ofType:@"mp4"];
        NSLog(@"path is %@",path);
        
        secondAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:path] options:nil];
        NSLog(@"second Asset = %@",secondAsset);
        
        
        //second Video
        
        //secondAsset = [AVAsset assetWithURL:videoTwoURL];
    }
    if (firstAsset != nil && secondAsset != nil) {
        
        // 2.
        mixComposition = [[AVMutableComposition alloc] init];
        
        // create first track
        AVMutableCompositionTrack *firstTrack =
        [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                    preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration)
                            ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                             atTime:kCMTimeZero
                              error:nil];
        
        //create second track
        
        AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration)
                             ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                              atTime:kCMTimeZero
                               error:nil];
        
        

        // 3.
        AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        
    
        CMTime finalDuration;
        CMTime result;
        // 判断时长，其实这段没用，时长直接用自己拍的视频时长就行了。
        NSLog(@"values =%f and %f",CMTimeGetSeconds(firstAsset.duration),CMTimeGetSeconds(secondAsset.duration));
        
        if (CMTimeGetSeconds(firstAsset.duration) == CMTimeGetSeconds(secondAsset.duration)) {
            
            finalDuration = firstAsset.duration;
            
        }else if (CMTimeGetSeconds(firstAsset.duration) > CMTimeGetSeconds(secondAsset.duration)) {
            
            finalDuration = firstAsset.duration;
            result = CMTimeSubtract(firstAsset.duration, secondAsset.duration);
            
        }else {
            
            finalDuration = secondAsset.duration;
            result = CMTimeSubtract(secondAsset.duration, firstAsset.duration);
            
        }
        
        
        mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,finalDuration);
        
        // 第一个视频的架构层
        
        AVMutableVideoCompositionLayerInstruction *firstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        
        [firstlayerInstruction setTransform:CGAffineTransformIdentity atTime:kCMTimeZero];
        
         // 第二个视频的架构层
        
        AVMutableVideoCompositionLayerInstruction *secondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
        
        [secondlayerInstruction setOpacityRampFromStartOpacity:0.7 toEndOpacity:0.2 timeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration)];
        
        [secondlayerInstruction setTransform:CGAffineTransformIdentity atTime:kCMTimeZero];
        
       
        // 这个地方你把数组顺序倒一下，视频上下位置也跟着变了。
        mainInstruction.layerInstructions = [NSArray arrayWithObjects:secondlayerInstruction,firstlayerInstruction, nil];
        
        
        mainComposition = [AVMutableVideoComposition videoComposition];
        mainComposition.instructions = [NSArray arrayWithObjects:mainInstruction,nil];
        mainComposition.frameDuration = CMTimeMake(1, 30);
        mainComposition.renderSize = CGSizeMake(320, 240);
        
        //  导出路径
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                                 [NSString stringWithFormat:@"mergeVideo.mov"]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:myPathDocs error:NULL];
        
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        
        NSLog(@"URL:-  %@", [url description]);
        
        //导出
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        
        exporter.outputURL = url;
        
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        
        exporter.shouldOptimizeForNetworkUse = YES;
        
        exporter.videoComposition = mainComposition;
        
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self exportDidFinish:exporter];
                
            });
        }];
        
    }else {
        
     
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错!" message:@"选择视频"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    

}

-(void)exportDidFinish:(AVAssetExportSession*)session {
    
    NSLog(@"exportDidFinish");

    NSLog(@"session = %d",(int)session.status);
    if (session.status == AVAssetExportSessionStatusCompleted) {
        
        NSURL *outputURL = session.outputURL;
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL])  {
            
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (error) {
                        
                       
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"存档失败"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                    }else {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                        message:@"存档成功"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                       
                        [alert show];
                        
                       
                        
                    }
                    
                    
                });
            }];
            
        }
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"存档失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}


@end
