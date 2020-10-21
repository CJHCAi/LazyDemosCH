//
//  FullScreemDisplayController.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/29.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "FullScreemDisplayController.h"
#import "VideoPlayingView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "EndOfPlayingView.h"
#import "SavedSucceedViewController.h"

@interface FullScreemDisplayController () <EndOfPlayingViewDelegate>
@property (weak, nonatomic) IBOutlet VideoPlayingView *videoPlayingView;
@property (assign, nonatomic) AVCaptureVideoOrientation videoOrientation;
@property (strong, nonatomic) NSURL *assetUrl;
@property (strong, nonatomic) AVPlayer *player;
@property (assign, nonatomic) BOOL isOrientationLandscape;

@end

@implementation FullScreemDisplayController
- (instancetype)initWithPlayer:(AVPlayer *)player videoOrientation:(AVCaptureVideoOrientation)videoOrientation {
    self = [super init];
    if (self) {
        _player = player;
        _videoOrientation = videoOrientation;
    }
    return self;
}

- (instancetype)initWithAssetUrl:(NSURL *)url videoOrientation:(AVCaptureVideoOrientation)videoOrientation {
    self = [super init];
    if (self) {
        _assetUrl = url;
        _player = [AVPlayer playerWithURL:url];
        _videoOrientation = videoOrientation;
    }
    return self;
}

- (void)dealloc {
    //remove notify
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotification];
    [_videoPlayingView setPlayer:_player];
    [_videoPlayingView setVideoGravity:AVLayerVideoGravityResizeAspect];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //transform
    if (_videoOrientation == AVCaptureVideoOrientationLandscapeLeft || _videoOrientation == AVCaptureVideoOrientationLandscapeRight) {
        self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
        self.isOrientationLandscape = YES;
    }
    //play
    [_player play];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needsDismiss) name:NOTIFICATION_NAME_FULLSCREEN_DISPLAY_NEEDS_DISMISS object:nil];
}

- (void)needsDismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)writeExportedVideoToAssetsLibrary:(NSURL *)url {
    NSURL *exportURL = url;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:exportURL]) {
        __weak __typeof(&*self)weakSelf = self;
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
                    SavedSucceedViewController *savedController = [[SavedSucceedViewController alloc] init];
                    weakSelf.navigationController.navigationBarHidden = NO;
                    [weakSelf.navigationController pushViewController:savedController animated:YES];
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sucess"
//                                                                        message:@"video added to gallery successfully"
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"OK"
//                                                              otherButtonTitles:nil];
//                    [alertView show];
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

- (void)playerItemDidEnd:(NSNotification *)notify {
    [_player seekToTime:kCMTimeZero];
    [self showEndOfPlayingView];
}

- (void)saveToAlbum {
    [self writeExportedVideoToAssetsLibrary:_assetUrl];
}

- (void)showEndOfPlayingView {
    EndOfPlayingView *operationView;
    if (_isOrientationLandscape) {
        operationView = [[EndOfPlayingView alloc] initWithVideoOrientation:VideoOrientationLandscape delegate:self];
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        [operationView setFrame:CGRectMake(0, 0, screenSize.height, screenSize.width)];
    } else {
        operationView = [[EndOfPlayingView alloc] initWithVideoOrientation:VideoOrientationPortrait delegate:self];
    }
    [self.view addSubview:operationView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] view] == _videoPlayingView) {
        [_player pause];
        [self showEndOfPlayingView];
    } else {
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
//    [self showEndOfPlayingView];
}

- (void)didClickSaveButton {
    [self saveToAlbum];
}

- (void)didClickReplayButton {
    [_player seekToTime:kCMTimeZero];
    [_player play];
}

- (void)didClickBackToEditButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
