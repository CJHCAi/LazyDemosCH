//
//  ViewController.m
//  videoTranscode
//
//  Created by 李根 on 16/9/5.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 *  mov转mp4格式
 *
 *  @param sender
 */
- (IBAction)movTranscodeToMP4:(id)sender {
    
    //  文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mov"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    AVURLAsset *avAsset = [AVURLAsset assetWithURL:url];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    NSLog(@"compatiblePresets: %@", compatiblePresets);
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        
        NSDate *data = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        
        NSString *uniqueName = [NSString stringWithFormat:@"%@.mp4", [dateFormatter stringFromDate:data]];
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSLog(@"path: %@", path);
        NSString *resultPath = [path stringByAppendingPathComponent:uniqueName];
        NSLog(@"resultPath: %@", resultPath);
        
        //  设定文件输出路径
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4; //  多种格式可选
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch (exportSession.status) {
                case AVAssetExportSessionStatusUnknown: {
                    NSLog(@"视频格式转换出错unknown");
                } break;
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"视频格式转换出错failed");
                } break;
                case AVAssetExportSessionStatusWaiting: {
                    NSLog(@"视频格式转换出错waiting");
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"视频格式转换出错cancelled");
                } break;
                case AVAssetExportSessionStatusExporting: {
                    NSLog(@"视频格式转换出错exporting");
                } break;
                case  AVAssetExportSessionStatusCompleted: {
                    NSLog(@"视频格式转换成功, soga!");
                } break;
                    
                default:
                    break;
            }
            
        }];
        
        
        
    }
    
}
- (IBAction)mp4transformTo3GP:(id)sender {
    
    //  文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"5" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    AVURLAsset *avAsset = [AVURLAsset assetWithURL:url];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    NSLog(@"compatiblePresets: %@", compatiblePresets);
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        
        NSDate *data = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        
        NSString *uniqueName = [NSString stringWithFormat:@"%@.3gp", [dateFormatter stringFromDate:data]];
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSLog(@"path: %@", path);
        NSString *resultPath = [path stringByAppendingPathComponent:uniqueName];
        NSLog(@"resultPath: %@", resultPath);
        
        //  设定文件输出路径
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileType3GPP; //  多种格式可选
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch (exportSession.status) {
                case AVAssetExportSessionStatusUnknown: {
                    NSLog(@"视频格式转换出错unknown");
                } break;
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"视频格式转换出错failed");
                } break;
                case AVAssetExportSessionStatusWaiting: {
                    NSLog(@"视频格式转换出错waiting");
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"视频格式转换出错cancelled");
                } break;
                case AVAssetExportSessionStatusExporting: {
                    NSLog(@"视频格式转换出错exporting");
                } break;
                case  AVAssetExportSessionStatusCompleted: {
                    NSLog(@"视频格式转换成功, soga!");
                } break;
                    
                default:
                    break;
            }
            
        }];
        
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
