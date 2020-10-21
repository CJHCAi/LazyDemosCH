//
//  ViewController.m
//  ScImageSlider
//
//  Created by SunChao on 16/6/23.
//  Copyright © 2016年 SunChao. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ScImageSlider.h"

#define MainScreen [[UIScreen mainScreen] bounds]

#define SCREEN_HEIGHT  MainScreen.size.height
#define SCREENWIDTH    MainScreen.size.width


@interface ViewController ()
@property (strong,nonatomic)AVAssetImageGenerator * imageGenerator;
@property (strong,nonatomic)ScImageSlider *imageSlider;
@property (strong, nonatomic)NSMutableArray * imageArray;
@property (strong, nonatomic)UIImage *selectedImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageSlider = [[ScImageSlider alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT/2-40,SCREENWIDTH-20, 80)];
    [_imageSlider moveKnobWithSelectedValue:0.f];
    [_imageSlider addTarget:self
                     action:@selector(slideValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_imageSlider];
    [self updateImageWallThroughSystem];
    
}
-(void)updateImageWallThroughSystem{
    
//    NSString *videoPath = [[NSUserDefaults standardUserDefaults] objectForKey:@"VIDEOPATH"];
    
    NSString*videoPath=[[NSBundle mainBundle] pathForResource:@"video" ofType:@"MOV"];
    
    AVAsset * asset =[AVAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    NSMutableArray * times = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<10; i++) {
        NSValue * time = [NSValue valueWithCMTime:CMTimeMakeWithSeconds(i*(asset.duration.value/asset.duration.timescale)/10, asset.duration.timescale)];
        [times addObject:time];
    }
    
    if (_imageGenerator == nil) {
        _imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        _imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        _imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    }
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    __block NSInteger count = 0;
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result == AVAssetImageGeneratorSucceeded) {
            UIImage *thumbnail = [UIImage imageWithCGImage:im];
            [_imageArray addObject:thumbnail];
            count ++;
            if (count == 10) {
                [self performSelector:@selector(updateStatus:) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
            }
        }
        else if(result == AVAssetImageGeneratorFailed){
            NSLog(@">>>>>>>>>>>generate failed");
        }
        else if(result == AVAssetImageGeneratorCancelled){
            NSLog(@">>>>>>>>>>>generate cancelled");
        }
        
    };
    
    _imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    _imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    [_imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:handler];
    
    
}
-(void)updateStatus:(id)sender{
    _imageSlider.imageArray = _imageArray;
    [_imageSlider createTheImageWall];
    [_imageSlider updateTheKnobImage:_selectedImage];
}
-(void)updateTheImageWall{
    
    NSString*videoPath=[[NSBundle mainBundle] pathForResource:@"video" ofType:@"MOV"];

    NSMutableArray * dataArray = [NSMutableArray arrayWithCapacity:20];
    for (int i = 0; i<10; i++) {
        UIImage *  image = [self generateThumbImage:videoPath withTime:i*0.1];
        [dataArray addObject:image];
    }
    _imageArray = dataArray;
}
-(void)slideValueChanged:(id)control{
    ScImageSlider* slider = (ScImageSlider*)control;
    float scale = slider.knobValue/10.f;
    NSString*videoPath=[[NSBundle mainBundle] pathForResource:@"video" ofType:@"MOV"];
    UIImage * image = [self generateThumbImage:videoPath withTime:scale];
    [slider updateTheKnobImage:image];
    NSLog(@">>>>>>>>>>>>%f",slider.knobValue);
}
-(UIImage *)generateThumbImage : (NSString *)filepath withTime:(NSTimeInterval)interval
{
    NSURL *url = [NSURL fileURLWithPath:filepath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    if (_imageGenerator == nil) {
        _imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        _imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        _imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    }
    CMTime time = [asset duration];
    long long duration = time.value;
    time.value = interval*duration;
    
    CGImageRef imageRef = [_imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    // CGImageRef won't be released by ARC, so you must release.
    CGImageRelease(imageRef);
    
    return thumbnail;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
