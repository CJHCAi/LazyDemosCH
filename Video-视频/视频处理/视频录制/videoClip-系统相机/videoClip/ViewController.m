//
//  ViewController.m
//  videoClip
//
//  Created by qx_mjn on 16/8/20.
//  Copyright © 2016年 qx_mjn. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)gotoChooseVideo:(id)sender {
   
    
   
    UIAlertController *al = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *xcAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//         UIImagePickerController *_pickerController2;
        //使用相机 相机拍摄
        UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
    
            UIImagePickerController *_pickerController2= [[UIImagePickerController alloc]init];
            _pickerController2.delegate=self;
            _pickerController2.mediaTypes = @[(NSString *)kUTTypeMovie];
//            _pickerController2.allowsEditing=YES;
            _pickerController2.sourceType=sourceType;
            _pickerController2.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            [self presentViewController:_pickerController2 animated:YES completion:nil];

    }];
    UIAlertAction *pzAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *_pickerController1;
        //进入本地相册
        _pickerController1=[[UIImagePickerController alloc]init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            _pickerController1.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            _pickerController1.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:_pickerController1.sourceType];
        }
        
        
        //        [_pickerController1.navigationBar setBarTintColor:RightItmCOLOR1];
        [_pickerController1.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
        _pickerController1.mediaTypes = @[(NSString *)kUTTypeMovie];
        _pickerController1.delegate=self;
        _pickerController1.allowsEditing=NO;
        [self presentViewController:_pickerController1 animated:YES completion:nil];

    }];

    [al addAction:cancelAction];
    [al addAction:xcAction];
    [al addAction:pzAction];

    [self presentViewController:al animated:YES completion:nil];
    
//    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄",@"从相册选择", nil];
//    [action showInView:self.view];
}

#pragma mark- delegate for-相册、相机协议
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *NevideoPath=[NSString stringWithFormat:@"%@/Newvideo", pathDocuments];
    if (![[NSFileManager defaultManager] fileExistsAtPath:NevideoPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:NevideoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"Documents/Newvideo/%@tempfile.mp4", [[NSProcessInfo processInfo] globallyUniqueString]]];
    [self getVideoPath:url andTotalPath:pathToMovie success:^(id responseObject) {
        UISaveVideoAtPathToSavedPhotosAlbum(responseObject, nil, nil, nil);
    } fail:^{
        
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//这里假设拍摄出来的视频总是高大于宽的
/*!
  将所有分段视频合成为一段完整视频，并且裁剪为正方形
 */
- (void)getVideoPath:(NSURL *)videoPath andTotalPath:(NSString *)totalPath success:(void (^)(id responseObject))success fail:(void (^)())fail{
    NSError *error = nil;
    
    CGSize renderSize = CGSizeMake(0, 0);
    
    NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
    
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    //    CMTime totalDuration = kCMTimeZero;
    AVAsset *asset = [AVAsset assetWithURL:videoPath];
    
    AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
    renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
    
    
    CGFloat renderW = MIN(renderSize.width, renderSize.height);
    
    
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //        NSLog(@"%@",asset.ty)
    NSArray *arr = [asset tracksWithMediaType:AVMediaTypeAudio];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                        ofTrack:([arr count]>0)?[arr objectAtIndex:0]:nil
                         atTime:kCMTimeZero
                          error:nil];
    
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                        ofTrack:assetTrack
                         atTime:kCMTimeZero
                          error:&error];
    
    //fix orientationissue
    AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    //        totalDuration = CMTimeAdd(totalDuration, asset.duration);
    
    CGFloat rate;
    rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
    NSLog(@"rate+++%f",rate);
    CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);
    layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -fabs(assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0));//向上移动取中部影响
    //     layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, - 64*(SCREEN_HEIGHT/renderSize.height)));//向上移动取中部影响
    layerTransform = CGAffineTransformScale(layerTransform, rate, rate);//放缩，解决前后摄像结果大小不对称
    
    [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
    //        [layerInstruciton setOpacity:0.0 atTime:totalDuration];
    
    //data
    [layerInstructionArray addObject:layerInstruciton];
    
    //get save path
    NSURL *mergeFileURL = [NSURL fileURLWithPath:totalPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = [[mergeFileURL absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            NSError *error = nil;
            [fileManager removeItemAtPath:filePath error:&error];
            
            if (error) {
                NSLog(@"mergeFileURL删除视频文件出错:%@", error);
            }
        }
    });
    
    
    //    //get save path
    //    NSURL *mergeFileURL = [NSURL fileURLWithPath:[self getVideoMergeFilePathString]];
    
    //export
    AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, [asset duration]);
    mainInstruciton.layerInstructions = layerInstructionArray;
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[mainInstruciton];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    mainCompositionInst.renderSize = CGSizeMake(renderW, renderW);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        //        dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"exporter.status == %ld",(long)exporter.status);
        //这里是输出视频之后的操作，做你想做的
        if (exporter.status == AVAssetExportSessionStatusCompleted) {
            NSURL *outputURLNew = exporter.outputURL;
            if (success) {
                success(outputURLNew.path);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"shuchu " message:@"chenggong" delegate:nil cancelButtonTitle:@"123" otherButtonTitles:nil, nil];
                    [alertView show];

                });
                
               
            }
        }
        
        //        });
    }];
}


@end
