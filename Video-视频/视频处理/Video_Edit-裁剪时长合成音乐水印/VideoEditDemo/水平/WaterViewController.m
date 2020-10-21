//
//  WaterViewController.m
//  VideoEditDemo
//
//  Created by hejiangshan on 17/2/6.
//  Copyright © 2017年 飞兽科技. All rights reserved.
//

#import "WaterViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface WaterViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
@property (nonatomic,strong) AVAsset *asset;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,strong) NSURL *videoUrl;
@property (nonatomic,strong) NSString *tempVideoPath;
@property (nonatomic,strong) AVAssetExportSession *exportSession;

@end

@implementation WaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tempVideoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpMov.mov"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)ImportVideoAction:(UIButton *)sender {
    UIImagePickerController *myImagePickerController = [[UIImagePickerController alloc] init];
    myImagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    myImagePickerController.mediaTypes =
    [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    myImagePickerController.delegate = self;
    myImagePickerController.editing = NO;
    [self presentViewController:myImagePickerController animated:YES completion:nil];
}

- (IBAction)addWaterAction:(UIButton *)sender {
    if (self.asset == nil) {
        return;
    }
    [self.player pause];
    //AVMutableComposition是个容器，可以在里面添加和移除视频轨和音频轨
    AVMutableComposition *composition = [[AVMutableComposition alloc] init];
    
    //媒体轨道，有音频轨和视频轨，可以插入各种素材
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //把视频数据插入到可变媒体轨道中，时间就是整个视频播放时间
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.asset.duration) ofTrack:[[self.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //这是媒体轨道中的一个视频，可以进行视频缩放和旋转等操作
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.asset.duration);
    
    //视频轨道，包含了所有的视频素材
    AVMutableVideoCompositionLayerInstruction *videoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    //视频资源轨道，包含了视频创建时间，总时长，音量等等信息
    AVAssetTrack *assetTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    
    mainInstruction.layerInstructions = [NSArray arrayWithObject:videoLayerInstruction];
    
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = assetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videoLayerInstruction setTransform:assetTrack.preferredTransform atTime:kCMTimeZero];
    [videoLayerInstruction setOpacity:0.0 atTime:self.asset.duration];

    
    AVMutableVideoComposition *mainCompositionInstrument = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(assetTrack.naturalSize.height, assetTrack.naturalSize.width);
    } else {
        naturalSize = assetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInstrument.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInstrument.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInstrument.frameDuration = CMTimeMake(1, 30);
    [self applyVideoEffectsToComposition:mainCompositionInstrument size:naturalSize];
    
    //输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"FinalVideo-%d.mov",arc4random() % 1000]];
    self.videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    //视频文件输出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=self.videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInstrument;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //输出视频之后的操作，将视频导入相册
            [self exportDidFinish:exporter];
        });
    }];
}

- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
{
    // 1 - Set up the text layer
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    [subtitle1Text setFont:@"Helvetica-Bold"];
    [subtitle1Text setFontSize:36];
    [subtitle1Text setFrame:CGRectMake(0, 0, size.width, 100)];
    [subtitle1Text setString:@"这是水印来了"];
    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
    [subtitle1Text setForegroundColor:[[UIColor redColor] CGColor]];
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitle1Text];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
}

- (void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    } else {
                        AVPlayerItem * playeritem = [AVPlayerItem playerItemWithURL:self.videoUrl];
                        [_player replaceCurrentItemWithPlayerItem:playeritem];
                        [_player play];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                });
            }];
        }
    }
}

- (void)deleteTempFile
{
    NSURL *url = [NSURL fileURLWithPath:self.tempVideoPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exist = [fm fileExistsAtPath:url.path];
    NSError *err;
    if (exist) {
        [fm removeItemAtURL:url error:&err];
        NSLog(@"file deleted");
        if (err) {
            NSLog(@"file remove error, %@", err.localizedDescription );
        }
    } else {
        NSLog(@"no file by that name");
    }
}

- (void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.asset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
    //播放视频
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:self.asset];
    
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.contentsGravity = AVLayerVideoGravityResizeAspect;
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.playerLayer.frame = self.videoView.bounds;
    
    [self.videoView.layer addSublayer:self.playerLayer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideoLayer:)];
    [self.videoView addGestureRecognizer:tap];
    
    [self.player play];
    self.isPlaying = YES;
}

- (void)tapOnVideoLayer:(UITapGestureRecognizer *)gesture
{
    if (self.isPlaying) {
        [self.player pause];
    } else {
        [self.player play];
    }
    self.isPlaying = !self.isPlaying;
}
@end
