//
//  ViewController.m
//  WYMultimediaDemo
//
//  Created by Mac mini on 16/7/21.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import "ViewController.h"
#import "ImgViewController.h"
#import "AudioViewController.h"
#import "VideoViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.title = @"WYMultimediaDemo";
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
    promptLabel.center = CGPointMake(self.view.center.x, 150);
    promptLabel.backgroundColor = [UIColor redColor];
    promptLabel.text = @"本 Demo 涉及图片, 音频, 视频的获取, 压缩及上传, 请用真机测试";
    promptLabel.numberOfLines = 2;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:promptLabel];
    
    UIButton *audioButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    audioButton.center = CGPointMake(self.view.center.x, 250);
    audioButton.backgroundColor = [UIColor yellowColor];
    [audioButton setTitle:@"音频, 点我" forState:(UIControlStateNormal)];
    [audioButton addTarget:self action:@selector(audioButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:audioButton];
    
    UIButton *imgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imgButton.center = CGPointMake(CGRectGetMinX(audioButton.frame) - 50, 250);
    imgButton.backgroundColor = [UIColor orangeColor];
    [imgButton setTitle:@"图片, 点我" forState:(UIControlStateNormal)];
    [imgButton addTarget:self action:@selector(imgButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:imgButton];
    
    UIButton *videoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    videoButton.center = CGPointMake(CGRectGetMaxX(audioButton.frame) + 50, 250);
    videoButton.backgroundColor = [UIColor greenColor];
    [videoButton setTitle:@"视频, 点我" forState:(UIControlStateNormal)];
    [videoButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:videoButton];
}

- (void)imgButtonAction:(UIButton *)button {
    
    ImgViewController *imgVC = [[ImgViewController alloc] init];
    [self.navigationController pushViewController:imgVC animated:YES];
}

- (void)audioButtonAction:(UIButton *)button {
    
    AudioViewController *audioVC = [[AudioViewController alloc] init];
    [self.navigationController pushViewController:audioVC animated:YES];
}

- (void)videoButtonAction:(UIButton *)button {
    
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    [self.navigationController pushViewController:videoVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
