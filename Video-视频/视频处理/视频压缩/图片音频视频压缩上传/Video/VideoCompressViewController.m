//
//  VideoCompressViewController.m
//  WYVideoDemo
//
//  Created by Mac mini on 16/7/18.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import "VideoCompressViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TempVideoPlayerViewController.h"

@implementation VideoCompressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *lowQualityButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    lowQualityButton.center = CGPointMake(self.view.center.x, 150);
    lowQualityButton.backgroundColor = [UIColor redColor];
    [lowQualityButton setTitle:@"低质量视频压缩" forState:(UIControlStateNormal)];
    [lowQualityButton addTarget:self action:@selector(lowQualityButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:lowQualityButton];
    
    UIButton *mediumQualityButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    mediumQualityButton.center = CGPointMake(self.view.center.x, 200);
    mediumQualityButton.backgroundColor = [UIColor orangeColor];
    [mediumQualityButton setTitle:@"中质量视频压缩" forState:(UIControlStateNormal)];
    [mediumQualityButton addTarget:self action:@selector(mediumQualityButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:mediumQualityButton];
    
    UIButton *highestQualityButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    highestQualityButton.center = CGPointMake(self.view.center.x, 250);
    highestQualityButton.backgroundColor = [UIColor yellowColor];
    [highestQualityButton setTitle:@"高质量视频压缩" forState:(UIControlStateNormal)];
    [highestQualityButton addTarget:self action:@selector(highestQualityButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:highestQualityButton];
    
    UIButton *p480Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    p480Button.center = CGPointMake(self.view.center.x, 300);
    p480Button.backgroundColor = [UIColor greenColor];
    [p480Button setTitle:@"480P视频压缩" forState:(UIControlStateNormal)];
    [p480Button addTarget:self action:@selector(p480ButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:p480Button];
    
    UIButton *p540Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    p540Button.center = CGPointMake(self.view.center.x, 350);
    p540Button.backgroundColor = [UIColor cyanColor];
    [p540Button setTitle:@"540P视频压缩" forState:(UIControlStateNormal)];
    [p540Button addTarget:self action:@selector(p540ButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:p540Button];
    
    UIButton *p720Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    p720Button.center = CGPointMake(self.view.center.x, 400);
    p720Button.backgroundColor = [UIColor blueColor];
    [p720Button setTitle:@"720P视频压缩" forState:(UIControlStateNormal)];
    [p720Button addTarget:self action:@selector(p720ButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:p720Button];
    
    UIButton *p1080Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    p1080Button.center = CGPointMake(self.view.center.x, 450);
    p1080Button.backgroundColor = [UIColor purpleColor];
    [p1080Button setTitle:@"1080P视频压缩" forState:(UIControlStateNormal)];
    [p1080Button addTarget:self action:@selector(p1080ButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:p1080Button];
    
    UIButton *k4Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    k4Button.center = CGPointMake(self.view.center.x, 500);
    k4Button.backgroundColor = [UIColor magentaColor];
    [k4Button setTitle:@"4K视频压缩" forState:(UIControlStateNormal)];
    [k4Button addTarget:self action:@selector(k4ButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:k4Button];
}

- (void)lowQualityButtonAction:(UIButton *)button {
    
    TempVideoPlayerViewController *tempVideoPlayerVC = [[TempVideoPlayerViewController alloc] init];
    tempVideoPlayerVC.sourceVideoPathString = self.sourceVideoPathString;
    tempVideoPlayerVC.compressType = AVAssetExportPresetLowQuality;
    [self.navigationController pushViewController:tempVideoPlayerVC animated:YES];
}

- (void)mediumQualityButtonAction:(UIButton *)button {
    
    TempVideoPlayerViewController *tempVideoPlayerVC = [[TempVideoPlayerViewController alloc] init];
    tempVideoPlayerVC.sourceVideoPathString = self.sourceVideoPathString;
    tempVideoPlayerVC.compressType = AVAssetExportPresetMediumQuality;
    [self.navigationController pushViewController:tempVideoPlayerVC animated:YES];
}

- (void)highestQualityButtonAction:(UIButton *)button {
    
    TempVideoPlayerViewController *tempVideoPlayerVC = [[TempVideoPlayerViewController alloc] init];
    tempVideoPlayerVC.sourceVideoPathString = self.sourceVideoPathString;
    tempVideoPlayerVC.compressType = AVAssetExportPresetHighestQuality;
    [self.navigationController pushViewController:tempVideoPlayerVC animated:YES];
}

- (void)p480ButtonAction:(UIButton *)button {
    
    TempVideoPlayerViewController *tempVideoPlayerVC = [[TempVideoPlayerViewController alloc] init];
    tempVideoPlayerVC.sourceVideoPathString = self.sourceVideoPathString;
    tempVideoPlayerVC.compressType = AVAssetExportPreset640x480;
    [self.navigationController pushViewController:tempVideoPlayerVC animated:YES];
}

- (void)p540ButtonAction:(UIButton *)button {
    
    TempVideoPlayerViewController *tempVideoPlayerVC = [[TempVideoPlayerViewController alloc] init];
    tempVideoPlayerVC.sourceVideoPathString = self.sourceVideoPathString;
    tempVideoPlayerVC.compressType = AVAssetExportPreset960x540;
    [self.navigationController pushViewController:tempVideoPlayerVC animated:YES];
}

- (void)p720ButtonAction:(UIButton *)button {
    
    TempVideoPlayerViewController *tempVideoPlayerVC = [[TempVideoPlayerViewController alloc] init];
    tempVideoPlayerVC.sourceVideoPathString = self.sourceVideoPathString;
    tempVideoPlayerVC.compressType = AVAssetExportPreset1280x720;
    [self.navigationController pushViewController:tempVideoPlayerVC animated:YES];
}

- (void)p1080ButtonAction:(UIButton *)button {
    
    TempVideoPlayerViewController *tempVideoPlayerVC = [[TempVideoPlayerViewController alloc] init];
    tempVideoPlayerVC.sourceVideoPathString = self.sourceVideoPathString;
    tempVideoPlayerVC.compressType = AVAssetExportPreset1920x1080;
    [self.navigationController pushViewController:tempVideoPlayerVC animated:YES];
}

- (void)k4ButtonAction:(UIButton *)button {
    
    TempVideoPlayerViewController *tempVideoPlayerVC = [[TempVideoPlayerViewController alloc] init];
    tempVideoPlayerVC.sourceVideoPathString = self.sourceVideoPathString;
    tempVideoPlayerVC.compressType = AVAssetExportPreset3840x2160;
    [self.navigationController pushViewController:tempVideoPlayerVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
