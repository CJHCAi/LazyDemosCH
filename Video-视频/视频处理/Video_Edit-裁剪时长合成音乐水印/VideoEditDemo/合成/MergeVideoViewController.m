//
//  MergeVideoViewController.m
//  VideoEditDemo
//
//  Created by hejiangshan on 17/2/8.
//  Copyright © 2017年 飞兽科技. All rights reserved.
//

#import "MergeVideoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "APLSimpleEditor.h"
#import <AVFoundation/AVFoundation.h>

@interface MergeVideoViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) AVAsset *firstAsset;
@property (nonatomic,strong) AVAsset *secondAsset;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,strong) APLSimpleEditor *editor;
@property (nonatomic,strong) NSMutableArray *clips;
@property (nonatomic,strong) NSMutableArray *clipTimeRanges;

@end

@implementation MergeVideoViewController
{
    float _transitionDuration;
    BOOL _transitionsEnabled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _transitionDuration = 2.0;
    _transitionsEnabled = YES;
    
    self.editor = [[APLSimpleEditor alloc] init];
    self.clips = [[NSMutableArray alloc] initWithCapacity:2];
    self.clipTimeRanges = [[NSMutableArray alloc] initWithCapacity:2];
    
    [self setupEditingAndPlayback];
}

- (void)setupEditingAndPlayback
{
    dispatch_group_t dispatchGroup = dispatch_group_create();
    NSArray *assetKeysToLoadAndTest = @[@"tracks", @"duration", @"composable"];
    
    [self loadAsset:self.firstAsset withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];
    [self loadAsset:self.secondAsset withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];
    
    // Wait until both assets are loaded
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        [self synchronizeWithEditor];
    });
}

- (void)loadAsset:(AVAsset *)asset withKeys:(NSArray *)assetKeysToLoad usingDispatchGroup:(dispatch_group_t)dispatchGroup
{
    dispatch_group_enter(dispatchGroup);
    [asset loadValuesAsynchronouslyForKeys:assetKeysToLoad completionHandler:^(){
        // First test whether the values of each of the keys we need have been successfully loaded.
        for (NSString *key in assetKeysToLoad) {
            NSError *error;
            
            if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed) {
                NSLog(@"Key value loading failed for key:%@ with error: %@", key, error);
                goto bail;
            }
        }
        if (![asset isComposable]) {
            NSLog(@"Asset is not composable");
            goto bail;
        }
        
        [self.clips addObject:asset];
        // This code assumes that both assets are atleast 5 seconds long.
        [self.clipTimeRanges addObject:[NSValue valueWithCMTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(0, 1), CMTimeMakeWithSeconds(5, 1))]];
    bail:
        dispatch_group_leave(dispatchGroup);
    }];
}

- (void)synchronizeWithEditor
{
    // Clips
    [self synchronizeEditorClipsWithOurClips];
    [self synchronizeEditorClipTimeRangesWithOurClipTimeRanges];
    
    
    // Transitions
    if (_transitionsEnabled) {
        self.editor.transitionDuration = CMTimeMakeWithSeconds(_transitionDuration, 600);
    } else {
        self.editor.transitionDuration = kCMTimeInvalid;
    }
    
    // Build AVComposition and AVVideoComposition objects for playback
    [self.editor buildCompositionObjectsForPlayback];
//    [self synchronizePlayerWithEditor];
    
    // Set our AVPlayer and all composition objects on the AVCompositionDebugView
//    self.compositionDebugView.player = self.player;
//    [self.compositionDebugView synchronizeToComposition:self.editor.composition videoComposition:self.editor.videoComposition audioMix:self.editor.audioMix];
//    [self.compositionDebugView setNeedsDisplay];
    
    //合成之后的输出路径
    NSString *outPutPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
    //混合后的视频输出路径
    NSURL *outPutUrl = [NSURL fileURLWithPath:outPutPath];
    
    //创建输出
    AVAssetExportSession * assetExport = [[AVAssetExportSession alloc] initWithAsset:self.editor.composition presetName:AVAssetExportPresetMediumQuality];
    assetExport.outputURL = outPutUrl;//输出路径
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;//输出类型
    assetExport.shouldOptimizeForNetworkUse = YES;
    assetExport.videoComposition = self.editor.videoComposition;
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:assetExport];
        });
    }];
}

- (void)synchronizeEditorClipsWithOurClips
{
    NSMutableArray *validClips = [NSMutableArray arrayWithCapacity:2];
    for (AVURLAsset *asset in self.clips) {
        if (![asset isKindOfClass:[NSNull class]]) {
            [validClips addObject:asset];
        }
    }
    
    self.editor.clips = validClips;
}

- (void)synchronizeEditorClipTimeRangesWithOurClipTimeRanges
{
    NSMutableArray *validClipTimeRanges = [NSMutableArray arrayWithCapacity:2];
    for (NSValue *timeRange in self.clipTimeRanges) {
        if (! [timeRange isKindOfClass:[NSNull class]]) {
            [validClipTimeRanges addObject:timeRange];
        }
    }
    
    self.editor.clipTimeRanges = validClipTimeRanges;
}



- (IBAction)selectFirstVideoAction:(UIButton *)sender {
    [self presentPickerVC];
}

- (IBAction)selectSecondVideoAction:(UIButton *)sender {
    [self presentPickerVC];
    
}

- (IBAction)mergeAction:(UIButton *)sender {
    
    if (self.firstAsset == nil || self.secondAsset == nil) {
        return;
    }
    
    AVMutableComposition *composition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *firstCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [firstCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.firstAsset.duration) ofTrack:[[self.firstAsset tracksWithMediaType:AVMediaTypeVideo] firstObject] atTime:kCMTimeZero error:nil];
    [firstCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.secondAsset.duration) ofTrack:[[self.secondAsset tracksWithMediaType:AVMediaTypeVideo] firstObject] atTime:kCMTimeZero error:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *ducumentDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs = [ducumentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    AVAssetExportSession *export = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    export.outputURL = url;
    export.outputFileType = AVFileTypeQuickTimeMovie;
    export.shouldOptimizeForNetworkUse = YES;
    [export exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:export];
        });
    }];
    
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
                        
                        //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                        //                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        //                        [alert show];
                    }
                });
            }];
        }
    }
}

- (void)presentPickerVC
{
    UIImagePickerController *myImagePickerController = [[UIImagePickerController alloc] init];
    myImagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    myImagePickerController.mediaTypes =
    [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    myImagePickerController.delegate = self;
    myImagePickerController.editing = NO;
    [self presentViewController:myImagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if (self.firstAsset == nil) {
        self.firstAsset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        //播放视频
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:self.firstAsset];
        
        self.player = [AVPlayer playerWithPlayerItem:item];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.contentsGravity = AVLayerVideoGravityResizeAspect;
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        self.playerLayer.frame = self.videoView.bounds;
        
        [self.videoView.layer addSublayer:self.playerLayer];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideoLayer:)];
        [self.videoView addGestureRecognizer:tap];
        
        [self.player play];
    } else {
        self.secondAsset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
    }
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
