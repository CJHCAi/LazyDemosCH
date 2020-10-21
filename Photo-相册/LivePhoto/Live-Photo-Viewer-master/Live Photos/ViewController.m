//
//  ViewController.m
//  Live Photos
//
//  Created by Jay Versluis on 30/09/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "ViewController.h"
@import Photos;
@import PhotosUI;
@import MobileCoreServices;

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHLivePhotoViewDelegate>

@property BOOL livePhotoIsAnimating;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)grabLivePhoto:(id)sender {
    
    // create an image picker
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    picker.delegate = self;
    
    // make sure we include Live Photos (otherwise we'll only get UIImages)
    NSArray *mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeLivePhoto];

    picker.mediaTypes = mediaTypes;
    
    // bring up the picker
    [self presentViewController:picker animated:YES completion:nil];
    
}

/**
 分享
 */
- (IBAction)shareLivePhoto:(id)sender {

    // share the Live Photo using an Activity View Controller
    
    // if we don't have a photo view, present warning and return
    if (![self.view viewWithTag:87]) {
        [self cannotShareLivePhotoWarning];
        return;
    }
    
    // grab a reference to the Photo View and Live Photo
    PHLivePhotoView *photoView = (PHLivePhotoView *)[self.view viewWithTag:87];
    PHLivePhoto *livePhoto = photoView.livePhoto;
    
    // build an activity view controller
    UIActivityViewController *activityView = [[UIActivityViewController alloc]initWithActivityItems:@[livePhoto] applicationActivities:nil];
    [self presentViewController:activityView animated:YES completion:^{
        // let's see if we need to do anything here
        NSLog(@"Activity View Controller has finidhed.");
    }];
}

- (IBAction)playHint:(id)sender {
    
    // 抓住我们的照片视图的引用
    PHLivePhotoView *photoView = [self.view viewWithTag:87];
    
    //如果我们目前动画,停止并忽略此请求
    if (self.livePhotoIsAnimating) {
        [photoView stopPlayback];
        return;
    }
    
    // play short "hint" animation
    [photoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
}

/**
 播放
 */
- (IBAction)playFullAnimation:(id)sender {
    
    // grab a reference to our Photo View
    PHLivePhotoView *photoView = [self.view viewWithTag:87];
    
    // if we're currently animating, stop and ignore this request
    if (self.livePhotoIsAnimating) {
        [photoView stopPlayback];
        return;
    }
    
    // play full animation
    [photoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
}

# pragma mark - Image Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // dismiss the picker
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // if we have a live photo view already, remove it
    if ([self.view viewWithTag:87]) {
        UIView *subview = [self.view viewWithTag:87];
        [subview removeFromSuperview];
    }
    
    // check if this is a Live Image, otherwise present a warning
    PHLivePhoto * photo = [info objectForKey:UIImagePickerControllerLivePhoto];
    if (!photo) {
        [self notLivePhotoWarning];
        return;
    }
    
    // create a Live Photo View
    PHLivePhotoView *photoView = [[PHLivePhotoView alloc]initWithFrame:self.view.bounds];
    photoView.livePhoto = [info objectForKey:UIImagePickerControllerLivePhoto];
    photoView.contentMode = UIViewContentModeScaleAspectFill;
    photoView.delegate=self;
    photoView.tag = 87;
    
    // bring up the Live Photo View
    [self.view addSubview:photoView];
    [self.view sendSubviewToBack:photoView];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)notLivePhotoWarning {
    
    // create an alert view
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not a Live Photo" message:@"Sadly this is a standard UIImage so we can't show it in our Live Photo View. Try another one." preferredStyle:UIAlertControllerStyleAlert];
    
    // add a single action
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Thanks, Phone!" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    
    // and display it
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)cannotShareLivePhotoWarning {
    
    // create an alert view
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Live Photo to share" message:@"There's nothing showing in the Live Photo View, so you can't share anything. Pick a Live Photo first and try again." preferredStyle:UIAlertControllerStyleAlert];
    
    // add a single action
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Thanks ;-)" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    
    // and display it
    [self presentViewController:alert animated:YES completion:nil];
}

# pragma mark - Live Photo View Delegate

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView willBeginPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle {
    
    self.livePhotoIsAnimating = YES;
}

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView didEndPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle {
    
    self.livePhotoIsAnimating = NO;
}

# pragma mark - Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        // rotate Live Photo VIew during rotation
        if (![self.view viewWithTag:87]) {
            return;
        }
        PHLivePhotoView *photoView = [self.view viewWithTag:87];
        photoView.bounds = self.view.bounds;
        photoView.center = self.view.center;
        
    } completion:nil];
}

@end
