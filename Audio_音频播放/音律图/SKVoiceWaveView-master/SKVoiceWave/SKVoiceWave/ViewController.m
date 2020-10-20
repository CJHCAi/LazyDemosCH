//
//  ViewController.m
//  SKVoiceWave
//
//  Created by ac-hu on 2018/10/24.
//  Copyright © 2018年 SK-HU. All rights reserved.
//

#import "ViewController.h"
#import "SKVoiceWaveView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SKVoiceWaveView *waveView = [[SKVoiceWaveView alloc]initWithFrame:CGRectMake(10, 100, 200, 50)];
    waveView.backgroundColor = [UIColor purpleColor];
//    waveView.path = [[NSBundle mainBundle] pathForResource:@"beat" ofType:@"aiff" inDirectory:nil];//指定路径
    waveView.url = [NSBundle URLForResource:@"李荣浩 - 老街" withExtension:@"mp3" subdirectory:nil inBundleWithURL:[NSBundle mainBundle].bundleURL];//指定URL
//    waveView.asset = [AVAsset assetWithURL:path];//指定媒体
    
    waveView.lineWidth = 2;//线宽，默认0，0则为连续的视图，可测试
    waveView.lineColor = [UIColor redColor];//颜色，默认红色
    waveView.lineDistance = 10;//线之间的距离，默认4
    [self.view addSubview:waveView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
