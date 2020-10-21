//
//  ViewController.m
//  LivePhotoDemo
//
//  Created by akixie on 16/2/25.
//  Copyright © 2016年 Aki.Xie. All rights reserved.
//

#import "ViewController.h"
@import Photos;
@import PhotosUI;
@import MobileCoreServices;

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHLivePhotoViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *livePhotoView;
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
- (IBAction)selectLivePhotoEvents:(id)sender {
    
    // create an image picker
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    picker.delegate = self;
    
    // make sure we include Live Photos (otherwise we'll only get UIImages)
    NSArray *mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeLivePhoto];
    picker.mediaTypes = mediaTypes;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)playHint:(id)sender {
    PHLivePhotoView *photoView = [self.livePhotoView viewWithTag:404];
    if (self.livePhotoIsAnimating) {
        [photoView stopPlayback];
        return;
    }
    
    // play short "hint" animation
    [photoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
}

- (IBAction)playFull:(id)sender {
    PHLivePhotoView *photoView = [self.livePhotoView viewWithTag:404];
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
    if ([self.livePhotoView viewWithTag:404]) {
        UIView *subview = [self.livePhotoView viewWithTag:404];
        [subview removeFromSuperview];
    }
    
    // check if this is a Live Image, otherwise present a warning
    PHLivePhoto *photo = [info objectForKey:UIImagePickerControllerLivePhoto];
    if (!photo) {
        [self notLivePhotoWarning];
        return;
    }
    
    // create a Live Photo View
    PHLivePhotoView *photoView = [[PHLivePhotoView alloc]initWithFrame:self.view.bounds];
    photoView.livePhoto = [info objectForKey:UIImagePickerControllerLivePhoto];
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    photoView.tag = 404;
    
    // bring up the Live Photo View
    [self.livePhotoView addSubview:photoView];
    [self.livePhotoView sendSubviewToBack:photoView];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)notLivePhotoWarning {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:@"Not Live Photo" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
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
        if (![self.view viewWithTag:404]) {
            return;
        }
        PHLivePhotoView *photoView = [self.view viewWithTag:404];
        photoView.bounds = self.livePhotoView.bounds;
        photoView.center = self.livePhotoView.center;
        
    } completion:nil];
}

@end
