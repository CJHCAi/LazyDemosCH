//
//  ViewController.m
//  ICGVideoTrimmer
//
//  Created by HuongDo on 1/15/15.
//  Copyright (c) 2015 ichigo. All rights reserved.
//

#import "ViewController.h"
#import "ICGVideoTrimmerView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ICGVideoTrimmerDelegate>

@property (assign, nonatomic) BOOL isPlaying;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@property (weak, nonatomic) IBOutlet UIButton *trimButton;
@property (weak, nonatomic) IBOutlet UIView *videoPlayer;
@property (weak, nonatomic) IBOutlet UIView *videoLayer;

@property (strong, nonatomic) NSString *tempVideoPath;
@property (strong, nonatomic) AVAssetExportSession *exportSession;

@property (weak, nonatomic) IBOutlet ICGVideoTrimmerView *trimmerView;
@property (strong, nonatomic) AVAsset *asset;
@property (strong, nonatomic) NSTimer *playbackTimeCheckerTimer;
@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat stopTime;
@property (assign, nonatomic) CGFloat videoPlayCurrenTime;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tempVideoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpMov.mov"];
}

- (IBAction)selectAsset:(id)sender{
    UIImagePickerController *myImagePickerController = [[UIImagePickerController alloc] init];
    myImagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    myImagePickerController.mediaTypes =
    [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    myImagePickerController.delegate = self;
    myImagePickerController.editing = NO;
    [self presentViewController:myImagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    self.asset = [AVAsset assetWithURL:url];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:self.asset];
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.contentsGravity = AVLayerVideoGravityResizeAspect;
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [self.videoLayer.layer addSublayer:self.playerLayer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideoLayer:)];
    [self.videoLayer addGestureRecognizer:tap];
    
    
    [self tapOnVideoLayer:tap];
    [self.trimButton setHidden:NO];
    
    // 设置属性为微调视图
    [self.trimmerView setThemeColor:[UIColor lightGrayColor]];
    [self.trimmerView setAsset:self.asset];
    [self.trimmerView setShowsRulerView:YES];
    [self.trimmerView setTrackerColor:[UIColor cyanColor]];
    [self.trimmerView setDelegate:self];
    // 重要:重置子视图
    [self.trimmerView resetSubviews];
    
}


- (void)viewDidLayoutSubviews{
    self.playerLayer.frame = CGRectMake(0, 0, self.videoLayer.frame.size.width, self.videoLayer.frame.size.height);
}

- (void)tapOnVideoLayer:(UITapGestureRecognizer *)tap{
    if (self.isPlaying) {
        [self.player pause];
        [self stopPlaybackTimeChecker];
    }else {
        [self.player play];
        [self startPlaybackTimeChecker];
    }
    self.isPlaying = !self.isPlaying;
    [self.trimmerView hideTracker:!self.isPlaying];
}


#pragma mark - ICGVideoTrimmerDelegate
- (void)trimmerView:(ICGVideoTrimmerView *)trimmerView didChangeLeftPosition:(CGFloat)startTime rightPosition:(CGFloat)endTime{
    if (startTime != self.startTime){
        [self seekVideoToPos:startTime];
    }
    self.startTime = startTime;
    self.stopTime = endTime;
}

//开始播放时间检查
- (void)startPlaybackTimeChecker{
    [self stopPlaybackTimeChecker];
    self.playbackTimeCheckerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onPlaybackTimeCheckerTimer) userInfo:nil repeats:YES];
}
/**停止时间检查*/
- (void)stopPlaybackTimeChecker{
    if (self.playbackTimeCheckerTimer) {
        [self.playbackTimeCheckerTimer invalidate];
        self.playbackTimeCheckerTimer = nil;
    }
}

/**CheckerTimer*/
- (void)onPlaybackTimeCheckerTimer{
    self.videoPlayCurrenTime = CMTimeGetSeconds([self.player currentTime]);
    [self.trimmerView seekToTime:CMTimeGetSeconds([self.player currentTime])];
    if (self.videoPlayCurrenTime >= self.stopTime) {
        self.videoPlayCurrenTime = self.startTime;
        [self seekVideoToPos: self.startTime];
        [self.trimmerView seekToTime:self.startTime];
    }
}

- (void)seekVideoToPos:(CGFloat)pos{
    self.videoPlayCurrenTime = pos;
    CMTime time = CMTimeMakeWithSeconds(self.videoPlayCurrenTime, self.player.currentTime.timescale);
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma mark - Actions
//删除临时文件
- (void)deleteTempFile{
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

- (IBAction)trimVideo:(id)sender{
    [self deleteTempFile];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:self.asset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        
        self.exportSession = [[AVAssetExportSession alloc]
                              initWithAsset:self.asset presetName:AVAssetExportPresetPassthrough];
        // Implementation continues.实现持续
        NSURL *furl = [NSURL fileURLWithPath:self.tempVideoPath];
        
        self.exportSession.outputURL = furl;
        self.exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
        CMTime start = CMTimeMakeWithSeconds(self.startTime, self.asset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(self.stopTime - self.startTime, self.asset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        self.exportSession.timeRange = range;
        
        [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([self.exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    
                    NSLog(@"Export failed: %@", [[self.exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    
                    NSLog(@"Export canceled");
                    break;
                default:
                    NSLog(@"NONE");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSURL *movieUrl = [NSURL fileURLWithPath:self.tempVideoPath];
                        UISaveVideoAtPathToSavedPhotosAlbum([movieUrl relativePath], self,@selector(video:didFinishSavingWithError:contextInfo:), nil);
                    });
                    
                    break;
            }
        }];
        
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

@end
