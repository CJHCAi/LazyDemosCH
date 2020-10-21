//
//  ViewController.m
//  VideoReverseDemo
//
//  Created by HuangKai on 15/12/22.
//  Copyright © 2015年 HuangKai. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HKMediaOperationTools.h"


#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{

    NSURL * videoUrl;
}
@property (weak, nonatomic) IBOutlet UIButton *startReverseButton;
@property (nonatomic , assign) BOOL isCancel;
@property (nonatomic , strong) AVAsset *asset;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    // 通常从nib加载额外视图
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 处理任何可以被重新创建的资源
}
- (IBAction)startReverse:(id)sender {
    
    
    self.startReverseButton.enabled = NO;
    self.isCancel = NO;
    //    NSString *sourceMoviePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    //    NSURL *sourceMovieURL = [NSURL fileURLWithPath:sourceMoviePath];
    self.asset = [AVAsset assetWithURL:videoUrl];
    [self.asset loadValuesAsynchronouslyForKeys:@[@"duration", @"tracks"] completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.startReverseButton.enabled = YES;
        });
    }];

    
    self.isCancel = NO;
    NSString * temppath = NSTemporaryDirectory();
    temppath = [temppath stringByAppendingPathComponent:@"reversed.video"];
    BOOL exists =[[NSFileManager defaultManager] fileExistsAtPath:temppath isDirectory:NULL];
    if (!exists) {
        [[NSFileManager defaultManager] createDirectoryAtPath:temppath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    NSString *filename = @"reversed.mp4";
    temppath = [temppath stringByAppendingPathComponent:filename];
    if ([[NSFileManager defaultManager] fileExistsAtPath:temppath isDirectory:NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:temppath error:NULL];
    }
    NSLog(@"%@",temppath);
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      NSURL *outPutUrl=[HKMediaOperationTools assetByReversingAsset:self.asset videoComposition:nil duration:self.asset.duration outputURL:[NSURL fileURLWithPath:temppath] progressHandle:^(CGFloat progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressLabel.text = [NSString stringWithFormat:@"%@ %%",@(progress*100)];
                
                NSLog(@"%@",@(progress*100));

                
            });
        } cancle:&_isCancel];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self saveVideoWithUrl:outPutUrl];
        });
    });

}
//取消转码
- (IBAction)cancelReverse:(id)sender {
    self.isCancel = YES;
}
- (IBAction)selectVideo:(id)sender {
    
    
    UIImagePickerController * pickerController=[[UIImagePickerController alloc]init];
    pickerController.delegate=self;
    pickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    pickerController.editing=NO;
    [self presentViewController:pickerController animated:YES completion:nil];

    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",info);
    
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.movie"])
    {
        videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    }
}

//保存视频
-(void)saveVideoWithUrl:(NSURL *)outPutUrl
{
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outPutUrl])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:outPutUrl completionBlock:^(NSURL *assetURL, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 
                 if (error)
                 {
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                     [alert show];
                 }
                 else
                 {
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已保存到相册" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                     [alert show];
                     
                     
                 }
             });
         }];
    }
    
    
    
}

@end
