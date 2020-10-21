//
//  ViewController.m
//  VideoReflection
//
//  Created by Johnny Xu(徐景周) on 5/22/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <StoreKit/StoreKit.h>

#import "SRScreenRecorder.h"
#import "PBJVideoPlayerController.h"
#import "MIMovieVideoSampleAccessor.h"
#import "UIImage+Reflection.h"
#import "SNLoading.h"
#import "CaptureViewController.h"
#import "JGActionSheet.h"
#import "DBPrivateHelperController.h"
#import "KGModal.h"
#import "AudioViewController.h"
#import "CMPopTipView.h"
#import "ScrollSelectView.h"
#import "StickerView.h"
#import "VideoView.h"
#import "VideoAnimationLayer.h"
#import "UIImageView+AnimationCompletion.h"
#import "UIAlertView+Blocks.h"
#import "LeafNotification.h"

#define MaxVideoLength 10
#define DemoDestinationVideoName @"IMG_Dst.mov"

typedef NS_ENUM(NSInteger, SelectedMediaType)
{
    kNone = -1,
    kBackgroundVideo = 0,
    kEmbededGif,
    kEmbededVideo,
};


@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, PBJVideoPlayerControllerDelegate, SKStoreProductViewControllerDelegate, ScrollSelectViewDelegate>
{
    CMPopTipView *_popTipView;
    LeafNotification *_notification;
}

@property (nonatomic, strong) UIScrollView *captureContentView;
@property (nonatomic, strong) UIImageView *videoView1;
@property (nonatomic, strong) UIImageView *videoView2;

@property (nonatomic, strong) PBJVideoPlayerController *demoOriginalVideoPlayerController;
@property (nonatomic, strong) PBJVideoPlayerController *demoDestinationVideoPlayerController;
@property (nonatomic, strong) UIView *demoVideoContentView;
@property (nonatomic, strong) UIImageView *playDemoButton;

@property (nonatomic, strong) UIScrollView *videoContentView;
@property (nonatomic, strong) PBJVideoPlayerController *videoPlayerController1;
@property (nonatomic, strong) UIImageView *playButton1;
@property (nonatomic, strong) UIButton *closeVideoPlayerButton1;

@property (nonatomic, strong) UILabel *videoReadyLabel;
@property (nonatomic, strong) UILabel *audioReadyLabel;

@property (nonatomic, strong) MIMovieVideoSampleAccessor *sampleAccessor;
@property (nonatomic, assign) CMTime captureVideoSampleTime;

@property (nonatomic, copy) NSURL* videoBackgroundPickURL;
@property (nonatomic, assign) long long videoFileSize;

@property (nonatomic, strong) UIScrollView *bottomControlView;
@property (nonatomic, strong) ScrollSelectView *gifScrollView;

@property (nonatomic, assign) SelectedMediaType mediaType;
@property (nonatomic, strong) NSMutableArray *gifArray;

@property (nonatomic, strong) ScrollSelectView *borderView;
@property (nonatomic, strong) UIImageView *borderImageView;

@property (nonatomic, copy) NSURL *videoEmbededPickURL;
@property (nonatomic, strong) NSMutableArray *videoArray;

@property (nonatomic, strong) NSMutableArray *embeddedVideoImageViewArray;

@end

@implementation ViewController

#pragma mark - Contact US
- (void)createContactUS
{
    if (_notification)
    {
        [_notification dismissWithAnimation:NO];
        _notification = nil;
    }
    
    __weak typeof(self) weakSelf = self;
    _notification = [[LeafNotification alloc] initWithController:self text:GBLocalizedString(@"ContactUS")];
    [self.view addSubview:_notification];
    _notification.type = LeafNotificationTypeWarrning;
    _notification.tapHandler = ^{
        
        NSLog(@"contactUs");
        [weakSelf contactUs];
    };
    [_notification showWithAnimation:YES];
}

- (void)contactUs
{
    NSString *url = @"mailto:1409694515@qq.com";
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

#pragma mark - Splice Image(Up/Down)
- (UIImage *)imageSpliceFromUP:(UIImage *)imageUP fromDownImage:(UIImage *)imageDown
{
    CGFloat width = imageUP.size.width, height = imageUP.size.height;
    
    if (width < height)
    {
        CGSize size = CGSizeMake(width*2, height*2);
        UIGraphicsBeginImageContext(size);
        
        [imageUP drawInRect:CGRectMake(width/2, 0, width, height)];
        [imageDown drawInRect:CGRectMake(width/2, height, width, height)];
    }
    else if (width == height)
    {
        CGSize size = CGSizeMake(width/2, height);
        UIGraphicsBeginImageContext(size);
        
        [imageUP drawInRect:CGRectMake(0, 0, width/2, height/2)];
        [imageDown drawInRect:CGRectMake(0, height/2, width/2, height/2)];
    }
    else
    {
        CGSize size = CGSizeMake(width, height*2);
        UIGraphicsBeginImageContext(size);
        
        [imageUP drawInRect:CGRectMake(0, 0, width, height)];
        [imageDown drawInRect:CGRectMake(0, height, width, height)];
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

#pragma mark - Random Border
- (UIImage*)getBorderImage:(UIImage*)image
{
    NSString *imageName = [NSString stringWithFormat:@"border_%i",(arc4random()%(int)9)];
    UIImage *imageBorder = [UIImage imageNamed:imageName];
    UIImage *imageResult = imageBorderSplice(image, imageBorder);
    
    return imageResult;
}

#pragma mark - Authorization Helper
- (void)popupAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:GBLocalizedString(@"Private_Setting_Audio_Tips") delegate:nil cancelButtonTitle:GBLocalizedString(@"IKnow") otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)popupAuthorizationHelper:(id)type
{
    DBPrivateHelperController *privateHelper = [DBPrivateHelperController helperForType:[type longValue]];
    privateHelper.snapshot = [self snapshot];
    privateHelper.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:privateHelper animated:YES completion:nil];
}

- (UIImage *)snapshot
{
    id <UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    UIGraphicsBeginImageContextWithOptions(appDelegate.window.bounds.size, NO, appDelegate.window.screen.scale);
    [appDelegate.window drawViewHierarchyInRect:appDelegate.window.bounds afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

#pragma mark - File Helper
- (AVURLAsset *)getURLAsset:(NSString *)filePath
{
    NSURL *videoURL = getFileURL(filePath);
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    
    return asset;
}

#pragma mark - Delete Temp Files
- (void)deleteTempDirectory
{
    NSString *dir = NSTemporaryDirectory();
    deleteFilesAt(dir, @"mov");
}

#pragma mark - Custom ActionSheet
- (void)showCustomActionSheet:(UIBarButtonItem *)barButtonItem withEvent:(UIEvent *)event
{
    UIView *anchor = [event.allTouches.anyObject view];
    
    NSString *videoTitle = [NSString stringWithFormat:@"%@%@", GBLocalizedString(@"Step1"), GBLocalizedString(@"SelectVideo")];
    JGActionSheetSection *sectionVideo = [JGActionSheetSection sectionWithTitle:videoTitle
                                                                        message:nil
                                                                   buttonTitles:@[
                                                                                  GBLocalizedString(@"Camera"),
                                                                                  GBLocalizedString(@"PhotoAlbum")
                                                                                  ]
                                                                    buttonStyle:JGActionSheetButtonStyleDefault];
    [sectionVideo setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:0];
    [sectionVideo setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:1];
    
    NSString *embededObjectsTitle = [NSString stringWithFormat:@"%@%@", GBLocalizedString(@"Step2"), GBLocalizedString(@"SelectEmbeddedObjects")];
    JGActionSheetSection *sectionEmbededObjects = [JGActionSheetSection sectionWithTitle:embededObjectsTitle message:nil buttonTitles:
                                                                                    @[
                                                                                      GBLocalizedString(@"Gif"),
                                                                                      GBLocalizedString(@"Video"),
                                                                                      GBLocalizedString(@"BackgroundMusic")
                                                                                        
                                                                                     ]
                                                                    buttonStyle:JGActionSheetButtonStyleDefault];
    [sectionEmbededObjects setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:0];
    [sectionEmbededObjects setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:1];
    [sectionEmbededObjects setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:2];
    
    NSString *resultTitle = [NSString stringWithFormat:@"%@%@", GBLocalizedString(@"Step3"), GBLocalizedString(@"Export")];
    JGActionSheetSection *sectionResult = [JGActionSheetSection sectionWithTitle:resultTitle message:nil buttonTitles:
                                          @[
                                            GBLocalizedString(@"StartToCreate")
                                            
                                            ]
                                                                    buttonStyle:JGActionSheetButtonStyleDefault];
    [sectionResult setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:0];

    
    NSArray *sections = (iPad ? @[sectionVideo, sectionEmbededObjects, sectionResult] : @[sectionVideo, sectionEmbededObjects, sectionResult, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[GBLocalizedString(@"Cancel")] buttonStyle:JGActionSheetButtonStyleCancel]]);
    JGActionSheet *sheet = [[JGActionSheet alloc] initWithSections:sections];
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath)
     {
         NSLog(@"indexPath: %ld; section: %ld", (long)indexPath.row, (long)indexPath.section);
         
         if (indexPath.section == 0)
         {
             if (indexPath.row == 0)
             {
                 // Check permission for Video & Audio
                 [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted)
                  {
                      if (!granted)
                      {
                          [self performSelectorOnMainThread:@selector(popupAlertView) withObject:nil waitUntilDone:YES];
                          return;
                      }
                      else
                      {
                          [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
                           {
                               if (!granted)
                               {
                                   [self performSelectorOnMainThread:@selector(popupAuthorizationHelper:) withObject:[NSNumber numberWithLong:DBPrivacyTypeCamera] waitUntilDone:YES];
                                   return;
                               }
                               else
                               {
                                   // Has permisstion
                                   [self performSelectorOnMainThread:@selector(pickBackgroundVideoFromCamera) withObject:nil waitUntilDone:NO];
                               }
                           }];
                      }
                  }];
             }
             else if (indexPath.row == 1)
             {
                 // Check permisstion for photo album
                 ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
                 if (authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied)
                 {
                     [self performSelectorOnMainThread:@selector(popupAuthorizationHelper:) withObject:[NSNumber numberWithLong:DBPrivacyTypePhoto] waitUntilDone:YES];
                     return;
                 }
                 else
                 {
                     // Has permisstion to execute
                     [self performSelector:@selector(pickBackgroundVideoFromPhotosAlbum) withObject:nil afterDelay:0.1];
                 }
             }
         }
         else if (indexPath.section == 1)
         {
             if (!_videoBackgroundPickURL)
             {
                 NSString *message = GBLocalizedString(@"VideoIsEmptyHint");
                 showAlertMessage(message, nil);
                 return;
             }
             
             if (indexPath.row == 0)
             {
                 // 1. Gif
                 [self performSelector:@selector(pickGifFromCustom) withObject:nil afterDelay:0.1];
             }
             else if (indexPath.row == 1)
             {
                 // 2. Video
                 [self performSelector:@selector(pickEmbededVideoFromCamera) withObject:nil afterDelay:0.1];
             }
             else if (indexPath.row == 2)
             {
                 // 3. Music
                 [self performSelector:@selector(pickMusicFromCustom) withObject:nil afterDelay:0.1];
             }
         }
         else if (indexPath.section == 2)
         {
             if (indexPath.row == 0)
             {
                 [self performSelector:@selector(handleConvert) withObject:nil afterDelay:0.1];
             }
         }
         
         [sheet dismissAnimated:YES];
     }];
    
    if (iPad)
    {
        [sheet setOutsidePressBlock:^(JGActionSheet *sheet)
         {
             [sheet dismissAnimated:YES];
         }];
        
        CGPoint point = (CGPoint){ CGRectGetMidX(anchor.bounds), CGRectGetMaxY(anchor.bounds) };
        point = [self.navigationController.view convertPoint:point fromView:anchor];
        
        [sheet showFromPoint:point inView:self.navigationController.view arrowDirection:JGActionSheetArrowDirectionTop animated:YES];
    }
    else
    {
        [sheet setOutsidePressBlock:^(JGActionSheet *sheet)
         {
             [sheet dismissAnimated:YES];
         }];
        
        [sheet showInView:self.navigationController.view animated:YES];
    }
}

#pragma mark - PBJVideoPlayerControllerDelegate
- (void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer
{
    //NSLog(@"Max duration of the video: %f", videoPlayer.maxDuration);
}

- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer
{
}

- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer
{
    if (videoPlayer == _videoPlayerController1)
    {
        _playButton1.alpha = 1.0f;
        _playButton1.hidden = NO;
        
        [UIView animateWithDuration:0.1f animations:^{
            _playButton1.alpha = 0.0f;
        } completion:^(BOOL finished)
         {
             _playButton1.hidden = YES;
         }];
    }
    else if (videoPlayer == _demoDestinationVideoPlayerController)
    {
        _playDemoButton.alpha = 1.0f;
        _playDemoButton.hidden = NO;
        
        [UIView animateWithDuration:0.1f animations:^{
            _playDemoButton.alpha = 0.0f;
        } completion:^(BOOL finished)
         {
             _playDemoButton.hidden = YES;
         }];
    }
}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)videoPlayer
{
    if (videoPlayer == _videoPlayerController1)
    {
        _playButton1.hidden = NO;
        
        [UIView animateWithDuration:0.1f animations:^{
            _playButton1.alpha = 1.0f;
        } completion:^(BOOL finished)
         {
             
         }];
    }
    else if (videoPlayer == _demoDestinationVideoPlayerController)
    {
        _playDemoButton.hidden = NO;
        
        [UIView animateWithDuration:0.1f animations:^{
            _playDemoButton.alpha = 1.0f;
        } completion:^(BOOL finished)
         {
             
         }];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1.
    [self dismissViewControllerAnimated:NO completion:nil];
    
    NSLog(@"info = %@",info);
    
    // 2.
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.movie"])
    {
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        
        if (url && ![url isFileURL])
        {
            NSLog(@"Input file from camera is invalid.");
            return;
        }
        
        if (getVideoDuration(url) > MaxVideoLength)
        {
            NSString *ok = GBLocalizedString(@"OK");
            NSString *error = GBLocalizedString(@"Error");
            NSString *fileLenHint = GBLocalizedString(@"FileLenHint");
            NSString *seconds = GBLocalizedString(@"Seconds");
            NSString *hint = [fileLenHint stringByAppendingFormat:@" %d ", MaxVideoLength];
            hint = [hint stringByAppendingString:seconds];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:error
                                                            message:hint
                                                           delegate:nil
                                                  cancelButtonTitle:ok
                                                  otherButtonTitles: nil];
            [alert show];
            
            return;
        }
        
        if (_mediaType == kBackgroundVideo)
        {
            // Remove last file
            if (self.videoBackgroundPickURL && [self.videoBackgroundPickURL isFileURL])
            {
                if ([[NSFileManager defaultManager] removeItemAtURL:self.videoBackgroundPickURL error:nil])
                {
                    NSLog(@"Success for delete old pick file: %@", self.videoBackgroundPickURL);
                }
                else
                {
                    NSLog(@"Failed for delete old pick file: %@", self.videoBackgroundPickURL);
                }
            }
            
            self.videoBackgroundPickURL = url;
            NSLog(@"Pick background video is success: %@", url);
            
            // Setting
            [self defaultVideoSetting:url];
        }
        else if (_mediaType == kEmbededVideo)
        {
            self.videoEmbededPickURL = url;
            NSLog(@"Pick embeded video is success: %@", url);
            
            [self initEmbededVideoView];
        }
    }
    else
    {
        NSLog(@"Error media type");
        return;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - pickMusicFromCustom
- (void)pickMusicFromCustom
{
    AudioViewController *audioController = [[AudioViewController alloc] init];
    [audioController setSeletedRowBlock: ^(BOOL success, id result) {
        
        if (success && [result isKindOfClass:[NSNumber class]])
        {
            NSInteger index = [result integerValue];
            NSLog(@"pickAudio result: %ld", (long)index);
            
            NSArray *allAudios = [NSArray arrayWithObjects:
                           [NSDictionary dictionaryWithObjectsAndKeys:GBLocalizedString(@"Apple"), @"song", @"Apple.mp3", @"url", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:GBLocalizedString(@"TheMoodOfLove"), @"song", @"Love Paradise.mp3", @"url", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:GBLocalizedString(@"LeadMeOn"), @"song", @"Lead Me On.mp3", @"url", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:GBLocalizedString(@"Butterfly"), @"song", @"Butterfly.mp3", @"url", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:GBLocalizedString(@"ALittleKiss"), @"song", @"A Little Kiss.mp3", @"url", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:GBLocalizedString(@"ByeByeSunday"), @"song", @"Bye Bye Sunday.mp3", @"url", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:GBLocalizedString(@"ComeWithMe"), @"song", @"Come With Me.mp3", @"url", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:GBLocalizedString(@"DolphinTango"), @"song", @"Dolphin Tango.mp3", @"url", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:GBLocalizedString(@"IDo"), @"song", @"I Do.mp3", @"url", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:GBLocalizedString(@"LetMeKnow"), @"song", @"Let Me Know.mp3", @"url", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:GBLocalizedString(@"SwingDance"), @"song", @"Swing Dance.mp3", @"url", nil],
                           
                           nil];
            NSDictionary *item = [allAudios objectAtIndex:index];
            NSString *file = [item objectForKey:@"url"];
            [[SRScreenRecorder sharedInstance] setAudioOutPath:file];
            
            NSString *audioReadyHint = [NSString stringWithFormat:@"%@%@(%@)", GBLocalizedString(@"AudioContent"), GBLocalizedString(@"Ready"), [item objectForKey:@"song"]];
            _audioReadyLabel.text = audioReadyHint;
        }
    }];
    
    [self.navigationController pushViewController:audioController animated:NO];
}

#pragma mark - pickBackgroundVideoFromPhotosAlbum
- (void)pickBackgroundVideoFromPhotosAlbum
{
    _mediaType = kBackgroundVideo;
    [self pickVideoFromPhotoAlbum];
}

- (void)pickVideoFromPhotoAlbum
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // Only movie
        NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - pickEmbededVideoFromCamera
- (void)pickEmbededVideoFromCamera
{
    _mediaType = kEmbededVideo;
    [self pickVideoFromCamera];
}

#pragma mark - pickBackgroundVideoFromCamera
- (void)pickBackgroundVideoFromCamera
{
    _mediaType = kBackgroundVideo;
    [self pickVideoFromCamera];
}

- (void)pickVideoFromCamera
{
    CaptureViewController *captureVC = [[CaptureViewController alloc] init];
    [captureVC setCallback:^(BOOL success, id result)
     {
         if (success)
         {
             NSURL *fileURL = result;
             if (fileURL && [fileURL isFileURL])
             {
                 if (_mediaType == kBackgroundVideo)
                 {
                     self.videoBackgroundPickURL = fileURL;
                     NSLog(@"Pick background video is success: %@", fileURL);
                     
                     // Setting
                     [self defaultVideoSetting:fileURL];
                 }
                 else if (_mediaType == kEmbededVideo)
                 {
                     self.videoEmbededPickURL = fileURL;
                     NSLog(@"Pick embeded video is success: %@", fileURL);
                     
                     [self initEmbededVideoView];
                 }
             }
             else
             {
                 NSLog(@"Video Picker is empty.");
             }
         }
         else
         {
             NSLog(@"Video Picker Failed: %@", result);
         }
     }];
    
    [self presentViewController:captureVC animated:YES completion:^{
        NSLog(@"PickVideo present");
    }];
}

#pragma mark - InitEmbededVideoView
- (void)initEmbededVideoView
{
    if (!self.videoEmbededPickURL)
    {
        NSLog(@"self.videoEmbededPickURL is empty!");
        return;
    }
    
    // Only 1 embeds video is supported (Because crash issue)
    [self clearEmbeddedVideoArray];
    
    VideoView *view = [[VideoView alloc] initWithFilePath:[_videoEmbededPickURL relativePath] withViewController:self];
    CGFloat ratio = MIN( (0.3 * self.videoContentView.width) / view.width, (0.3 * self.videoContentView.height) / view.height);
    [view setScale:ratio];
    CGFloat gap = 50;
    view.center = CGPointMake(self.videoContentView.width/2 + gap, self.videoContentView.height/2 - gap);
    
    [_videoContentView addSubview:view];
    [VideoView setActiveVideoView:view];
    
    if (!_videoArray)
    {
        _videoArray = [NSMutableArray arrayWithCapacity:1];
    }
    [_videoArray addObject:view];
    
    [view setDeleteFinishBlock:^(BOOL success, id result) {
        if (success)
        {
            if (_videoArray && [_videoArray count] > 0)
            {
                if ([_videoArray containsObject:result])
                {
                    [_videoArray removeObject:result];
                }
            }
        }
    }];
    
    [[SRScreenRecorder sharedInstance] setVideoArray:_videoArray];
}

#pragma mark - pickVideoBorders
- (void)didSelectedBorderIndex:(NSInteger)styleIndex
{
    NSLog(@"didSelectedBorderIndex: %lu", (long)styleIndex);
    
    if (styleIndex == 0)
    {
        [_borderImageView setImage:nil];
        return;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"border_%lu.png", (long)styleIndex];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    image = scaleImage(image, _borderImageView.bounds.size);
    [_borderImageView setImage:image];
}

#pragma mark - pickGif
- (void)pickGifFromCustom
{
    NSLog(@"pickGifFromCustom");
    
    _mediaType = kEmbededGif;
    
    self.bottomControlView.contentOffset = CGPointMake(0, 0);
    [self showBottomControlView];
}

#pragma mark - ScrollSelectViewDelegate
- (void)didSelectedGifIndex:(NSInteger)styleIndex
{
    NSLog(@"didSelectedGifIndex: %ld", (long)styleIndex);
    
    [self initEmbededGifView:styleIndex];
}

#pragma mark - InitEmbededGifView
- (void)initEmbededGifView:(NSInteger)styleIndex
{
    NSString *imageName = [NSString stringWithFormat:@"gif_%lu.gif", (long)styleIndex];
    StickerView *view = [[StickerView alloc] initWithFilePath:getFilePath(imageName)];
    CGFloat ratio = MIN( (0.3 * self.videoContentView.width) / view.width, (0.3 * self.videoContentView.height) / view.height);
    [view setScale:ratio];
    CGFloat gap = 50;
    view.center = CGPointMake(self.videoContentView.width/2 - gap, self.videoContentView.height/2 - gap);
    [_captureContentView addSubview:view];
    
    [StickerView setActiveStickerView:view];
    
    if (!_gifArray)
    {
        _gifArray = [NSMutableArray arrayWithCapacity:1];
    }
    [_gifArray addObject:view];
    
    [view setDeleteFinishBlock:^(BOOL success, id result) {
        if (success)
        {
            if (_gifArray && [_gifArray count] > 0)
            {
                if ([_gifArray containsObject:result])
                {
                    [_gifArray removeObject:result];
                }
            }
        }
    }];
    
    [[SRScreenRecorder sharedInstance] setGifArray:_gifArray];
}

#pragma mark - Default Setting
- (void)defaultVideoSetting:(NSURL *)url
{
    // Setting
    [self playDemoVideo:[url absoluteString] withinVideoPlayerController:_videoPlayerController1];
    
    NSString *videoReadyHint = [NSString stringWithFormat:@"%@%@", GBLocalizedString(@"VideoContent"), GBLocalizedString(@"Ready")];
    _videoReadyLabel.text = videoReadyHint;
    
    [self showVideoPlayView:TRUE];
    
    UIImage *imageVideo = getImageFromVideoFrame(url, kCMTimeZero);
    if (imageVideo)
    {
        if (imageVideo.size.width <= imageVideo.size.height)
        {
            [_videoView1 setContentMode:UIViewContentModeScaleAspectFit];
            [_videoView2 setContentMode:UIViewContentModeScaleAspectFit];
        }
        else
        {
            [_videoView1 setContentMode:UIViewContentModeScaleAspectFill];
            [_videoView2 setContentMode:UIViewContentModeScaleAspectFill];
        }
    }
}

- (void)defaultImageSetting
{
    _videoView1.image = nil;
    _videoView2.image = nil;
}

#pragma mark - View Lifecycle

- (void)createSplit2View
{
    CGFloat statusBarHeight = iOS7AddStatusHeight;
    CGFloat navHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    CGFloat gap = 20, len = MIN(((CGRectGetHeight(self.view.frame) - navHeight - statusBarHeight - 2*gap)/2), (CGRectGetWidth(self.view.frame) - navHeight - statusBarHeight - 2*gap));
    self.captureContentView =  [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - len/2, CGRectGetMidY(self.view.frame) - len - gap/2, len, 2*len)];
    [self.captureContentView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_captureContentView];
    
    _videoView1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_captureContentView.bounds), CGRectGetMinY(_captureContentView.bounds), len, len)];
    _videoView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_videoView1.bounds), CGRectGetMidY(_captureContentView.bounds), len, len)];
    [_videoView1 setBackgroundColor:[UIColor clearColor]];
    [_videoView1 setContentMode:UIViewContentModeScaleAspectFit];
    [_videoView2 setBackgroundColor:[UIColor clearColor]];
    [_videoView2 setContentMode:UIViewContentModeScaleAspectFit];
    
    [self defaultImageSetting];
    
//    _videoView1.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePickVideo)];
//    tapRecognizer.numberOfTapsRequired = 1;
//    tapRecognizer.numberOfTouchesRequired = 1;
//    [_videoView1 addGestureRecognizer:tapRecognizer];
    
    [_captureContentView addSubview:_videoView1];
    [_captureContentView addSubview:_videoView2];
}

- (void)createRecommendAppView
{
    CGFloat statusBarHeight = iOS7AddStatusHeight;
    CGFloat navHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    CGFloat height = 30;
    UIView *recommendAppView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - height - navHeight - statusBarHeight, CGRectGetWidth(self.view.frame), height)];
    [recommendAppView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:recommendAppView];
    
    [self createRecommendAppButtons:recommendAppView];
}

- (void)createLabelHint
{
    CGFloat gap = 5, heightLabel = 18;
    NSString *fontName = @"迷你简启体"; // GBLocalizedString(@"FontName");
    CGFloat fontSize = 16;
    if (!LargeScreen)
    {
        gap = 0;
    }
    _videoReadyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_captureContentView.frame), CGRectGetMinY(_captureContentView.frame) - 2*heightLabel - gap, CGRectGetWidth(self.view.frame) - CGRectGetMinX(_captureContentView.frame), heightLabel)];
    _videoReadyLabel.backgroundColor = [UIColor clearColor];
    _videoReadyLabel.font = [UIFont fontWithName:fontName size:fontSize];
    _videoReadyLabel.textColor = kBrightBlue;
    _videoReadyLabel.textAlignment = NSTextAlignmentLeft;
    _videoReadyLabel.numberOfLines = 0;
    _videoReadyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:_videoReadyLabel];

    _audioReadyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_videoReadyLabel.frame), CGRectGetMinY(_captureContentView.frame) - heightLabel - gap, CGRectGetWidth(_videoReadyLabel.frame), heightLabel)];
    _audioReadyLabel.backgroundColor = [UIColor clearColor];
    _audioReadyLabel.font = [UIFont fontWithName:fontName size:fontSize];
    _audioReadyLabel.textColor = kBrightBlue;
    _audioReadyLabel.textAlignment = NSTextAlignmentLeft;
    _audioReadyLabel.numberOfLines = 0;
    _audioReadyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:_audioReadyLabel];
    
    NSString *videoReadyHint = [NSString stringWithFormat:@"%@%@", GBLocalizedString(@"VideoContent"), GBLocalizedString(@"NoReady")];
    _videoReadyLabel.text = videoReadyHint;
    NSString *audioReadyHint = [NSString stringWithFormat:@"%@%@", GBLocalizedString(@"AudioContent"), GBLocalizedString(@"NoReady")];
    _audioReadyLabel.text = audioReadyHint;
}

- (void)createVideoPlayView
{
    _videoContentView =  [[UIScrollView alloc] initWithFrame:_captureContentView.bounds];
    [_videoContentView setBackgroundColor:[UIColor clearColor]];
    [_captureContentView addSubview:_videoContentView];
    
    // Video player 1
    _videoPlayerController1 = [[PBJVideoPlayerController alloc] init];
    _videoPlayerController1.delegate = self;
    _videoPlayerController1.view.frame = _videoView1.bounds;
    _videoPlayerController1.view.clipsToBounds = YES;
    
    [self addChildViewController:_videoPlayerController1];
    [_videoContentView addSubview:_videoPlayerController1.view];
    
    _playButton1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_button"]];
    _playButton1.center = _videoPlayerController1.view.center;
    [_videoPlayerController1.view addSubview:_playButton1];
    
    // Close video player
    UIImage *imageClose = [UIImage imageNamed:@"close"];
    CGFloat width = 50;
    _closeVideoPlayerButton1 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_videoContentView.frame) - width/2, CGRectGetMinY(_videoContentView.frame) - width/2, width, width)];
    _closeVideoPlayerButton1.center = _captureContentView.frame.origin;
    [_closeVideoPlayerButton1 setImage:imageClose forState:(UIControlStateNormal)];
    [_closeVideoPlayerButton1 addTarget:self action:@selector(handleCloseVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeVideoPlayerButton1];
    _closeVideoPlayerButton1.hidden = YES;
    
    // Border
    _borderImageView = [[UIImageView alloc] initWithFrame:_videoPlayerController1.view.frame];
    [_borderImageView setBackgroundColor:[UIColor clearColor]];
    [_captureContentView addSubview:_borderImageView];
}

- (void)createNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    NSString *fontName = GBLocalizedString(@"FontName");
    CGFloat fontSize = 20;
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor colorWithRed:1 green:1 blue:1 alpha:1], NSForegroundColorAttributeName,
                                                                     shadow,
                                                                     NSShadowAttributeName,
                                                                     [UIFont fontWithName:fontName size:fontSize], NSFontAttributeName,
                                                                     nil]];
    
    self.title = GBLocalizedString(@"VideoReflection");
}

- (void)createNavigationItem
{
    NSString *fontName = GBLocalizedString(@"FontName");
    CGFloat fontSize = 18;
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:GBLocalizedString(@"Demo") style:UIBarButtonItemStylePlain target:self action:@selector(handleDemo)];
//    [leftItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:fontName size:fontSize]} forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:GBLocalizedString(@"Start") style:UIBarButtonItemStylePlain target:self action:@selector(showCustomActionSheet:withEvent:)];
    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:fontName size:fontSize]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)createPopTipView
{
    NSArray *colorSchemes = [NSArray arrayWithObjects:
                             [NSArray arrayWithObjects:[NSNull null], [NSNull null], nil],
                             [NSArray arrayWithObjects:[UIColor colorWithRed:134.0/255.0 green:74.0/255.0 blue:110.0/255.0 alpha:1.0], [NSNull null], nil],
                             [NSArray arrayWithObjects:[UIColor darkGrayColor], [NSNull null], nil],
                             [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor darkTextColor], nil],
                             nil];
    NSArray *colorScheme = [colorSchemes objectAtIndex:foo4random()*[colorSchemes count]];
    UIColor *backgroundColor = [colorScheme objectAtIndex:0];
    UIColor *textColor = [colorScheme objectAtIndex:1];
    
    NSString *hint = GBLocalizedString(@"UsageHint");
    _popTipView = [[CMPopTipView alloc] initWithMessage:hint];
    if (backgroundColor && ![backgroundColor isEqual:[NSNull null]])
    {
        _popTipView.backgroundColor = backgroundColor;
    }
    if (textColor && ![textColor isEqual:[NSNull null]])
    {
        _popTipView.textColor = textColor;
    }
    
    _popTipView.animation = arc4random() % 2;
    _popTipView.has3DStyle = NO;
    _popTipView.dismissTapAnywhere = YES;
    [_popTipView autoDismissAnimated:YES atTimeInterval:6.0];
    
    [_popTipView presentPointingAtView:findRightNavBarItemView(self.navigationController.navigationBar) inView:self.navigationController.view animated:YES];
}

- (void)createBottomControlView
{
    CGFloat height = 50;
    CGFloat navHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    self.bottomControlView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - navHeight - iOS7AddStatusHeight - height, CGRectGetWidth(self.view.frame), height)];
    [self.view addSubview:_bottomControlView];
    [self.bottomControlView setContentSize:CGSizeMake(CGRectGetWidth(self.bottomControlView.frame) * 2, CGRectGetHeight(self.bottomControlView.frame))];
    [self.bottomControlView setPagingEnabled:YES];
    [self.bottomControlView setScrollEnabled:NO];
    [_bottomControlView setHidden:YES];
}

- (void)createGifScrollView
{
    _gifScrollView = [[ScrollSelectView alloc] initWithFrameFromGif:CGRectMake(0, 0, CGRectGetWidth(self.bottomControlView.frame), CGRectGetHeight(self.bottomControlView.frame))];
    [_gifScrollView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _gifScrollView.delegateSelect = self;
    [_bottomControlView addSubview:_gifScrollView];
}

- (void)createVideoBorderScrollView
{
    CGFloat height = 50;
    _borderView = [[ScrollSelectView alloc] initWithFrameFromBorder:CGRectMake(0, CGRectGetMinY(self.bottomControlView.frame) - height, CGRectGetWidth(self.bottomControlView.frame), CGRectGetHeight(self.bottomControlView.frame))];
    [_borderView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _borderView.delegateSelect = self;
    [self.view addSubview:_borderView];
    
    [self createFrameLine:_borderView];
    [_borderView setHidden:YES];
}

- (void)createFrameLine:(UIView *)view
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(view.bounds), CGRectGetMaxY(view.bounds) - 0.5, CGRectGetWidth(view.bounds), 1)];
    [lineView setBackgroundColor:[UIColor orangeColor]];
    [view addSubview:lineView];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [ScrollSelectView getDefaultFilelist];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc");
    
    [self clearEmbeddedVideoImageViewArray];
    [self clearEmbeddedVideoArray];
    [self clearEmbeddedGifArray];
    
    _mediaType = kNone;
    _videoEmbededPickURL = nil;
    _videoBackgroundPickURL = nil;
    _videoFileSize = 0;
    _captureVideoSampleTime = kCMTimeInvalid;
    
    _sampleAccessor = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _embeddedVideoImageViewArray = nil;
    _videoArray = nil;
    _videoEmbededPickURL = nil;

    _gifArray = nil;
    _mediaType = kNone;
    
    _videoFileSize = 0;
    _videoBackgroundPickURL = nil;
    _captureVideoSampleTime = kCMTimeInvalid;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sharebg3"]];
    
    [self createNavigationBar];
    [self createNavigationItem];
    
    [self createSplit2View];
    [self createVideoPlayView];
    [self createLabelHint];
    [self createPopTipView];
    
    [self createRecommendAppView];

    [self createBottomControlView];
    [self createGifScrollView];
    [self createVideoBorderScrollView];
    
    NSString *demoVideoPath = getFilePath(DemoDestinationVideoName);
    [self playDemoVideo:demoVideoPath withinVideoPlayerController:_videoPlayerController1];
    
    // Write a temp video
//    [[SRScreenRecorder sharedInstance] writeExportedVideoToAssetsLibrary:demoVideoPath];
    
    // Delete temp files
    [self deleteTempDirectory];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Contace us
    [self createContactUS];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Touchs
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    // Deselect
    [StickerView setActiveStickerView:nil];
    [VideoView setActiveVideoView:nil];
    
    // Hide scroll view
    [self hiddenBottomControlView];
}


#pragma mark - Show/Hide
- (void)showVideoPlayView:(BOOL)show
{
    if (show)
    {
        _videoContentView.hidden = NO;
        _closeVideoPlayerButton1.hidden = NO;
    }
    else
    {
        if (_videoPlayerController1.playbackState == PBJVideoPlayerPlaybackStatePlaying)
        {
            [_videoPlayerController1 stop];
        }
        
        _videoContentView.hidden = YES;
        _closeVideoPlayerButton1.hidden = YES;
    }
}

- (void)showBottomControlView
{
    CGFloat height = 50;
    [_bottomControlView setHidden:NO];
    [_borderView setHidden:NO];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.bottomControlView.frame =  CGRectMake(0, CGRectGetHeight(self.view.frame) - height, CGRectGetWidth(self.view.frame), height);
                         self.borderView.frame = CGRectMake(0, CGRectGetMinY(_bottomControlView.frame) - height, CGRectGetWidth(self.view.frame), height);
                     } completion:^(BOOL finished) {
                         
                     }];
}


- (void)hiddenBottomControlView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.bottomControlView.frame =  CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 1);
                         self.borderView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 1);
                     } completion:^(BOOL finished) {
                         
                         [self.bottomControlView setHidden:YES];
                         [_borderView setHidden:YES];
                     }];
    
    
}

#pragma mark - Handle Event
- (void)handleCloseVideo
{
    NSLog(@"handleCloseVideo");
    
    [self showVideoPlayView:FALSE];
    [self hiddenBottomControlView];
    
    self.videoBackgroundPickURL = nil;
    self.videoEmbededPickURL = nil;
    [self.borderImageView setImage:nil];
    
    [self clearEmbeddedGifArray];
    [self clearEmbeddedVideoArray];
    [self clearEmbeddedVideoImageViewArray];
    
    NSString *videoReadyHint = [NSString stringWithFormat:@"%@%@", GBLocalizedString(@"VideoContent"), GBLocalizedString(@"NoReady")];
    _videoReadyLabel.text = videoReadyHint;
}

#pragma mark - Clear
- (void)clearEmbeddedGifArray
{
    [StickerView setActiveStickerView:nil];
    
    if (_gifArray && [_gifArray count] > 0)
    {
        for (StickerView *view in _gifArray)
        {
            [view removeFromSuperview];
        }
        
        [_gifArray removeAllObjects];
        _gifArray = nil;
    }
}

- (void)clearEmbeddedVideoArray
{
    [VideoView setActiveVideoView:nil];
    
    if (_videoArray && [_videoArray count] > 0)
    {
        for (VideoView *view in _videoArray)
        {
            [view removeFromSuperview];
        }
        
        [_videoArray removeAllObjects];
        _videoArray = nil;
    }
}

- (void)clearEmbeddedVideoImageViewArray
{
    if (_embeddedVideoImageViewArray && [_embeddedVideoImageViewArray count] > 0)
    {
        for (UIImageView *view in _embeddedVideoImageViewArray)
        {
            [view removeFromSuperview];
        }
        
        [_embeddedVideoImageViewArray removeAllObjects];
        _embeddedVideoImageViewArray = nil;
    }
}

#pragma mark - reCalc on the basis of video size & view size
- (CGSize)reCalcVideoViewSize:(NSString *)videoPath
{
    CGSize resultSize = CGSizeZero;
    if (isStringEmpty(videoPath))
    {
        return resultSize;
    }
    
    UIImage *videoFrame = getImageFromVideoFrame(getFileURL(videoPath), kCMTimeZero);
    if (!videoFrame || videoFrame.size.height < 1 || videoFrame.size.width < 1)
    {
        return resultSize;
    }
    
    NSLog(@"reCalcVideoViewSize: %@, width: %f, height: %f", videoPath, videoFrame.size.width, videoFrame.size.height);
    
    CGFloat statusBarHeight = iOS7AddStatusHeight;
    CGFloat navHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    CGFloat gap = 10, bottomScrollViewHeight = 50;
    CGFloat height = CGRectGetHeight(self.view.frame) - navHeight - statusBarHeight - bottomScrollViewHeight - 2*gap;
    CGFloat width = CGRectGetWidth(self.view.frame) - 2*gap;
    if (height < width)
    {
        width = height;
    }
    else if (height > width)
    {
        height = width;
    }
    CGFloat videoHeight = videoFrame.size.height, videoWidth = videoFrame.size.width;
    CGFloat scaleRatio = videoHeight/videoWidth;
    CGFloat resultHeight = 0, resultWidth = 0;
    if (videoHeight <= height && videoWidth <= width)
    {
        resultHeight = videoHeight;
        resultWidth = videoWidth;
    }
    else if (videoHeight <= height && videoWidth > width)
    {
        resultWidth = width;
        resultHeight = height*scaleRatio;
    }
    else if (videoHeight > height && videoWidth <= width)
    {
        resultHeight = height;
        resultWidth = width/scaleRatio;
    }
    else
    {
        if (videoHeight < videoWidth)
        {
            resultWidth = width;
            resultHeight = height*scaleRatio;
        }
        else if (videoHeight == videoWidth)
        {
            resultWidth = width;
            resultHeight = height;
        }
        else
        {
            resultHeight = height;
            resultWidth = width/scaleRatio;
        }
    }
    
    resultSize = CGSizeMake(resultWidth, resultHeight);
    return resultSize;
}

#pragma mark - showDemoVideo
- (void)showDemoVideo:(NSString *)videoPath
{
    CGFloat statusBarHeight = iOS7AddStatusHeight;
    CGFloat navHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    CGSize size = [self reCalcVideoViewSize:videoPath];
    _demoVideoContentView =  [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - size.width/2, CGRectGetMidY(self.view.frame) - size.height/2 - navHeight - statusBarHeight, size.width, size.height)];
    [self.view addSubview:_demoVideoContentView];
    
    // Video player of destination
    _demoDestinationVideoPlayerController = [[PBJVideoPlayerController alloc] init];
    _demoDestinationVideoPlayerController.view.frame = _demoVideoContentView.bounds;
    _demoDestinationVideoPlayerController.view.clipsToBounds = YES;
    _demoDestinationVideoPlayerController.videoView.videoFillMode = AVLayerVideoGravityResizeAspect;
    _demoDestinationVideoPlayerController.delegate = self;
//    _demoDestinationVideoPlayerController.playbackLoops = YES;
    [_demoVideoContentView addSubview:_demoDestinationVideoPlayerController.view];
    
   _playDemoButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_button"]];
    _playDemoButton.center = _demoDestinationVideoPlayerController.view.center;
    [_demoDestinationVideoPlayerController.view addSubview:_playDemoButton];
    
    // Popup modal view
    [[KGModal sharedInstance] setCloseButtonType:KGModalCloseButtonTypeLeft];
    [[KGModal sharedInstance] showWithContentView:_demoVideoContentView andAnimated:YES];
    
    [self playDemoVideo:videoPath withinVideoPlayerController:_demoDestinationVideoPlayerController];
}

- (void)showDemoFromOriginalVideo:(NSString *)originalVideo withDestinationVideo:(NSString *)destinationVideo
{
    CGFloat navHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    CGFloat hintHeight = 30;
    CGFloat gap = 20, len = MIN(((CGRectGetHeight(self.view.frame) - navHeight - 2*hintHeight - 2*gap)/2), (CGRectGetWidth(self.view.frame) - 2*hintHeight - 2*gap));
    _demoVideoContentView =  [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - len/2, CGRectGetMidY(self.view.frame) - len + navHeight, len, 2*len + 2*hintHeight)];
    [self.view addSubview:_demoVideoContentView];
    
    // Start image View
    UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_demoVideoContentView.frame), hintHeight)];
    [startView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sharebg3"]]];
    [_demoVideoContentView addSubview:startView];
    
    CGFloat imageWidth = 100, gapImageArrorw = 0;
    UIImageView *startImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_demoVideoContentView.frame)/2 - imageWidth/2, gapImageArrorw, imageWidth, hintHeight - 2* gapImageArrorw)];
    [startImageView setContentMode:UIViewContentModeScaleAspectFit];
    startImageView.image = [UIImage imageNamed:@"StartLetter"];
    [_demoVideoContentView addSubview:startImageView];
    
    // Video player of original
    _demoOriginalVideoPlayerController = [[PBJVideoPlayerController alloc] init];
    _demoOriginalVideoPlayerController.view.frame = CGRectMake(0, CGRectGetMaxY(startImageView.frame), len, len);
    _demoOriginalVideoPlayerController.view.clipsToBounds = YES;
    [_demoVideoContentView addSubview:_demoOriginalVideoPlayerController.view];
    
    // Goal image View
    UIView *goalView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_demoOriginalVideoPlayerController.view.frame), CGRectGetWidth(_demoVideoContentView.frame), hintHeight)];
    [goalView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sharebg3"]]];
    [_demoVideoContentView addSubview:goalView];
    
    UIImageView *goalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_demoVideoContentView.frame)/2 - imageWidth/2, CGRectGetMaxY(_demoOriginalVideoPlayerController.view.frame) + gapImageArrorw, imageWidth, hintHeight - 2* gapImageArrorw)];
    [goalImageView setContentMode:UIViewContentModeScaleAspectFit];
    goalImageView.image = [UIImage imageNamed:@"GoalLetter"];
    [_demoVideoContentView addSubview:goalImageView];
    
    // Video player of destination
    _demoDestinationVideoPlayerController = [[PBJVideoPlayerController alloc] init];
    _demoDestinationVideoPlayerController.view.frame = CGRectMake(0, CGRectGetMaxY(goalImageView.frame), len, len);
    _demoDestinationVideoPlayerController.view.clipsToBounds = YES;
    _demoDestinationVideoPlayerController.videoView.videoFillMode = AVLayerVideoGravityResizeAspectFill;
    [_demoVideoContentView addSubview:_demoDestinationVideoPlayerController.view];
    
    // Popup modal view
    [[KGModal sharedInstance] setCloseButtonType:KGModalCloseButtonTypeLeft];
    [[KGModal sharedInstance] showWithContentView:_demoVideoContentView andAnimated:YES];
    
    // Play
    NSString *originalVideoPath = originalVideo;
    [self playDemoVideo:originalVideoPath withinVideoPlayerController:_demoOriginalVideoPlayerController];
    NSString *destinationVideoPath = destinationVideo;
    [self playDemoVideo:destinationVideoPath withinVideoPlayerController:_demoDestinationVideoPlayerController];
}

#pragma mark - Convert
- (void)handleConvert
{
    if (!_videoBackgroundPickURL)
    {
        NSString *message = GBLocalizedString(@"VideoIsEmptyHint");
        showAlertMessage(message, nil);
        return;
    }
    
    [self prepareBeforeScreenRecording];
    [self screenRecording];
}

- (void)prepareBeforeScreenRecording
{
    [StickerView setActiveStickerView:nil];
    [VideoView setActiveVideoView:nil];
    
    if (_gifArray && [_gifArray count] > 0)
    {
        for (StickerView *view in _gifArray)
        {
            [_captureContentView bringSubviewToFront:view];
            [view replayGif];
        }
    }
    
    if (_videoArray && [_videoArray count] > 0)
    {
        [self clearEmbeddedVideoImageViewArray];
        if (!_embeddedVideoImageViewArray)
        {
            _embeddedVideoImageViewArray = [NSMutableArray arrayWithCapacity:1];
        }
        
        for (VideoView *view in _videoArray)
        {
            UIImageView *animatedImageView = [[UIImageView alloc] init];
            animatedImageView.frame = [view getInnerFrame];
            animatedImageView.transform = CGAffineTransformMakeRotation([view getRotateAngle]);
            CGFloat duration = [[VideoAnimationLayer sharedInstance] captureVideoSample:_videoEmbededPickURL saveToCGImage:NO];
            animatedImageView.animationDuration = duration;
            animatedImageView.animationRepeatCount = INFINITY;
            animatedImageView.animationImages = [NSArray arrayWithArray:[[VideoAnimationLayer sharedInstance] getImageVideoFrames]];
            [_captureContentView addSubview:animatedImageView];
            [_captureContentView bringSubviewToFront:animatedImageView];
            
            [_embeddedVideoImageViewArray addObject:animatedImageView];
            [animatedImageView startAnimatingWithCompletionBlock:^(BOOL success){
               
                NSLog(@"Completed animatedImageView: %@",[NSNumber numberWithBool:success]);
            }];
        }
    }
}

- (void)screenRecording
{
    ProgressBarShowLoading(GBLocalizedString(@"Processing"));
    
    [self showVideoPlayView:FALSE];
    
    [self initVideoSample:_videoBackgroundPickURL];
    _videoFileSize = fileSizeAtPath([_videoBackgroundPickURL relativePath]);
    
//    NSUInteger videoLength = MIN(MaxVideoLength, [self getVideoDuration:_videoPickURL]);
//    NSLog(@"videoLength is: %ld", (unsigned long)videoLength);

//    [[SRScreenRecorder sharedInstance] setAutosaveDuration:videoLength];
    [[SRScreenRecorder sharedInstance] setCaptureViewBlock: ^(void) {
        
        return [self captureVideoView:_captureContentView];
    }];
    [[SRScreenRecorder sharedInstance] setCaptureVideoSampleTimeBlock: ^(void) {
        
        return _captureVideoSampleTime;
    }];
    [[SRScreenRecorder sharedInstance] startRecording:_captureContentView.bounds.size];
    [[SRScreenRecorder sharedInstance] setExportProgressBlock: ^(NSNumber *percentage) {
        
        // Export progress
        [self retrievingProgress:percentage title:GBLocalizedString(@"SavingVideo")];
    }];
    [[SRScreenRecorder sharedInstance] setFinishRecordingBlock: ^(BOOL success, id result) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (success)
            {
                ProgressBarDismissLoading(GBLocalizedString(@"Success"));
            }
            else
            {
                ProgressBarDismissLoading(GBLocalizedString(@"Failed"));
            }
            
            // Alert
            NSString *ok = GBLocalizedString(@"OK");
            [UIAlertView showWithTitle:nil
                               message:result
                     cancelButtonTitle:ok
                     otherButtonTitles:nil
                              tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  if (buttonIndex == [alertView cancelButtonIndex])
                                  {
                                      NSLog(@"Alert Cancelled");
                                      
                                      [NSThread sleepForTimeInterval:0.5];
                                      
                                      // Demo result video
                                      NSString *outputPath = [SRScreenRecorder sharedInstance].filenameBlock();
                                      [self showDemoVideo:outputPath];
                                  }
                              }];
            
            [self clearEmbeddedVideoImageViewArray];
            
            [self defaultImageSetting];
            [self showVideoPlayView:TRUE];
            
        });
    }];
}

- (void)playDemoVideo:(NSString*)inputVideoPath withinVideoPlayerController:(PBJVideoPlayerController*)videoPlayerController
{
    videoPlayerController.videoPath = inputVideoPath;
    [videoPlayerController playFromBeginning];
}

- (void)initVideoSample:(NSURL *)videoURL
{
    AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    _sampleAccessor = [[MIMovieVideoSampleAccessor alloc]  initWithMovie:videoAsset
                                                         firstSampleTime:kCMTimeZero
                                                                  tracks:nil
                                                           videoSettings:nil
                                                        videoComposition:nil];
}

#pragma mark - Capture Video Sample
- (BOOL)captureVideoSample
{
    MICMSampleBuffer *buffer = [_sampleAccessor nextSampleBuffer];
    if (!buffer)
    {
        _captureVideoSampleTime = kCMTimeInvalid;
        [[SRScreenRecorder sharedInstance] stopRecording];
        return FALSE;
    }
    
    // Calc & Show precentage
    CGFloat currentSeconds = _sampleAccessor.currentTime.value / _sampleAccessor.currentTime.timescale;
    CGFloat totalSeconds = _sampleAccessor.assetDuration.value / _sampleAccessor.assetDuration.timescale;
    NSString *currentPrecentage = [NSString stringWithFormat:@"%d%%", (int)(currentSeconds/totalSeconds * 100)];
    ProgressBarUpdateLoading(GBLocalizedString(@"Processing"), currentPrecentage);
    
    // Get frame image
    CMSampleBufferRef sampleBuffer = buffer.CMSampleBuffer;
    _captureVideoSampleTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    UIImage *uiImage = imageFromSampleBuffer(sampleBuffer);
    
    if (uiImage.size.width != uiImage.size.height && _videoFileSize >= 3*(1024.0*1024.0))
    {
        _videoView1.image = imageFixOrientation(squareImageFromImage(uiImage));
    }
    else
    {
        _videoView1.image = imageFixOrientation(uiImage);
    }
    
    _videoView1.image = [self captureViewHalfTop:_captureContentView];
    _videoView2.image = [_videoView1.image reflectionWithAlpha:0.5];
    
    uiImage = nil;
    
    return TRUE;
}

- (UIImage *)captureVideoView:(UIView *)view
{
    if (![self captureVideoSample])
    {
        return nil;
    };
    
    return [self captureView:view];
}

- (UIImage *)captureView:(UIView *)view
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIImage *screenshot = nil;
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, scale);
    {
        if(UIGraphicsGetCurrentContext() == nil)
        {
            NSLog(@"UIGraphicsGetCurrentContext is nil. You may have a UIView (%@) with no really frame (%@)", [self class], NSStringFromCGRect(view.frame));
        }
        else
        {
            [view.layer renderInContext:UIGraphicsGetCurrentContext()];
            
            screenshot = UIGraphicsGetImageFromCurrentImageContext();
        }
    }
    UIGraphicsEndImageContext();
    
    return screenshot;
}

- (UIImage *)captureViewHalfTop:(UIView *)view
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIImage *screenshot = nil;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds)/2), NO, scale);
    {
        if(UIGraphicsGetCurrentContext() == nil)
        {
            NSLog(@"UIGraphicsGetCurrentContext is nil. You may have a UIView (%@) with no really frame (%@)", [self class], NSStringFromCGRect(view.frame));
        }
        else
        {
            [view.layer renderInContext:UIGraphicsGetCurrentContext()];
            
            screenshot = UIGraphicsGetImageFromCurrentImageContext();
        }
    }
    UIGraphicsEndImageContext();
    
    return screenshot;
}

#pragma mark - Progress callback
- (void)retrievingProgress:(id)progress title:(NSString *)text
{
    if (progress && [progress isKindOfClass:[NSNumber class]])
    {
        NSString *title = text ?text :GBLocalizedString(@"SavingVideo");
        NSString *currentPrecentage = [NSString stringWithFormat:@"%d%%", (int)([progress floatValue] * 100)];
        ProgressBarUpdateLoading(title, currentPrecentage);
    }
}

#pragma mark AppStore Open
- (void)showAppInAppStore:(NSString *)appId
{
    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
    if (isAllow)
    {
        // > iOS6.0
        SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
        sKStoreProductViewController.delegate = self;
        [self presentViewController:sKStoreProductViewController
                           animated:YES
                         completion:nil];
        [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: appId}completionBlock:^(BOOL result, NSError *error)
         {
             if (error)
             {
                 NSLog(@"%@",error);
             }
             
         }];
    }
    else
    {
        // < iOS6.0
        NSString *appUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8", appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
        
        //        UIWebView *callWebview = [[UIWebView alloc] init];
        //        NSURL *appURL =[NSURL URLWithString:appStore];
        //        [callWebview loadRequest:[NSURLRequest requestWithURL:appURL]];
        //        [self.view addSubview:callWebview];
    }
}

- (void)createRecommendAppButtons:(UIView *)containerView
{
    // Recommend App
    UIButton *beautyTime = [[UIButton alloc] init];
    [beautyTime setTitle:GBLocalizedString(@"BeautyTime")
                forState:UIControlStateNormal];
    
    UIButton *photoBeautify = [[UIButton alloc] init];
    [photoBeautify setTitle:GBLocalizedString(@"PhotoBeautify")
                   forState:UIControlStateNormal];
    
    [photoBeautify setTag:1];
    [beautyTime setTag:2];
    
    CGFloat gap = 0, height = 30, width = 80;
    CGFloat fontSize = 16;
    NSString *fontName = @"迷你简启体"; // GBLocalizedString(@"FontName");
    photoBeautify.frame =  CGRectMake(gap, gap, width, height);
    [photoBeautify.titleLabel setFont:[UIFont fontWithName:fontName size:fontSize]];
    [photoBeautify.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [photoBeautify setTitleColor:kLightBlue forState:UIControlStateNormal];
    [photoBeautify addTarget:self action:@selector(recommendAppButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    beautyTime.frame =  CGRectMake(CGRectGetWidth(containerView.frame) - width - gap, gap, width, height);
    [beautyTime.titleLabel setFont:[UIFont fontWithName:fontName size:fontSize]];
    [beautyTime.titleLabel setTextAlignment:NSTextAlignmentRight];
    [beautyTime setTitleColor:kLightBlue forState:UIControlStateNormal];
    [beautyTime addTarget:self action:@selector(recommendAppButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [containerView addSubview:photoBeautify];
    [containerView addSubview:beautyTime];
}

- (void)recommendAppButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag)
    {
        case 1:
        {
            // Photo Beautify
            //[self showAppInAppStore:@"919221990"];
            [self showAppInAppStore:@"945682627"];
            break;
        }
        case 2:
        {
            // BeautyTime
            [self showAppInAppStore:@"1006401631"];
            break;
        }
        default:
            break;
    }
    
    [button setSelected:YES];
}

#pragma mark - SKStoreProductViewControllerDelegate
// Dismiss contorller
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


@end
