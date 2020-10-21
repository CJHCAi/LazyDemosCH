//
//  RecordVideoViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/1/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "RecordVideoViewController.h"
@import MobileCoreServices;
@import AVFoundation;
#import "AppDelegate.h"
#import "RecordVideoViewController+AllowEditing.h"
#import "ViewController.h"

@interface RecordVideoViewController()

@property (nonatomic) NSURL *videoURL;
@property (nonatomic) NSURL *gifURL;
@property (weak, nonatomic) IBOutlet UIImageView *previousGifImageView;

@end

@implementation RecordVideoViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

# pragma mark - Video Recording Methods
- (IBAction)launchCamera:(id)sender {
    [self startCameraFromViewController:self];
}

- (BOOL)startCameraFromViewController:(UIViewController*)viewController {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        return false;
    } else {
        
        UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
        cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraController.mediaTypes = @[(NSString *) kUTTypeMovie];
        cameraController.allowsEditing = false;
        cameraController.delegate = self;
        
        [self presentViewController:cameraController animated:TRUE completion:nil];
        return true;
    }
}

# pragma mark - UIImagePickerController Delegate methods

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

# pragma mark - Gif Conversion and Display methods

// Allows Editing
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    CFStringRef mediaType = (__bridge CFStringRef)([info objectForKey:UIImagePickerControllerMediaType]);
    //[self dismissViewControllerAnimated:TRUE completion:nil];
    
    // Handle a movie capture
    if (mediaType == kUTTypeMovie) {
        
        NSURL *rawVideoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        // Get start and end points from trimmed video
        NSNumber *start = [info objectForKey:@"_UIImagePickerControllerVideoEditingStart"];
        NSNumber *end = [info objectForKey:@"_UIImagePickerControllerVideoEditingEnd"];

        // If start and end are nil then clipping was not used.
        if (start != nil) {
            int startMilliseconds = ([start doubleValue] * 1000);
            int endMilliseconds = ([end doubleValue] * 1000);
        
            // Use AVFoundation to trim the video
            AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:rawVideoURL options:nil];
            NSString *outputURL = [RecordVideoViewController createPath];
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality];
            AVAssetExportSession *trimmedSession = [RecordVideoViewController configureExportSession:exportSession outputURL:outputURL startMilliseconds:startMilliseconds endMilliseconds:endMilliseconds];

            // Export trimmed video
            [trimmedSession exportAsynchronouslyWithCompletionHandler:^{
                switch (trimmedSession.status) {
                    case AVAssetExportSessionStatusCompleted:
                        // Custom method to import the Exported Video
                        self.videoURL = trimmedSession.outputURL;
                        break;
                    case AVAssetExportSessionStatusFailed:
                        //
                        NSLog(@"Failed:%@",trimmedSession.error);
                        break;
                    case AVAssetExportSessionStatusCancelled:
                        //
                        NSLog(@"Canceled:%@",trimmedSession.error);
                        break;
                    default:
                        break;
                }
            }];

            // If video was not trimmed, use the entire video.
        } else {
            self.videoURL = rawVideoURL;
            ViewController *controller = [[ViewController alloc] init];
            controller.videoURL = rawVideoURL;
            [self presentViewController:controller animated:TRUE completion:nil];
        }
        
        ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        controller.videoURL = self.videoURL;
        [self dismissViewControllerAnimated:TRUE completion:nil];
        [self presentViewController:controller animated:TRUE completion:nil];
    }
}




@end
