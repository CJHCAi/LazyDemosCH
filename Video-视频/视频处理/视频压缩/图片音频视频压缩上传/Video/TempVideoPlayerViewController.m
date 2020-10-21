//
//  TempVideoPlayerViewController.m
//  WYVideoDemo
//
//  Created by Mac mini on 16/7/18.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import "TempVideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WYVideoCompressTools.h"
#import "Base64ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@implementation TempVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 有导航栏和tabBar的情况下, 自动让布局从导航栏下边和tabBar上边开始布局
    if ([self performSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationItem.title = @"视频压缩中...";
    
    [WYVideoCompressTools compressVideoWithSourceVideoPathString:self.sourceVideoPathString CompressType:self.compressType CompressSuccessBlock:^(NSString *compressVideoPathString) {
        
        self.compressVideoPathString = [compressVideoPathString mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.navigationItem.title = @"视频压缩结束";
        });
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"视频压缩成功了!" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            // 播放效果对比
            NSURL *sourceVideoUrl = [NSURL fileURLWithPath:self.sourceVideoPathString];
            AVPlayer *videoPlayer1 = [AVPlayer playerWithURL:sourceVideoUrl];
            AVPlayerLayer *playerLayer1 = [AVPlayerLayer playerLayerWithPlayer:videoPlayer1];
            playerLayer1.backgroundColor = [UIColor redColor].CGColor;
            playerLayer1.frame = CGRectMake(0, 0, kScreenWidth, (kScreenHeight - 64) / 2.0);
            [self.view.layer addSublayer:playerLayer1];
            [videoPlayer1 play];
            
            NSURL *compressVideoUrl = [NSURL fileURLWithPath:compressVideoPathString];
            AVPlayer *videoPlayer2 = [AVPlayer playerWithURL:compressVideoUrl];
            AVPlayerLayer *playerLayer2 = [AVPlayerLayer playerLayerWithPlayer:videoPlayer2];
            playerLayer2.backgroundColor = [UIColor orangeColor].CGColor;
            playerLayer2.frame = CGRectMake(0, (kScreenHeight - 64) / 2.0, kScreenWidth, (kScreenHeight - 64) / 2.0);
            [self.view.layer addSublayer:playerLayer2];
            [videoPlayer2 play];
            
            // 文件大小对比
            NSData *sourceVideoData = [NSData dataWithContentsOfFile:self.sourceVideoPathString];
            float sourceVideoSize = (float)sourceVideoData.length / 1024.0 / 1024.0;
            UILabel *sourceVideoSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
            sourceVideoSizeLabel.backgroundColor = [UIColor yellowColor];
            sourceVideoSizeLabel.text = [NSString stringWithFormat:@"源视频 : %.2fM", sourceVideoSize];
            [self.view addSubview:sourceVideoSizeLabel];
            
            NSData *compressVideoData = [NSData dataWithContentsOfFile:compressVideoPathString];
            float compressVideoSize = (float)compressVideoData.length / 1024.0 / 1024.0;
            UILabel *compressVideoSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (kScreenHeight - 64) / 2.0, 160, 20)];
            compressVideoSizeLabel.backgroundColor = [UIColor greenColor];
            compressVideoSizeLabel.text = [NSString stringWithFormat:@"压缩视频 : %.2fM", compressVideoSize];
            [self.view addSubview:compressVideoSizeLabel];
        }];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } CompressFailedBlock:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.navigationItem.title = @"视频压缩结束";
        });
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"视频压缩失败了!" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:nil];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } CompressNotSupportBlock:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.navigationItem.title = @"视频压缩结束";
        });
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"不支持当前压缩格式哦!" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:nil];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Base64" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction:)];
}
- (void)rightBarButtonItemAction:(UIBarButtonItem *)barButtonItem {
    
    Base64ViewController *base64VC = [[Base64ViewController alloc] init];
    
    // 把压缩视频的路径传过去
    base64VC.filePathString = self.compressVideoPathString;// 压缩视频的路径
    
    [self.navigationController pushViewController:base64VC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
