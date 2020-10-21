//
//  VideoEditingController.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/18.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "VideoEditingController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoPlayingView.h"
#import "SpeedFreezesOperatingView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SpeedMultipleView.h"
#import "FullScreemDisplayController.h"

const char kOrientation;

@interface VideoEditingController () <SpeedFreezesOperatingViewDelegate, SpeedMultipleViewDelegate>
@property (weak, nonatomic) IBOutlet VideoPlayingView *videoPlayerView;
@property (weak, nonatomic) IBOutlet UIView *videoTrimmerHolderView;
@property (weak, nonatomic) IBOutlet UIView *speedMultipleHolderView;
@property (weak, nonatomic) IBOutlet UIButton *videoRangeButton;
@property (weak, nonatomic) IBOutlet UIButton *videoSpeedButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoPlayerViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoRangeButtonLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoSpeedButtonTrailingConstraint;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *sizeAdaptiveConstraints;

@property (weak, nonatomic) IBOutlet UIView *prepareMaskView;
@property (strong, nonatomic) UIBarButtonItem *rightTopButton;

@property (strong, nonatomic) NSURL *assetUrl;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) AVPlayer *player;

@property (strong, nonatomic) SpeedFreezesOperatingView *operatingView;
@property (assign, nonatomic) double speedRate;
@property (assign, nonatomic) BOOL speedOperatingEffected;//默认为YES
@end

@implementation VideoEditingController

- (instancetype)initWithAssetUrl:(NSURL *)assetUrl {
    self = [super init];
    if (self)
    {
        _assetUrl = assetUrl;
        _playerItem = [[AVPlayerItem alloc] initWithURL:assetUrl];
    }
    return self;
}

- (instancetype)initWithPlayItem:(AVPlayerItem *)playItem {
    self = [super init];
    if (self) {
        _playerItem = playItem;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self modifyStatusBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readyToTrim];
    if (_player != nil) {
        [_player play];
    }
    //不提前显示两个BarButtonItem
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.prepareMaskView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //屏幕适配
    [self screenAdaptation];
    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice]performSelector:@selector(setOrientation:)
                                      withObject:@(UIInterfaceOrientationLandscapeRight)];
    }
    
    self.speedOperatingEffected = YES;
    _prepareMaskView.hidden = NO;
    [self registerNotification];
    [self modifyNavigationBar];
    [self configureSpeedMultipleView];
    [self readyToPlay];
}

- (void)screenAdaptation {
    //Orientation
    AVCaptureVideoOrientation videoOrientation = [objc_getAssociatedObject(self.assetUrl, &kOrientation) integerValue];
    if (videoOrientation == AVCaptureVideoOrientationPortrait) {
        //        [_videoPlayerView setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        self.videoPlayerViewWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width * 0.4;
    } else if (videoOrientation == AVCaptureVideoOrientationLandscapeLeft || videoOrientation == AVCaptureVideoOrientationLandscapeRight) {
        //        [_videoPlayerView setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        self.videoPlayerViewWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width * 0.8;
    }
    
    //xib按iphone6P size设计
    CGFloat adaptationScale = 1.f;
    CGFloat contentFontSize = 15.f;
    if ([UIScreen mainScreen].bounds.size.height == 480) {//i4
        adaptationScale = 0.75f;
        contentFontSize = 14.f;
        _videoRangeButtonLeadingConstraint.constant = 20.f;
        _videoSpeedButtonTrailingConstraint.constant = 20.f;
    } else if ([UIScreen mainScreen].bounds.size.height == 568) {//i5
        adaptationScale = 0.8f;
        contentFontSize = 15.f;
        _videoRangeButtonLeadingConstraint.constant = 20.f;
        _videoSpeedButtonTrailingConstraint.constant = 20.f;
    } else if ([UIScreen mainScreen].bounds.size.height == 667){//6
        adaptationScale = 1.0f;
        contentFontSize = 16.f;
    } else {
        return;
    }
    
    for (NSLayoutConstraint *constraint in _sizeAdaptiveConstraints) {
        constraint.constant = adaptationScale * constraint.constant;
    }
    
    _videoRangeButton.titleLabel.font = [UIFont systemFontOfSize:contentFontSize];
    _videoSpeedButton.titleLabel.font = [UIFont systemFontOfSize:contentFontSize];
}
/**设置导航*/
- (void)modifyNavigationBar {
    
    //禁用右滑返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    self.navigationController.navigationBar.translucent = NO;
    self.rightTopButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightTopButton:)];
    self.navigationItem.rightBarButtonItem = _rightTopButton;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)modifyStatusBar {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)readyToPlay {
    if (_playerItem == nil) {
        NSLog(@"ERROR: 读取播放资源错误");
    }
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    [_videoPlayerView setPlayer:_player];
}

- (void)readyToTrim {
    //放在autoLayout计算后执行
    if (nil != _operatingView) {
        return;
    }
    CGFloat operatingViewWidth = _videoTrimmerHolderView.frame.size.width;
    CGFloat operatingViewHeight = _videoTrimmerHolderView.frame.size.height;
    
    self.operatingView = [[SpeedFreezesOperatingView alloc] initWithFrame:CGRectMake(0, 0, operatingViewWidth, operatingViewHeight) videoUrl:_assetUrl];
    _operatingView.delegate = self;
    [self.videoTrimmerHolderView addSubview:_operatingView];
}

- (void)playerItemDidEnd:(NSNotification *)notify {
    [_player seekToTime:CMTimeMake(0, 1)];
}

- (void)configureSpeedMultipleView {
    SpeedMultipleView *multipleView = [SpeedMultipleView createView];
    multipleView.delegate = self;
    NSDictionary *views = NSDictionaryOfVariableBindings(multipleView);
    [multipleView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.speedMultipleHolderView addSubview:multipleView];
    [self.speedMultipleHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[multipleView]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.speedMultipleHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[multipleView]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
}
/**视频的速度改变 长度剪辑*/
- (void)speedFreezingWithAssetUrl:(NSURL *)URl beginTime:(CMTime)beginTime endTime:(CMTime)endTime replaceSoundEffect:(AVAsset *)replaceSoundEffect {
    AVURLAsset* videoAsset = [AVURLAsset URLAssetWithURL:URl options:nil]; //self.inputAsset;
    AVAsset *exportAsset = videoAsset;
    CMTime extraTime = kCMTimeZero;//变速后，时长差
    
    
    
    //--------------------分隔线内可以抽取--------------------
    //todo 这块可以抽出去
    if (_speedOperatingEffected) {
    //    AVAsset *currentAsset = [AVAsset assetWithURL:URl];
        AVAssetTrack *vdoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        //create mutable composition
        AVMutableComposition *mixComposition = [AVMutableComposition composition];
        
        AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        //slow down whole video by 2.0
        double videoScaleFactor = _speedRate;
        
        CMTime remainDuration = CMTimeSubtract(endTime, beginTime);
        CMTime operatedTime = CMTimeMake(remainDuration.value * videoScaleFactor, remainDuration.timescale);
        extraTime = CMTimeSubtract(operatedTime, remainDuration);
        
        //video insert
        NSError *videoInsertError = nil;
        BOOL videoInsertResult = [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                                                ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                                                 atTime:kCMTimeZero
                                                                  error:&videoInsertError];
        if (!videoInsertResult || nil != videoInsertError) {
            //handle error
            NSLog(@"ERROR: %@", videoInsertError);
            return;
        }
        [compositionVideoTrack scaleTimeRange:CMTimeRangeMake(beginTime, remainDuration)
                                   toDuration:CMTimeMake(remainDuration.value * videoScaleFactor, remainDuration.timescale)];
        [compositionVideoTrack setPreferredTransform:vdoTrack.preferredTransform];
        
        //audio insert (无音频情况处理)
        if ([videoAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) {
            
            /*
            //todo测试音频(todo提出去)
            NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"慢快-数钱" ofType:@"mp4"];
            NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
            AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
            */
            
            NSError *audioInsertError =nil;
            BOOL audioInsertResult =[compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                                                   ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                                                    atTime:kCMTimeZero
                                                                     error:&audioInsertError];
            //todo 替换效果音(提出去)
    //        CMTime editedDuration = CMTimeMultiply(remainDuration, videoScaleFactor);
    //        [compositionAudioTrack removeTimeRange:CMTimeRangeMake(beginTime, remainDuration)];
    //        audioInsertResult =[compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, editedDuration)
    //                                                          ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
    //                                                           atTime:beginTime
    //                                                            error:&audioInsertError];
            if (!audioInsertResult || nil != audioInsertError) {
                //handle error
                NSLog(@"ERROR: %@", audioInsertError);
                return;
            }
            [compositionAudioTrack scaleTimeRange:CMTimeRangeMake(beginTime, remainDuration)
                                       toDuration:CMTimeMake(remainDuration.value * videoScaleFactor, remainDuration.timescale)];
        }
        exportAsset = mixComposition;
    }
    
    
    //--------------------分隔线内可以抽取--------------------
    
    
    //---配置outputPath
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    //todo 视频名字要改
    NSString *outputFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"slowMotion.mov"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
    }
    NSURL *_filePath = [NSURL fileURLWithPath:outputFilePath];
    
    //todo 稳定后修改下视频质量  考虑开放不同质量让用户选择
    //export
    AVAssetExportSession* assetExport = [[AVAssetExportSession alloc] initWithAsset:exportAsset
                                                                         presetName:AVAssetExportPreset1920x1080];
    assetExport.outputURL = _filePath;
    assetExport.outputFileType = assetExport.supportedFileTypes.firstObject;
    assetExport.shouldOptimizeForNetworkUse = YES;
    
    //trimming
    CMTime trimmingEndTime = CMTimeAdd(_playerItem.forwardPlaybackEndTime, extraTime);
    CMTime trimmingDuration = CMTimeSubtract(trimmingEndTime, _playerItem.reversePlaybackEndTime);
    CMTimeRange timeRange = CMTimeRangeMake(_playerItem.reversePlaybackEndTime, trimmingDuration);
    assetExport.timeRange = timeRange;
    
    __weak __typeof(&*self)weakSelf = self;
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        switch ([assetExport status]) {
            case AVAssetExportSessionStatusFailed:
            {
                NSLog(@"Export session faiied with error: %@", [assetExport error]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"发生未知错误，可能为视频帧数不足，尝试让视频更长?" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    [weakSelf.rightTopButton setEnabled:YES];
                });
            }
                break;
            case AVAssetExportSessionStatusCompleted:
            {
                NSLog(@"Successful");
                NSURL *outputURL = assetExport.outputURL;
                dispatch_async(dispatch_get_main_queue(), ^{
                    // completion(_filePath);
                    [self fullScreemDisplayWithOutputUrl:outputURL];
                });
            }
                break;
            default:
                break;
        }
    }];
}

- (void)writeExportedVideoToAssetsLibrary:(NSURL *)url {
    NSURL *exportURL = url;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:exportURL]) {
        [library writeVideoAtPathToSavedPhotosAlbum:exportURL completionBlock:^(NSURL *assetURL, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                                        message:[error localizedRecoverySuggestion]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
                if(!error)
                {
                    // [activityView setHidden:YES];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sucess"
                                                                        message:@"video added to gallery successfully"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    NSLog(@"保存成功");
                }
#if !TARGET_IPHONE_SIMULATOR
                [[NSFileManager defaultManager] removeItemAtURL:exportURL error:nil];
#endif
            });
        }];
    } else {
        NSLog(@"Video could not be exported to assets library.");
    }
}
/**剪辑变速成功  播放界面*/
- (void)fullScreemDisplayWithOutputUrl:(NSURL *)url {
    _rightTopButton.enabled = YES;
    AVCaptureVideoOrientation videoOrientation = [objc_getAssociatedObject(self.assetUrl, &kOrientation) integerValue];
    
    
    FullScreemDisplayController *fullController = [[FullScreemDisplayController alloc] initWithAssetUrl:url videoOrientation:videoOrientation];
    UINavigationController *fullNav = [[UINavigationController alloc] initWithRootViewController:fullController];
    fullNav.navigationBarHidden = YES;
    [self.navigationController presentViewController:fullNav animated:YES completion:nil];
}

- (UIImage *)createImageWithColor:(UIColor *) color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 2.0f, 2.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - delegate
- (void)operatingViewRangeDidChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition sliderMotion:(SliderMotion)motion {
    [_player pause];
    //取消任何seek请求
    [_playerItem cancelPendingSeeks];
    
    //seekToTime
    CGFloat timePosition;
    if (motion == SliderMotionLeft || motion == SliderMotionBoth) {
        timePosition = leftPosition;
    } else if (motion == SliderMotionRight){
        timePosition = rightPosition;
    }
    [_player seekToTime:CMTimeMakeWithSeconds(timePosition, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)operatingViewRangeDidGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
    //设置视频可播放范围
    [_playerItem setReversePlaybackEndTime:CMTimeMakeWithSeconds(leftPosition, NSEC_PER_SEC)];
    [_playerItem setForwardPlaybackEndTime:CMTimeMakeWithSeconds(rightPosition, NSEC_PER_SEC)];
}

- (void)operatingViewSpeedDidChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition sliderMotion:(SliderMotion)motion {
    [_player pause];
    //取消任何seek请求
    [_playerItem cancelPendingSeeks];
    
    //seekToTime
    CGFloat timePosition;
    if (motion == SliderMotionLeft || motion == SliderMotionBoth) {
        timePosition = leftPosition;
    } else if (motion == SliderMotionRight){
        timePosition = rightPosition;
    }
    [_player seekToTime:CMTimeMakeWithSeconds(timePosition, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)operatingViewSpeedDidGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
    
}

- (void)operatingViewSpeedBeginEditing {
    [_videoRangeButton setTitleColor:SPEED_FREEZING_COLOR_WHITE forState:UIControlStateNormal];
    [_videoSpeedButton setTitleColor:SPEED_FREEZING_COLOR_YELLOW forState:UIControlStateNormal];
    [_videoRangeButton setImage:[UIImage imageNamed:@"rangeEditing_white"] forState:UIControlStateNormal];
    [_videoSpeedButton setImage:[UIImage imageNamed:@"speedEditing_yellow"] forState:UIControlStateNormal];
    
    _speedMultipleHolderView.hidden = NO;
}

- (void)operatingViewRangeBeginEditing {
    [_videoRangeButton setTitleColor:SPEED_FREEZING_COLOR_YELLOW forState:UIControlStateNormal];
    [_videoSpeedButton setTitleColor:SPEED_FREEZING_COLOR_WHITE forState:UIControlStateNormal];
    [_videoRangeButton setImage:[UIImage imageNamed:@"rangeEditing_yellow"] forState:UIControlStateNormal];
    [_videoSpeedButton setImage:[UIImage imageNamed:@"speedEditing_white"] forState:UIControlStateNormal];
    
    _speedMultipleHolderView.hidden = YES;
}

/**视频速度的选择*/
- (void)SpeedMultipleViewDidSelectedSpeedRate:(double)rate {
    self.speedRate = rate;
}

#pragma mark - Action
- (IBAction)clickPlayButton:(id)sender {
    [_player play];
}


/**next的点击  修改速度 和 剪辑视频*/
- (void)clickRightTopButton:(UIBarButtonItem *)item {
    item.enabled = NO;
    //修改速度 和 剪辑视频  同时进行
    [self speedFreezingWithAssetUrl:_assetUrl beginTime:[_operatingView speedOperateVideoBeginTime] endTime:[_operatingView speedOperateVideoEndTime] replaceSoundEffect:nil];
}

- (IBAction)clickOperatingSpeedButton:(id)sender {
    if (_operatingView.editingType == EditingTypeRange) {
        [_operatingView speedEditing];
        self.speedOperatingEffected = YES;
    } else if (_operatingView.editingType == EditingTypeSpeed) {
        self.speedOperatingEffected = [_operatingView switchSpeedSlider];
        _speedMultipleHolderView.hidden = !_speedOperatingEffected;
    }
}

- (IBAction)clickOperatingRangeButton:(id)sender {
    [_operatingView rangeEditing];
}


//- (void)trimmingVideoWithAsset:(AVAsset *)asset {
//    //配置path
//    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docsDir = [dirPaths objectAtIndex:0];
//    //todo 以上两步为何
//    NSString *outputFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"trimmingAsset.mov"]];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:outputFilePath]) {
//        NSError *error;
//        if (![[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:&error]) {
//            NSLog(@"ERROR: 清除旧文件发生错误");
//        }
//    }
//    NSURL *outputUrl = [NSURL fileURLWithPath:outputFilePath];
//    
//    //export
//    AVAsset *trimmingAsset = [AVAsset assetWithURL:_assetUrl];
//    AVAssetExportSession *trimmingExportSession = [[AVAssetExportSession alloc] initWithAsset:trimmingAsset presetName:AVCaptureSessionPresetHigh];
//    trimmingExportSession.outputURL = outputUrl;
//    trimmingExportSession.outputFileType = AVFileTypeMPEG4;
//    trimmingExportSession.shouldOptimizeForNetworkUse = YES;
//    
//    //异步输出
//    [trimmingExportSession exportAsynchronouslyWithCompletionHandler:^{
//        
//        switch ([trimmingExportSession status]) {
//            case AVAssetExportSessionStatusFailed:
//            {
//                NSLog(@"Export session faiied with error: %@", [trimmingExportSession error]);
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // completion(nil);
//                });
//            }
//                break;
//            case AVAssetExportSessionStatusCompleted:
//            {
//                NSLog(@"Successful");
//                NSURL *outputURL = trimmingExportSession.outputURL;
//                
//                //todo这里不保存相册
////                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
////                if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
////                    [self writeExportedVideoToAssetsLibrary:outputURL];
////                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // completion(_filePath);
//                    [self fullScreemDisplayWithOutputUrl:outputURL];
//                });
//            }
//                break;
//            default:
//                break;
//        }
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
