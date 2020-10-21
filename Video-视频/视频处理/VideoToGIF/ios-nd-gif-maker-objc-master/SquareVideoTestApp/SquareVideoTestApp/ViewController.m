//
//  ViewController.m
//  SquareVideoTestApp
//
//  Created by Gabrielle Miller-Messner on 4/20/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;

@interface ViewController ()

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


- (IBAction)makeItSquare:(id)sender {

    [self doStuff];
}

-(void)doStuff {

// output file
NSString* docFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
NSString* outputPath = [docFolder stringByAppendingPathComponent:@"output2.mov"];
if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath])
[[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];


// input file
AVAsset* asset = [AVAsset assetWithURL:self.videoURL];

AVMutableComposition *composition = [AVMutableComposition composition];
[composition  addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];

// input clip
AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];

// make it square
AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
videoComposition.renderSize = CGSizeMake(clipVideoTrack.naturalSize.height, clipVideoTrack.naturalSize.height);
videoComposition.frameDuration = CMTimeMake(1, 30);

AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30) );

// rotate to portrait
AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
CGAffineTransform t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) /2 );
CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);

CGAffineTransform finalTransform = t2;
[transformer setTransform:finalTransform atTime:kCMTimeZero];
instruction.layerInstructions = [NSArray arrayWithObject:transformer];
videoComposition.instructions = [NSArray arrayWithObject: instruction];

// export
AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality] ;
exporter.videoComposition = videoComposition;
exporter.outputURL=[NSURL fileURLWithPath:outputPath];
exporter.outputFileType=AVFileTypeQuickTimeMovie;

[exporter exportAsynchronouslyWithCompletionHandler:^(void){
    NSLog(@"Exporting done!");
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputPath)){
        UISaveVideoAtPathToSavedPhotosAlbum(outputPath, nil, nil, nil);
    }
    
}];
   

    
//end doStuff
}

@end
