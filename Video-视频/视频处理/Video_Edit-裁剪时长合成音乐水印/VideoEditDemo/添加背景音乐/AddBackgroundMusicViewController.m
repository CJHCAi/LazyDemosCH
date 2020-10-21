//
//  AddBackgroundMusicViewController.m
//  VideoEditDemo
//
//  Created by hejiangshan on 17/2/7.
//  Copyright © 2017年 飞兽科技. All rights reserved.
//

#import "AddBackgroundMusicViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AddBackgroundMusicViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) AVAsset *asset;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
@property (nonatomic,assign) BOOL isPlaying;

@end

@implementation AddBackgroundMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)importVideoAction:(UIButton *)sender {
    UIImagePickerController *myImagePickerController = [[UIImagePickerController alloc] init];
    myImagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    myImagePickerController.mediaTypes =
    [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    myImagePickerController.delegate = self;
    myImagePickerController.editing = NO;
    [self presentViewController:myImagePickerController animated:YES completion:nil];
    
}


- (IBAction)addBackgroundMusicAction:(UIButton *)sender {
    if (self.asset == nil) {
        return;
    }
    
    //合成之后的输出路径
    NSString *outPutPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
    //混合后的视频输出路径
    NSURL *outPutUrl = [NSURL fileURLWithPath:outPutPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outPutPath error:nil];
    }
    //可变音视频组合
    AVMutableComposition *composition = [AVMutableComposition composition];
    //视频时间
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, self.asset.duration);
    
    //可变视频轨
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *videoAssetTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    //把素材轨道添加到可变的视频轨道中去
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    
    
    //声音采集
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"当我遇上你" ofType:@"mp3"]] options:nil];
    //音频轨道
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频采集通道
    AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:videoTimeRange ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction * mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.asset.duration);
    
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
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
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:self.asset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition * mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    //防止合成后的视频旋转90度
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    //创建输出
    AVAssetExportSession * assetExport = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    assetExport.outputURL = outPutUrl;//输出路径
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;//输出类型
    assetExport.shouldOptimizeForNetworkUse = YES;
    assetExport.videoComposition = mainCompositionInst;
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:assetExport];
        });
    }];
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
                        AVPlayerItem * playeritem = [AVPlayerItem playerItemWithURL:outputURL];
                        [_player replaceCurrentItemWithPlayerItem:playeritem];
                        [_player play];
                        
                    }
                });
            }];
        }
    }
}

@end
