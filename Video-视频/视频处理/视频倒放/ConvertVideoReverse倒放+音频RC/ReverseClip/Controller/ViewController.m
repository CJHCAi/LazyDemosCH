//
//  ViewController.m
//  ReverseClip
//
//  Created by Mikael Hellqvist on 2012-08-19.
//  Copyright (c) 2012 Mikael Hellqvist. All rights reserved.
//

#import "ViewController.h"

#import "RCToolbox.h"
#import "RCConstants.h"

#import <AVKit/AVKit.h>

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "SVProgressHUD.h"

@interface ViewController ()
{
    AVPlayerViewController *playerVC;
    Float64 endTime;
}
@property(nonatomic,retain)AVURLAsset* videoAsset;
@property(nonatomic,retain)AVURLAsset* audioAsset;
@property (weak, nonatomic) IBOutlet UIView *vwMoviePlayer;
- (void)exportDidFinish:(AVAssetExportSession*)session;

@end

@implementation ViewController

@synthesize videoAsset,audioAsset;
@synthesize vwMoviePlayer;

#pragma mark - UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [vwMoviePlayer setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieIsExported)
                                                 name:@"ExportedMovieNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageSequenceIsExported)
                                                 name:@"ExportedImageSequenceNotification"
                                               object:nil];

}

- (void)viewDidUnload{
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Button Actions
//从原来的视频创建视频反向
- (IBAction)startButtonPressed:(id)sender
{
    [SVProgressHUD showWithStatus:@"Creating Video Reverse" maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createReverseClip];
    });
}

//从原始视频得到音频
- (IBAction)getAudioFromVideoTapped:(id)sender
{
    [SVProgressHUD showWithStatus:@"Converting Audio From Original Video.." maskType:SVProgressHUDMaskTypeGradient];
    
    [self getAudioFromVideo];
}

//合并音频和视频在一起&播放他们
- (IBAction)btnMergeTapped:(id)sender
{
    [SVProgressHUD showWithStatus:@"Merge Audio & Video Together" maskType:SVProgressHUDMaskTypeGradient];
    [vwMoviePlayer setHidden:YES];
    [self performSelector:@selector(mergeAndSave) withObject:nil afterDelay:.6];
}

//加载原始视频
-(IBAction)loadOriginalVideo:(id)sender
{
    
    NSString *sourceMoviePath = [[NSBundle mainBundle] pathForResource:@"Video_AudioDemo" ofType:@"mp4"];
    NSURL *originalMovieURL = [NSURL fileURLWithPath:sourceMoviePath];
    playerVC = [[AVPlayerViewController alloc] init];
    playerVC.view.frame = CGRectMake(0, 0, vwMoviePlayer.frame.size.width, vwMoviePlayer.frame.size.height);
    playerVC.view.backgroundColor = [UIColor orangeColor];
    playerVC.player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:originalMovieURL]];
    [playerVC.player play];
    [vwMoviePlayer addSubview:playerVC.view];
    [vwMoviePlayer setHidden:NO];
    
    if (@available(iOS 11.0, *)) {
        playerVC.entersFullScreenWhenPlaybackBegins = YES;//开启这个播放的时候支持（全屏）横竖屏
        playerVC.exitsFullScreenWhenPlaybackEnds = YES;//item 播放完毕可以退出全屏
    }
    

}


#pragma mark - Other Method
/**合并 保存*/
-(void)mergeAndSave{
    //Get path
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    //Create AVMutableComposition Object which will hold our multiple AVMutableCompositionTrack or we can say it will hold our video and audio files.
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    //Now first load your audio file using AVURLAsset. Make sure you give the correct path of your videos.
    //This is Converted Audio frile from Original Video
    NSString *outputFilePath111 = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"FinalVideo.m4a"]];
    NSURL *audio_url = [NSURL fileURLWithPath:outputFilePath111];
    audioAsset = [[AVURLAsset alloc]initWithURL:audio_url options:nil];
    CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
    
    //Now we are creating the first AVMutableCompositionTrack containing our audio and add it to our AVMutableComposition object.
    AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [b_compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //Now we will load video file.
    NSString *outputFilePath11 = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"imageSequence_reverse.mov"]];
    NSURL *video_url = [NSURL fileURLWithPath:outputFilePath11];
    videoAsset = [[AVURLAsset alloc]initWithURL:video_url options:nil];
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,audioAsset.duration);
    
    //Now we are creating the second AVMutableCompositionTrack containing our video and add it to our AVMutableComposition object.
    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //decide the path where you want to store the final video created with audio and video merge.
    NSString *outputFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"FinalVideo.mov"]];
    NSURL *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath])
        [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
    
    //Now create an AVAssetExportSession object that will save your final video at specified path.
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    _assetExport.outputFileType = @"com.apple.quicktime-movie";
    _assetExport.outputURL = outputFileUrl;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [SVProgressHUD dismiss];
             [self exportDidFinish:_assetExport];
             
         });
     }
     ];
}

/**输出结束*/
- (void)exportDidFinish:(AVAssetExportSession*)session
{
    if(session.status == AVAssetExportSessionStatusCompleted){
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL
                                        completionBlock:^(NSURL *assetURL, NSError *error){
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (error) {
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
                                                    [alert show];
                                                }else{
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                                                    [alert show];
                                                    [self loadplayerVC:outputURL];
                                                }
                                            });
                                        }];
        }
    }
    audioAsset = nil;
    videoAsset = nil;
}

/**加载播放器视图*/
-(void)loadplayerVC:(NSURL*)moviePath
{
    playerVC = [[AVPlayerViewController alloc] init];
    playerVC.view.frame = vwMoviePlayer.bounds;
    playerVC.view.backgroundColor = [UIColor clearColor];
    playerVC.player = [AVPlayer playerWithURL:moviePath];
    [playerVC.player play];
    [vwMoviePlayer addSubview:playerVC.view];
    [vwMoviePlayer setHidden:NO];
}

/**从视频中获取音频*/
-(void)getAudioFromVideo {
    float startTime = 0;
//    [super viewDidLoad];
    
    //转换音频文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *audioPath = [documentsDirectory stringByAppendingPathComponent:@"FinalVideo.m4a"];
    
    //这里是原始的视频文件路径
    //Get Audio From Original Video
    AVAsset *myasset = [AVAsset assetWithURL:[[NSBundle mainBundle] URLForResource:@"Video_AudioDemo" withExtension:@"mp4"]];
    
    AVAssetExportSession *exportSession=[AVAssetExportSession exportSessionWithAsset:myasset presetName:AVAssetExportPresetAppleM4A];
    
    exportSession.outputURL=[NSURL fileURLWithPath:audioPath];
    exportSession.outputFileType=AVFileTypeAppleM4A;
    
    CMTime vocalStartMarker = CMTimeMake((int)(floor(startTime * 100)), 100);
    CMTime vocalEndMarker = CMTimeMake((int)(ceil(endTime * 100)), 100);
    
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(vocalStartMarker, vocalEndMarker);
    exportSession.timeRange= exportTimeRange;
    if ([[NSFileManager defaultManager] fileExistsAtPath:audioPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
    }
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (exportSession.status==AVAssetExportSessionStatusCompleted) {
                NSLog(@"AudioLocation : %@",audioPath);
            }else {
                NSLog(@"failed");
            }

        });
    }];
}

#pragma mark - Reverse clip
/**创建反向剪辑*/
-(void) createReverseClip{
    RCFileHandler *filehandler = [[RCToolbox sharedToolbox] fileHandler];
    AVURLAsset *urlAsset = [filehandler getAssetURLFromBundleWithFileName:@"Video_AudioDemo"];
    [self exportReversedClip:urlAsset];
}

/**导出反向剪辑*/
-(void) exportReversedClip:(AVURLAsset *)urlAsset
{
    Float64 assetDuration = CMTimeGetSeconds(urlAsset.duration);
    endTime=assetDuration;
    NSLog(@"-- %d",urlAsset.duration.timescale);
    RCComposer *compositionTool = [[RCToolbox sharedToolbox] compositionTool];
    [compositionTool addToCompositionWithAsset:(AVURLAsset*)urlAsset inSeconds:0.0 outSeconds:assetDuration shouldBeReversed:YES];
}

#pragma - Notifications
/**电影已经输出*/
-(void)movieIsExported
{
    RCFileHandler *fileHandler = [[RCToolbox sharedToolbox] fileHandler];
    AVURLAsset *urlAsset = [fileHandler getAssetURLFromFileName:k_exportedClipName];
    NSLog(@"The movie has been exported. \n URLAsset:%@",urlAsset);
}

/**图片序列已经输出*/
-(void)imageSequenceIsExported
{
    RCFileHandler *fileHandler = [[RCToolbox sharedToolbox] fileHandler];
    AVURLAsset *urlAsset = [fileHandler getAssetURLFromFileName:k_exportedSequenceName];
    NSLog(@"The image sequence has been exported. \n URLAsset:%@",urlAsset);
}

@end

