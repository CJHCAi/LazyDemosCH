//
//  JXVideoImagePickerVideoPlayerController.m
//  JXVideoImagePicker
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXVideoImagePickerVideoPlayerController.h"

@interface JXVideoImagePickerVideoPlayerController ()

// 1、创建要播放的元素
@property(nonatomic, strong) AVPlayerItem *playerItem;
// 2、创建播放器
@property(nonatomic, strong) AVPlayer *player;
//3、创建视频显示的图层
@property(nonatomic, strong) AVPlayerLayer *playerLayer;

@property(nonatomic, assign) CMTimeScale timeScale;
// 输出流
@property(nonatomic, strong) AVPlayerItemVideoOutput *videoOutPut;

@end


@implementation JXVideoImagePickerVideoPlayerController
#pragma mark - lazy loading
- (AVPlayerItemVideoOutput *)videoOutPut{
    if (_videoOutPut == nil) {
        _videoOutPut = [[AVPlayerItemVideoOutput alloc]init];
    }
    return _videoOutPut;
}

- (CMTimeScale)timeScale{
    if (!_timeScale) {
        _timeScale = self.asset.duration.timescale ? self.asset.duration.timescale : 600;
    }
    return _timeScale;
}

- (AVPlayerItem *)playerItem{
    if (_playerItem == nil) {
        _playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
        
        // 添加输出流
        [_playerItem addOutput:self.videoOutPut];
    }
    return _playerItem;
}

- (AVPlayer *)player{
    if (_player == nil) {
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
        
        
        
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer{
    if (_playerLayer == nil) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
       
        CGFloat W = 100;
        CGFloat H = 300;
        _playerLayer.frame = CGRectMake((JXScreenW - W) * 0.5, -64, W, H);
    }
    return _playerLayer;
}


#pragma mark - life cycle

- (void)loadView{
    [super loadView];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view.layer addSublayer: self.playerLayer];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self getCurrentImage];
}


#pragma mark - public

//  想要定格的时间
- (void)seekToTime:(CMTime)time{

    
    [self.player seekToTime:time toleranceBefore:CMTimeMake(0, self.timeScale) toleranceAfter:CMTimeMake(0, self.timeScale)completionHandler:^(BOOL finished) {
        
        
        NSLog(@"finished == %d",finished);
        
      
    }];
}


#pragma mark - 获取当前序列帧
-(void)getCurrentImage
{
    CMTime itemTime = _player.currentItem.currentTime;
    CVPixelBufferRef pixelBuffer = [_videoOutPut copyPixelBufferForItemTime:itemTime itemTimeForDisplay:nil];
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pixelBuffer),
                                                 CVPixelBufferGetHeight(pixelBuffer))];
    
    //当前帧的画面
    UIImage *currentImage = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    
    
    if (self.ResultImageBlock) {
        self.ResultImageBlock(currentImage);
    }
    
}




@end


