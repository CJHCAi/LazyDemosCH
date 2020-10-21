//
//  ViewController.m
//  视频压缩
//
//  Created by xiaomu on 2017/2/1.
//  Copyright © 2017年 xiaomu. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end
@implementation ViewController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    // 创建图像选择器
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    // 设置类型
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 设置媒体类型
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    // 设置代理
    picker.delegate = self;
    // 设置莫提弹出效果
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark UIImagePickerController 代理方法！  选中视频的时候进行压缩
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 1. 获取媒体类型
    NSString * mediaType = info[UIImagePickerControllerMediaType];
    // 获取视频的路径
    id url = info[UIImagePickerControllerMediaURL];
    [self exprot:url];
}
-(void)exprot:(NSURL *)url {
    // 获取资源
    AVAsset *aset = [AVAsset assetWithURL:url];
    // Asset 获取资源路径
    // presetName 设置要压缩的格式
    AVAssetExportSession * session = [[AVAssetExportSession alloc]initWithAsset:aset presetName:AVAssetExportPresetHighestQuality];
    // 设置导出路径 并拼接名字
    session.outputURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"haha.mov"]];
    // 如果不设置的话 默认是导出这种文件的类型
    session.outputFileType = AVFileTypeQuickTimeMovie;
    // 开始导出文件
    [session exportAsynchronouslyWithCompletionHandler:^{
    NSLog(@"恭喜你，压缩视频成功了！");
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
@end
