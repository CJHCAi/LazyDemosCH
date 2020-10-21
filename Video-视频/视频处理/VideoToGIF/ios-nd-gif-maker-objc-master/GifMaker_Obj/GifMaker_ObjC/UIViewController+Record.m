//
//  UIViewController+Record.m
//  GifMaker_ObjC
//
//  Created by Ayush Saraswat on 4/26/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//  Code for cropVideoToSquare: modified from http://www.netwalk.be/article/record-square-video-ios

#import "UIViewController+Record.h"
#import "GifEditorViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

#import "GifMaker_Objc-Swift.h"

@implementation UIViewController (Record) 

static int const kFrameCount = 16;
static const float kDelayTime = 0.2;
static const int kLoopCount = 0;
static const float kFrameRate = 15;

- (IBAction)presentVideoOptions:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self launchPhotoLibrary];
    } else {
        UIAlertController *newGifActionSheet = [UIAlertController alertControllerWithTitle:@"Create new GIF"
                                                                                    message:nil
                                                                             preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *recordVideo = [UIAlertAction actionWithTitle:@"Record a Video"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                [self launchCamera];
                                                            }];
        
        UIAlertAction *chooseFromExisting = [UIAlertAction actionWithTitle:@"Choose from Existing"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                [self launchPhotoLibrary];
                                                            }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        
        [newGifActionSheet addAction:recordVideo];
        [newGifActionSheet addAction:chooseFromExisting];
        [newGifActionSheet addAction:cancel];
        
        [self presentViewController:newGifActionSheet animated:YES completion:nil];
        [newGifActionSheet.view setTintColor:[UIColor colorWithRed:255.0/255.0 green:65.0/255.0 blue:112.0/255.0 alpha:1.0]];
    }
}

- (void)launchCamera {

    
    [self presentViewController:[self pickerControllerWithSource:UIImagePickerControllerSourceTypeCamera]
                       animated:YES
                     completion:nil];
}

- (void)launchPhotoLibrary {
   
    [self presentViewController:[self pickerControllerWithSource:UIImagePickerControllerSourceTypePhotoLibrary]
                       animated:YES
                     completion:nil];
}

// MARK:  - Utils
-(UIImagePickerController*) pickerControllerWithSource: (UIImagePickerControllerSourceType) source{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = source;
    picker.mediaTypes = @[(NSString *) kUTTypeMovie];
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    return picker;
    
}
# pragma mark - ImagePickerControllerDelegate Methods

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Allows Editing
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    CFStringRef mediaType = (__bridge CFStringRef)([info objectForKey:UIImagePickerControllerMediaType]);
    
    // Handle a movie capture
    if (mediaType == kUTTypeMovie) {
        
        NSURL *rawVideoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        // Get start and end points from trimmed video
        NSNumber *start = [info objectForKey:@"_UIImagePickerControllerVideoEditingStart"];
        NSNumber *end = [info objectForKey:@"_UIImagePickerControllerVideoEditingEnd"];
        NSNumber *duration = [NSNumber numberWithFloat: end.floatValue - start.floatValue];
        
        [self cropVideoToSquare:rawVideoURL start: start duration: duration];
    }
}

-(void)cropVideoToSquare:(NSURL*)rawVideoURL start:(NSNumber*)start duration:(NSNumber*)duration {
    //Create the AVAsset and AVAssetTrack
    AVAsset *videoAsset = [AVAsset assetWithURL:rawVideoURL];
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    // Crop to square
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.height);
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30) );
    
    // rotate to portrait
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, -(videoTrack.naturalSize.width - videoTrack.naturalSize.height) /2 );
    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);
    
    CGAffineTransform finalTransform = t2;
    [transformer setTransform:finalTransform atTime:kCMTimeZero];
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    // export
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality] ;
    exporter.videoComposition = videoComposition;
    NSString *path = [self createPath];
    exporter.outputURL = [NSURL fileURLWithPath:path];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    
    __block NSURL *croppedURL;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^(void){
        croppedURL = exporter.outputURL;
        [self convertVideoToGif:croppedURL start:start duration:duration];
    }];
}

- (NSString*)createPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *outputURL = [documentsDirectory stringByAppendingPathComponent:@"output"] ;
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    outputURL = [outputURL stringByAppendingPathComponent:@"output.mov"];
    
    // Remove Existing File
    [manager removeItemAtPath:outputURL error:nil];
    
    return outputURL;
}

- (AVAssetExportSession*)configureExportSession:(AVAssetExportSession*)session
                                     outputURL:(NSString*)outputURL
                             startMilliseconds:(int)start
                               endMilliseconds:(int)end {
    
    session.outputURL = [NSURL fileURLWithPath:outputURL];
    session.outputFileType = AVFileTypeQuickTimeMovie;
    CMTimeRange timeRange = CMTimeRangeMake(CMTimeMake(start, 1000), CMTimeMake(end - start, 1000));
    session.timeRange = timeRange;
    
    return session;
}

# pragma mark - Gif Conversion and Display methods
-(void)convertVideoToGif:(NSURL*)croppedURL start:(NSNumber*)start duration: (NSNumber*)duration {
    
    Regift *regift;
    
    if (start == nil) {
        // Untrimmed
        regift = [[Regift alloc] initWithSourceFileURL:croppedURL destinationFileURL: nil frameCount:kFrameCount delayTime:kDelayTime loopCount:kLoopCount];
    } else {
        // trimmed
        regift = [[Regift alloc] initWithSourceFileURL:croppedURL destinationFileURL:nil startTime:start.floatValue duration:duration.floatValue frameRate:kFrameRate loopCount:kLoopCount];
    }
    
    NSURL *gifURL = [regift createGif];
    
    [self saveGif:gifURL videoURL:croppedURL];
}

-(void)saveGif:(NSURL*)gifURL videoURL: videoURL{
    Gif *newGif = [[Gif alloc] initWithGifURL:gifURL videoURL:videoURL caption:nil];
    [self displayGif:newGif];
}

-(void)displayGif:(Gif*)gif {
    GifEditorViewController *gifEditorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GifEditorViewController"];
    gifEditorVC.gif = gif;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController pushViewController:gifEditorVC animated:YES];
    });
}

@end
