//
//  PlayerViewController.m
//  VideoEditDemo
//
//  Created by JSB-hejiamin on 2018/2/24.
//  Copyright © 2018年 JSB-hejiamin. All rights reserved.
//

#import "BlurPlayerViewController.h"
#import "Masonry.h"
#import "NHPlayerView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SVProgressHUD.h"
#import <CoreImage/CoreImage.h>
#import "Mp4VideoWriter.h"
#import <Accelerate/Accelerate.h>
#import "GPUImage.h"
#import "BlurImage.h"
#import "UIImage+Rotate.h"

//获取导航栏+状态栏的高度
#define getRectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height


#define weakSelf(type)  __weak typeof(type) weak##type = type;


@interface BlurPlayerViewController (){
    Mp4VideoWriter *videoWriter;
    CGSize playVideoSize;//播放视频的尺寸
    GPUImagePixellateFilter *blurFilter;
   // GPUImageiOSBlurFilter *blurFilter;
    
   // GPUImageMosaicFilter *blurFilter;
    NSMutableArray *blurImageArr;
    CGPoint startP;
    NSMutableArray *seletedBlurViewArray;
    NSInteger videoRotation;
    AVAssetReader *movieReader;
    AVAssetReaderTrackOutput *videoTrackOutput;
    AVAssetReaderTrackOutput *audioTrackOutput;
    int frameNum;
    NSTimer *writerTimer;
    NSTimer *timeOutTimer;
    BOOL isFirstLoadView;
}


@property (strong,nonatomic)UIBarButtonItem *rightItem;
@property (strong,nonatomic)NHPlayerView *BlurVideoPlayerView;
@property (strong,nonatomic)UIView *actionView;
@property (strong,nonatomic)UILabel *tipsLabel;
@property (strong,nonatomic)UIView *clipView;
@property (strong,nonatomic)UIPanGestureRecognizer *touchPan;
@property (strong,nonatomic)UIView *editActionView;
@property (strong,nonatomic)UIButton *backActionButton;
@property (strong,nonatomic)UIButton *forwardAcitonButton;
@property (strong,nonatomic)UIButton *deleteActionButton;
@property (strong,nonatomic)NSMutableArray *deleteBlurViewArray;


@end

@implementation BlurPlayerViewController

-(UIPanGestureRecognizer *)touchPan{
    if(!_touchPan){
        _touchPan = [[UIPanGestureRecognizer alloc]init];
        [_touchPan setMaximumNumberOfTouches:1];
        [_touchPan addTarget:self action:@selector(TouchVideoPan:)];
    }
    return _touchPan;
}

-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]init];
        [_tipsLabel setFont:[UIFont systemFontOfSize:15]];
        [_tipsLabel setTextAlignment:NSTextAlignmentCenter];
        [_tipsLabel setTextColor:[UIColor whiteColor]];
        [_tipsLabel setText:@"请用手指框选视频中的水印区域"];
    }
    return _tipsLabel;
}


-(UIView *)actionView{
    if (!_actionView) {
        _actionView = [[UIView alloc]init];
        [_actionView setBackgroundColor:[UIColor colorWithRed:28.0f/255.0f green:28.0f/255.0f blue:28.0f/255.0f alpha:1.0]];
    }
    return _actionView;
}

-(UIView *)editActionView{
    if (!_editActionView) {
        _editActionView = [[UIView alloc]init];
    }
    return _editActionView;
}


-(NHPlayerView *)BlurVideoPlayerView{
    if (!_BlurVideoPlayerView) {
        _BlurVideoPlayerView = [[NHPlayerView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHight, [UIScreen mainScreen].bounds.size.width, ((self.view.frame.size.height-getRectNavAndStatusHight)*2/3))];
        _BlurVideoPlayerView.backgroundColor = [UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:1.0];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]init];
        [pan addTarget:self action:@selector(TouchPan:)];
        [_BlurVideoPlayerView addGestureRecognizer:pan];
    }
    return _BlurVideoPlayerView;
}


-(UIView *)clipView{
    if (!_clipView) {
        _clipView = [[UIView alloc]init];
        _clipView.backgroundColor=[UIColor colorWithRed:255.0f/255.0f green:43.0f/255.0f blue:33.0f/255.0f alpha:0.6];
    }
    return _clipView;
}

-(UIButton *)backActionButton{
    if (!_backActionButton) {
        _backActionButton = [[UIButton alloc]init];
        [_backActionButton setImage:[UIImage imageNamed:@"qushuiyin_back"] forState:UIControlStateNormal];
        [_backActionButton setImage:[UIImage imageNamed:@"qushuiyin_back_disabled"] forState:UIControlStateDisabled];
        [_backActionButton addTarget:self action:@selector(touchBackActionButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backActionButton;
}


-(UIButton *)forwardAcitonButton{
    if (!_forwardAcitonButton) {
        _forwardAcitonButton = [[UIButton alloc]init];
        [_forwardAcitonButton setImage:[UIImage imageNamed:@"qushuiyin_forward"] forState:UIControlStateNormal];
        [_forwardAcitonButton setImage:[UIImage imageNamed:@"qushuiyin_forward_disabled"] forState:UIControlStateDisabled];
        [_forwardAcitonButton addTarget:self action:@selector(touchForwardAcitonButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forwardAcitonButton;
}


-(UIButton *)deleteActionButton{
    if (!_deleteActionButton) {
        _deleteActionButton = [[UIButton alloc]init];
        [_deleteActionButton setImage:[UIImage imageNamed:@"qushuiyin_delet"] forState:UIControlStateNormal];
        [_deleteActionButton addTarget:self action:@selector(touchDeleteActionButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteActionButton;
}

-(NSMutableArray *)deleteBlurViewArray{
    if(!_deleteBlurViewArray){
        _deleteBlurViewArray = [NSMutableArray array];
    }
    return _deleteBlurViewArray;
}

-(void)UIAutoLayout{
    CGFloat PlayHeight = self.view.frame.size.height-getRectNavAndStatusHight;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:193.0/255.0 blue:7.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightButton setTitle:@"导出" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(importMovie) forControlEvents:UIControlEventTouchUpInside];
    _rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:_rightItem];
    
   // NSLog(@"NavgationHeight = %f",getRectNavAndStatusHight);
    
    [self.view addSubview:self.BlurVideoPlayerView];
    [self.BlurVideoPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(getRectNavAndStatusHight);
        make.left.right.mas_offset(0);
        make.height.mas_offset(PlayHeight*2/3);
    }];
    
    [self.view setUserInteractionEnabled:YES];
    [self.actionView setUserInteractionEnabled:YES];
    
    [self.view addSubview:self.actionView];
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BlurVideoPlayerView.mas_bottom).offset(0);
        make.left.right.bottom.mas_offset(0);
    }];
    
    CGFloat actionTop = PlayHeight - PlayHeight*2/3;
    [self.actionView addSubview:self.tipsLabel];
    [self.tipsLabel setHidden:NO];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.actionView);
        make.top.mas_offset(actionTop - actionTop*3/4);
        make.height.mas_offset(50);
    }];
    
    [self.actionView addSubview:self.editActionView];
    [self.editActionView setUserInteractionEnabled:YES];
    [self.editActionView setHidden:YES];
    [self.editActionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.actionView);
        make.top.mas_offset(actionTop - actionTop*3/4);
        make.height.mas_offset(80);
        make.width.mas_offset(self.view.frame.size.width * 0.8);
    }];
    
    
    
    
    [self.editActionView addSubview:self.forwardAcitonButton];
    [self.forwardAcitonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.editActionView);
        make.top.mas_offset(0);
        make.width.height.mas_offset(60);
    }];
    
    [self.editActionView addSubview:self.backActionButton];
    [self.backActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.equalTo(self.forwardAcitonButton.mas_left).offset(-25);
        make.width.height.mas_offset(60);
    }];

    [self.editActionView addSubview:self.deleteActionButton];
    [self.deleteActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(self.forwardAcitonButton.mas_right).offset(25);
        make.width.height.mas_offset(60);
    }];
    
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏18号白色字体加粗。
    [self.navigationItem setTitle:@"视频去水印"];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.view setBackgroundColor:[UIColor colorWithRed:28.0f/255.0f green:28.0f/255.0f blue:28.0f/255.0f alpha:1.0]];
    
    [self UIAutoLayout];
    
  //  NSURL *videoPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test1" ofType:@"mp4"]];
  //  _playUrl = videoPath;
    // 设置播放链接
    [self.BlurVideoPlayerView setPlayerURLStr:_playUrl.absoluteString isEdit:NO];


    isFirstLoadView = YES;
    
    AVURLAsset * asset = [AVURLAsset assetWithURL:_playUrl];
    NSArray *array = asset.tracks;
    CGSize size = CGSizeZero;
    
    for (AVAssetTrack *track in array) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            size = track.naturalSize;
        }
    }
    
    
    videoRotation =  [self degressFromVideoFileWithURL:asset];
    
    seletedBlurViewArray = [NSMutableArray array];
    
    playVideoSize = CGSizeMake(size.width, size.height);
    
    NSLog(@"Video W = %f Video H = %f videoRotation = %ld",playVideoSize.width,playVideoSize.height,(long)videoRotation);
    
    videoWriter = [[Mp4VideoWriter alloc]initVideoAudioWriterSize:playVideoSize];
    
    videoWriter.transForm = videoRotation;
    
    blurFilter = [[GPUImagePixellateFilter alloc] init];
    blurFilter.fractionalWidthOfAPixel = 0.1f;

    [self.BlurVideoPlayerView playerPlay];
//    blurFilter = [[GPUImageiOSBlurFilter alloc]init];
//    [blurFilter setBlurRadiusInPixels:6.0f];
  //  blurFilter = [[GPUImageMosaicFilter alloc]init];
    //监听挂起时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}



#pragma mark ----------------------------滑动手势返回处理-------------------------
- (void)willMoveToParentViewController:(UIViewController*)parent{
    [super willMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    [_BlurVideoPlayerView stopPlayer];
}
- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    if(!parent){
        NSLog(@"页面pop成功了");
    }
}



-(void)EnterBackgroundNotification{
    if (videoWriter) {
        videoWriter.pauseWriter = YES;
        [writerTimer invalidate];
    }
}

-(void)WillEnterForegroundNotification{
    if (videoWriter) {
        if (videoWriter.pauseWriter==YES) {
            videoWriter.pauseWriter = NO;
            if (videoWriter.isStart == YES) {
                [writerTimer invalidate];
                writerTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(readVideoFile:) userInfo:nil repeats:YES];
            }
        }
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //只调用一次此方法。防止其他操作再次调用。
    if (isFirstLoadView == YES) {
        isFirstLoadView = NO;
        //获得点击的起点
        [_BlurVideoPlayerView createVideoView];
        if (![_BlurVideoPlayerView.videoView.gestureRecognizers containsObject:self.touchPan]) {
            [_BlurVideoPlayerView.videoView addGestureRecognizer:self.touchPan];
        }
    }
    
}


-(void)showActionButtons:(BOOL)isShow{
    if (isShow) {

        _deleteActionButton.enabled=YES;
        _forwardAcitonButton.enabled=NO;
        _backActionButton.enabled=YES;
        [self.tipsLabel setHidden:YES];
        [self.editActionView setHidden:NO];
    }else{
        _deleteActionButton.enabled=NO;
        _forwardAcitonButton.enabled=NO;
        _backActionButton.enabled=NO;
        [self.tipsLabel setHidden:NO];
        [self.editActionView setHidden:YES];
    }
}


-(void)TouchVideoPan:(UIPanGestureRecognizer*)pan{
    if(pan.state==UIGestureRecognizerStateBegan) {
        
        startP=[pan locationInView:_BlurVideoPlayerView.videoView];
        
        UIView *clipView=[[UIView alloc]init];
        
        clipView.backgroundColor=[UIColor colorWithRed:255.0f/255.0f green:43.0f/255.0f blue:33.0f/255.0f alpha:0.6];

        [_BlurVideoPlayerView.videoView addSubview:clipView];
        
        self.clipView=clipView;
        
        [seletedBlurViewArray addObject:clipView];
        
        
        
    }else if(pan.state==UIGestureRecognizerStateChanged) {
        
        //求偏移量
        CGPoint curP=[pan locationInView:_BlurVideoPlayerView.videoView];
        
        CGFloat offsetX=curP.x-startP.x;
        
        CGFloat offsetY=curP.y-startP.y;
        
        self.clipView.frame=CGRectMake(startP.x,startP.y, offsetX, offsetY);
        
    }else if(pan.state==UIGestureRecognizerStateEnded) {
        
        NSLog(@"SeletedX = %f SeletedY = %f SeletedW = %f SeletedH = %f",self.clipView.frame.origin.x,self.clipView.frame.origin.y,self.clipView.frame.size.width,self.clipView.frame.size.height);
        
        if (seletedBlurViewArray.count == 1) {
            [self showActionButtons:YES];
        }
    }
}


-(void)TouchPan:(UIPanGestureRecognizer*)pan
{
    if(pan.state==UIGestureRecognizerStateBegan) {
        //获得点击的起点
        [_BlurVideoPlayerView createVideoView];
        if (![_BlurVideoPlayerView.videoView.gestureRecognizers containsObject:self.touchPan]) {
            [_BlurVideoPlayerView.videoView addGestureRecognizer:self.touchPan];
        }
    }
}



-(void)touchBackActionButton{
    
    if (self.BlurVideoPlayerView.videoView.subviews.count > 0) {
        UIView *topView = [self.BlurVideoPlayerView.videoView.subviews lastObject];
        [topView removeFromSuperview];
        [self.deleteBlurViewArray addObject:topView];
        if (seletedBlurViewArray.count > 0) {
            [seletedBlurViewArray removeObject:seletedBlurViewArray.lastObject];
        }

        if(self.BlurVideoPlayerView.videoView.subviews.count <= 0){
            _backActionButton.enabled=NO;
            _deleteActionButton.enabled=NO;
        }

        if (self.deleteBlurViewArray.count > 0) {
            _forwardAcitonButton.enabled=YES;
        }
    }
}

-(void)touchForwardAcitonButton{
    
    
    if(self.deleteBlurViewArray.count > 0){
        UIView *topView = [self.deleteBlurViewArray lastObject];
        [self.BlurVideoPlayerView.videoView addSubview:topView];
        [seletedBlurViewArray addObject:topView];
        [self.deleteBlurViewArray removeObject:topView];
        if (self.deleteBlurViewArray.count <= 0) {
            _forwardAcitonButton.enabled=NO;
        }
        
        if (self.BlurVideoPlayerView.videoView.subviews > 0) {
            _backActionButton.enabled=YES;
            _deleteActionButton.enabled=YES;
        }
    }
}

-(void)touchDeleteActionButton{
    
    
    if(self.deleteBlurViewArray.count > 0){
        [self.deleteBlurViewArray removeAllObjects];
        _forwardAcitonButton.enabled=YES;
    }
    
    if (self.BlurVideoPlayerView.videoView.subviews > 0) {
        for (UIView *view in self.BlurVideoPlayerView.videoView.subviews) {
            [view removeFromSuperview];
        }
        _deleteActionButton.enabled=YES;
    }
    
    if (seletedBlurViewArray.count > 0) {
        [seletedBlurViewArray removeAllObjects];
    }
    
    [self showActionButtons:NO];
}






- (UIImage *)blurryGPUImage:(NSArray *)imgArr SrcImage:(UIImage *)srcImage withBlurLevel:(CGFloat)blur {
    
    CGSize size = CGSizeMake(srcImage.size.width, srcImage.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, srcImage.scale);
    CGImageRef sourceImageRef = [srcImage CGImage];
    CGPoint pointImg1 = CGPointMake(0,0);
    [srcImage drawAtPoint:pointImg1];
    for (BlurImage *img in imgArr) {
        CGRect frame = CGRectMake(img.ImageRect.origin.x * srcImage.scale, img.ImageRect.origin.y * srcImage.scale, img.ImageRect.size.width * srcImage.scale, img.ImageRect.size.height * srcImage.scale);
        CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, frame);
        UIImage *cropImage = [UIImage imageWithCGImage:newImageRef];
        img.image = [blurFilter imageByFilteringImage:cropImage];
        [img.image drawInRect:frame];
        CGImageRelease(newImageRef);
    }
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}








- (UIImage *)imageFromRGBImageBuffer:(CVImageBufferRef)imageBuffer {
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    CGImageRelease(quartzImage);
    return (image);
}




- (CVPixelBufferRef)imageToRGBPixelBuffer:(UIImage *)image {
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image.CGImage),CGImageGetHeight(image.CGImage));
    NSDictionary *options =
    [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,[NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status =
    CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width, frameSize.height,kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef)options, &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width, frameSize.height,8, CVPixelBufferGetBytesPerRow(pxbuffer),rgbColorSpace,(CGBitmapInfo)kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image.CGImage),CGImageGetHeight(image.CGImage)), image.CGImage);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    return pxbuffer;
}




-(NSUInteger)degressFromVideoFileWithURL:(AVAsset *)asset
{
    NSUInteger degress = 0;

    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    
    return degress;
}


-(void)readVideoFile:(CMSampleBufferRef)sampleBuffer{
    
    if (videoWriter.pauseWriter == YES) {
        [writerTimer invalidate];
    }else{
        if ([movieReader status] == AVAssetReaderStatusReading) {
            @autoreleasepool {

                CMSampleBufferRef sampleBuffer = [videoTrackOutput copyNextSampleBuffer];
                if (sampleBuffer){
                    CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
                    CMTime startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
                    
                    if (imageBuffer) {
                        UIImage *image = [self imageFromRGBImageBuffer:imageBuffer];
                        UIImage *NewImage = [self blurryGPUImage:blurImageArr SrcImage:image withBlurLevel:10];
                        CVPixelBufferRef pixbuffer = [self imageToRGBPixelBuffer:NewImage];
                        [videoWriter writeVideoWithCGImage:pixbuffer Time:startTime];
                        
                        frameNum++;
                        if (frameNum%(int)videoWriter.fps==0) {
                            float progress = (float)frameNum/(float)videoWriter.frameNum;
                            [SVProgressHUD showProgress:progress status:@"正在导出..."];
                        }
                        if (pixbuffer) {
                            CVPixelBufferRelease(pixbuffer);
                        }
                    }
                }
                if (sampleBuffer) {
                    CMSampleBufferInvalidate(sampleBuffer);
                    CFRelease(sampleBuffer);
                }
                
                if (audioTrackOutput) {
                    CMSampleBufferRef audioSampleBuffer = [audioTrackOutput copyNextSampleBuffer];
                    
                    [videoWriter writeAudioBytesWithDataBuffer:audioSampleBuffer];
                }
            }
        }else if ([movieReader status] == AVAssetReaderStatusCompleted){
            NSLog(@"写入了->%d帧",frameNum);
            [movieReader cancelReading];
            [SVProgressHUD showSuccessWithStatus:@"视频已保存到相册" hidewithInterVal:1.0f];
            [videoWriter WriteVideoEnd];
            [writerTimer invalidate];
            
        }else if ([movieReader status] == AVAssetReaderStatusFailed){
            NSLog(@"写入了->%d帧",frameNum);
            [movieReader cancelReading];
            //[SVProgressHUD showSuccessWithStatus:@"视频已保存到相册" hidewithInterVal:1.0f];
            [SVProgressHUD showErrorWithStatus:@"视频导出失败" hideInterVal:1.0f];
            [videoWriter WriteVideoEnd];
            [writerTimer invalidate];
            
        }else{
            NSLog(@"写入了->%d帧",frameNum);
            [movieReader cancelReading];
            //[SVProgressHUD showSuccessWithStatus:@"视频已保存到相册" hidewithInterVal:1.0f];
            [SVProgressHUD showErrorWithStatus:@"视频导出失败" hideInterVal:1.0f];
            [videoWriter WriteVideoEnd];
            [writerTimer invalidate];
        }
    }
}


- (void)readMovie:(NSURL *)url
{
    
    [self.BlurVideoPlayerView playerPause];
    AVURLAsset * asset = [AVURLAsset assetWithURL:_playUrl];

    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:
     ^{
         AVAssetTrack * videoTrack = nil;
         NSArray * tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
         AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
         if ([tracks count] == 1)
         {
             videoTrack = (AVAssetTrack *)[tracks objectAtIndex:0];
             NSError * error = nil;
             
             // _movieReader is a member variable
             movieReader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
             if (error){
                 NSLog(@"_movieReader fail!\n");
             }else{
                 NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
                 NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
                 NSDictionary* videoSettings =
                 [NSDictionary dictionaryWithObject:value forKey:key];
                 
                 [movieReader addOutput:[AVAssetReaderTrackOutput
                                         assetReaderTrackOutputWithTrack:videoTrack
                                         outputSettings:videoSettings]];
                 videoTrackOutput = (AVAssetReaderTrackOutput *)[movieReader.outputs objectAtIndex:0];
                 
                 
                 
                 if (audioTrack) {
                     NSDictionary *dic = @{AVFormatIDKey :@(kAudioFormatLinearPCM),
                                           
                                           AVLinearPCMIsBigEndianKey:@NO,
                                           
                                           AVLinearPCMIsFloatKey:@NO,
                                           
                                           AVLinearPCMBitDepthKey :@(16)
                                           
                                           };
                     
                     AVAssetReaderTrackOutput *audioOutput = [[AVAssetReaderTrackOutput alloc]initWithTrack:audioTrack outputSettings:dic];
                     
                     [movieReader addOutput:audioOutput];
                 }
                 if (movieReader.outputs.count > 1) {
                     audioTrackOutput = (AVAssetReaderTrackOutput *)[movieReader.outputs objectAtIndex:1];
                 }
                 
                 [movieReader startReading];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     CMTime audioDuration = asset.duration;
                     float duration = CMTimeGetSeconds(audioDuration);
                     float fps = videoTrackOutput.track.nominalFrameRate;
                     videoWriter.fps = fps;
                     videoWriter.duration = duration;
                     videoWriter.frameNum = fps * duration;
                     [videoWriter WritevideoBegain];
                     NSLog(@"总共有->%ld帧",(long)videoWriter.frameNum);
                     frameNum = 0;
                     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
                     [SVProgressHUD showProgress:frameNum status:@"正在导出..."];
                     [writerTimer invalidate];
                     writerTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(readVideoFile:) userInfo:nil repeats:YES];
                 });
             }
         }
     }];
}



-(CGRect)converRectForSeletedViewFrame:(CGRect)viewFrame VideoRotation:(NSInteger)rotation {
    CGRect resultRect = CGRectZero;
    switch (rotation) {
        case 0:{
            CGFloat scaleH = playVideoSize.height / _BlurVideoPlayerView.videoView.frame.size.height;
            CGFloat scaleW = playVideoSize.width / _BlurVideoPlayerView.videoView.frame.size.width;
            resultRect = CGRectMake(viewFrame.origin.x * scaleW, viewFrame.origin.y * scaleH, viewFrame.size.width * scaleH, viewFrame.size.height * scaleH);
        }
            break;
        case 90:{
            CGFloat scaleW = playVideoSize.height / _BlurVideoPlayerView.videoView.frame.size.width;
            CGFloat scaleH = playVideoSize.width / _BlurVideoPlayerView.videoView.frame.size.height;
            CGRect leftRect = CGRectMake(viewFrame.origin.x * scaleW, viewFrame.origin.y * scaleH, viewFrame.size.width * scaleW, viewFrame.size.height * scaleW);
            resultRect = CGRectMake(leftRect.origin.y, playVideoSize.height-leftRect.origin.x-leftRect.size.width, leftRect.size.height, leftRect.size.width);
        }
            break;
        case 180:{
            CGFloat scaleH = playVideoSize.height / _BlurVideoPlayerView.videoView.frame.size.height;
            CGFloat scaleW = playVideoSize.width / _BlurVideoPlayerView.videoView.frame.size.width;
            resultRect = CGRectMake(playVideoSize.width - (viewFrame.origin.x * scaleW) - (viewFrame.size.width * scaleW), playVideoSize.height - (viewFrame.origin.y * scaleH) - (viewFrame.size.height * scaleH), viewFrame.size.width * scaleW, viewFrame.size.height * scaleH);
        }
            break;
        case 270:{
            CGFloat scaleH = playVideoSize.height / _BlurVideoPlayerView.videoView.frame.size.width;
            CGFloat scaleW = playVideoSize.width / _BlurVideoPlayerView.videoView.frame.size.height;
            CGRect leftRect = CGRectMake(viewFrame.origin.x * scaleW, viewFrame.origin.y * scaleH, viewFrame.size.width * scaleW, viewFrame.size.height * scaleW);
            resultRect = CGRectMake(leftRect.origin.y, playVideoSize.height-leftRect.origin.x-leftRect.size.width, leftRect.size.height, leftRect.size.width);
        }
            break;
            
        default:{
            CGFloat scaleH = playVideoSize.height / _BlurVideoPlayerView.videoView.frame.size.height;
            CGFloat scaleW = playVideoSize.width / _BlurVideoPlayerView.videoView.frame.size.width;
            resultRect = CGRectMake(viewFrame.origin.x * scaleW, viewFrame.origin.y * scaleH, viewFrame.size.width * scaleW, viewFrame.size.height * scaleH);
        }
            break;
    }
    return resultRect;
    
}


-(void)importMovie{
    if (seletedBlurViewArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"未选中任何水印区域" hideInterVal:1.0f];
    }else{
        blurImageArr = [NSMutableArray array];
        for (UIView *seletedView in seletedBlurViewArray) {
            BlurImage *image = [[BlurImage alloc]init];
            image.ImageRect =  [self converRectForSeletedViewFrame:seletedView.frame VideoRotation:videoRotation];

            [blurImageArr addObject:image];
        }
        [self readMovie:_playUrl];
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    [_BlurVideoPlayerView playerPause];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"player dealloc");
}

@end
