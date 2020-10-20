//
//  MediaCaptureController.m
//  MediaUnitedKit
//
//  Created by LEA on 2017/9/21.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MediaCaptureController.h"

#define k_PERMIT        9999

@implementation MediaCaptureController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bgView];
    
    // 音频权限
    if (![Utility isAudioRecordPermit]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设置>隐私>麦克风中开启权限"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil, nil];
        alert.tag = k_PERMIT;
        [alert show];
        return;
    }
    // 相机权限
    if (![Utility isCameraPermit]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设置>隐私>相机中开启权限"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil, nil];
        alert.tag = k_PERMIT;
        [alert show];
        return;
    }

    // 检测屏幕方向
    self.orientation = AVCaptureVideoOrientationPortrait;
    [self startMotionManager];

    scaleNum = 1.f;
    // 队列
    sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    // 采集
    captureSession = [[AVCaptureSession alloc] init];
    if ([captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }
    NSError *error = nil;
    // 获得输入设备
    captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!captureDevice) {
        [self backAction];
        return;
    }
    if ([captureDevice lockForConfiguration:&error]) {
        if ([captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [captureDevice unlockForConfiguration];
    }
    AVCaptureDeviceInput *captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        [self backAction];
        return;
    }
    // 添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        [self backAction];
        return;
    }
    // 将设备输入添加到会话中
    if ([captureSession canAddInput:captureDeviceInput]) {
        [captureSession addInput:captureDeviceInput];
        [captureSession addInput:audioCaptureDeviceInput];
        inputDevice = captureDeviceInput;
    }
    // 相机的实时预览页面
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = CGRectMake(0, 0, kWidth, kHeight);
    [previewLayer setAffineTransform:CGAffineTransformMakeScale(1.f, 1.f)];
    [self.bgView.layer addSublayer:previewLayer];
    // 照片输出
    if ([captureSession canAddOutput:self.imageOutput]) {
        [captureSession addOutput:self.imageOutput];
    }
    // 对焦
    UITapGestureRecognizer *focusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusGesture:)];
    [focusTap setNumberOfTapsRequired:1];
    [self.bgView addGestureRecognizer:focusTap];
    // 伸缩
    UITapGestureRecognizer *zoomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomGesture:)];
    [zoomTap setNumberOfTapsRequired:2];
    [self.bgView addGestureRecognizer:zoomTap];
    [focusTap requireGestureRecognizerToFail:zoomTap];
    // 视图
    [self initViews];
    // 开始运行
    [captureSession startRunning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self focusInPoint:self.view.center];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

#pragma mark - 获取Device || 屏幕方向
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position
{
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

- (void)startMotionManager
{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 1.0;
    if (_motionManager.deviceMotionAvailable) {
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler: ^(CMDeviceMotion *motion, NSError *error){
            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    } else {
        [self setMotionManager:nil];
    }
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion
{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    if (fabs(y) >= fabs(x)) {
        if (y >= 0){
            self.orientation = AVCaptureVideoOrientationPortraitUpsideDown;
        } else {
            self.orientation = AVCaptureVideoOrientationPortrait;
        }
    } else {
        if (x >= 0){
            self.orientation = AVCaptureVideoOrientationLandscapeLeft;
        } else {
            self.orientation = AVCaptureVideoOrientationLandscapeRight;
        }
    }
}

#pragma mark - 添加各个视图
- (void)initViews
{
    // 依次添加视图
    [self.bgView addSubview:self.backBtn];
    [self.bgView addSubview:self.frontBtn];
    [self.bgView addSubview:self.flashBtn];
    [self.bgView addSubview:self.flashView];
    [self.bgView addSubview:self.previewBtn];
    [self.bgView addSubview:self.videoBtn];
    [self.bgView addSubview:self.photoBtn];
    [self.bgView addSubview:self.switchBtn];
    [self.bgView addSubview:self.focusImageView];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.dotImageView];
    self.dotImageView.hidden = YES;
    self.videoBtn.hidden = YES;
    self.flashView.hidden = YES;
}

#pragma mark - 点击事件
// 返回
- (void)backAction
{
    [captureSession stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 前后置摄像头转换
- (void)frontSwitch:(UIButton *)btn
{
    NSArray *inputs = captureSession.inputs;
    for (AVCaptureDeviceInput *input in inputs )
    {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] )
        {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDeviceInput *newInput = nil;
            if (position == AVCaptureDevicePositionFront) {
                captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
            } else {
                captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];
            }
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
            [captureSession beginConfiguration];
            [captureSession removeInput:input];
            [captureSession addInput:newInput];
            [captureSession commitConfiguration];
            break;
        }
    }
}

// 闪光灯
- (void)flashClicked
{
    self.flashBtn.selected = !self.flashBtn.selected;
    [UIView animateWithDuration:0.2 animations:^{
        self.flashView.hidden = !self.flashBtn.selected;
    }];
}

// 闪光灯切换
- (void)flashSwitch:(UIButton *)btn
{
    NSInteger flashMode = btn.tag-100;
    // 更新UI
    UIButton *preBtn = [self.flashView viewWithTag:100+captureDevice.flashMode];
    [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:RGBColor(255.0, 197.0, 2, 1.0) forState:UIControlStateNormal];
    
    // 设置
    NSError *error = nil;
    if ([captureDevice lockForConfiguration:&error]) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
        [captureDevice unlockForConfiguration];
    }
    // 更新UI
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"media_flash_%ld",(long)flashMode]];
    [self.flashBtn setImage:image forState:UIControlStateNormal];
    self.flashBtn.selected = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.flashView.hidden = YES;
    }];
}

// 录制视频
- (void)captureVideo:(UIButton *)btn
{
    if (self.videoBtn.selected)
    {
        self.videoBtn.selected = NO;
        // 录制完成
        [self.movieFileOutput stopRecording];
        // 播放结束提示音
        AudioServicesPlaySystemSound(1118);
        // 取消定时器
        if (recordTimer != nil) {
            [recordTimer invalidate],recordTimer = nil;
        }
        // 重置
        self.timeLabel.text = @"00:00:00";
        self.dotImageView.hidden = YES;
        self.switchBtn.userInteractionEnabled = YES;
    }
    else
    {
        self.videoBtn.selected = YES;
        // 开始录制
        AVCaptureConnection *videoConnection = nil;
        for ( AVCaptureConnection *connection in [self.movieFileOutput connections] ) {
            for ( AVCaptureInputPort *port in [connection inputPorts] )  {
                if ( [[port mediaType] isEqual:AVMediaTypeVideo] ) {
                    videoConnection = connection;
                }
            }
        }
        if([videoConnection isVideoOrientationSupported])  {
            [videoConnection setVideoOrientation:self.orientation];
        }
        
        // 创建视频文件路径
        NSString *prefix = [Utility getNowTimestampString];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4",prefix];
        NSString *filePath = [[Utility getVideoDir] stringByAppendingPathComponent:fileName];
        [self.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:filePath] recordingDelegate:self];
        // 播放开始提示音
        AudioServicesPlaySystemSound(1117);
        // 计时开始
        self.dotImageView.hidden = NO;
        [self.dotImageView startAnimating];
        recordSeconds = 0;
        self.timeLabel.text = @"00:00:00";
        if (recordTimer != nil) {
            [recordTimer invalidate],recordTimer = nil;
        }
        recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.00f target:self selector:@selector(recordVideoTime:) userInfo:nil repeats:YES];
        // 修改左边预览
        self.switchBtn.userInteractionEnabled = NO;
        self.previewBtn.userInteractionEnabled = NO;
        [self.previewBtn setImage:[UIImage imageNamed:@"media_camera"] forState:UIControlStateNormal];
        [self.previewBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

// 拍照
- (void)capturePhoto:(UIButton *)btn
{
    // 开始拍照
    AVCaptureConnection *videoConnection = nil;
    for ( AVCaptureConnection *connection in [self.imageOutput connections] ) {
        for ( AVCaptureInputPort *port in [connection inputPorts] )  {
            if ( [[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
            }
        }
    }
    if([videoConnection isVideoOrientationSupported])  {
        [videoConnection setVideoOrientation:self.orientation];
    }
    AVCaptureConnection *captureConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    [captureConnection setVideoScaleAndCropFactor:scaleNum];
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         // 存入相册
         [Utility writeImageToMUKAssetsGroup:image completion:nil];
         // 预览显示
         _previewImage = image;
         self.previewBtn.userInteractionEnabled = YES;
         [self.previewBtn setImage:nil forState:UIControlStateNormal];
         [self.previewBtn setBackgroundImage:_previewImage forState:UIControlStateNormal];
         // 代理回传
         NSDictionary *dic = @{UIImagePickerControllerOriginalImage:image};
         if ([self.delegate respondsToSelector:@selector(mediaCaptureController:didFinishPickingMediaWithInfo:)]) {
             [self.delegate mediaCaptureController:self didFinishPickingMediaWithInfo:dic];
         }
     }];
}

// 拍照摄像切换
- (void)switchFunction:(UIButton *)btn
{
    if (self.switchBtn.selected) {
        self.switchBtn.selected = NO;
        // 切换至拍照
        self.videoBtn.hidden = YES;
        self.photoBtn.hidden = NO;
        self.flashBtn.hidden = NO;
        // 照片输出
        if ([captureSession canAddOutput:self.imageOutput]) {
            [captureSession addOutput:self.imageOutput];
        }
        // 重置
        self.timeLabel.text = nil;
        self.dotImageView.hidden = YES;
    } else {
        self.switchBtn.selected = YES;
        // 切换至录制
        self.videoBtn.hidden = NO;
        self.photoBtn.hidden = YES;
        self.flashBtn.hidden = YES;
        self.flashView.hidden = YES;
        // 视频输出
        if ([captureSession canAddOutput:self.movieFileOutput]) {
            [captureSession addOutput:self.movieFileOutput];
        }
        self.timeLabel.text = @"00:00:00";
    }
}

// 预览>>自行处理吧
- (void)previewFunction:(UIButton *)btn
{
    // 推荐使用WMPlayer
}

#pragma mark - 对焦、缩放镜头
- (void)zoomGesture:(UITapGestureRecognizer *)zoomTap
{
    if (scaleNum == 1.f) {
        scaleNum = 2.f;
    } else {
        scaleNum = 1.f;
    }
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3];
    [previewLayer setAffineTransform:CGAffineTransformMakeScale(scaleNum, scaleNum)];
    [CATransaction commit];
}

- (void)focusGesture:(UITapGestureRecognizer *)focusTap
{
    CGPoint currTouchPoint = [focusTap locationInView:self.bgView];
    // 对焦
    [self focusInPoint:currTouchPoint];
}

- (void)focusInPoint:(CGPoint)devicePoint
{
    [self focusWithDevicePoint:[self convertPoint:devicePoint]];
    [self.focusImageView setCenter:devicePoint];
    self.focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.focusImageView.alpha = 1.f;
                         self.focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5f
                                               delay:0.5f
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              self.focusImageView.alpha = 0.f;
                                          } completion:nil];
                     }];
}

- (CGPoint)convertPoint:(CGPoint)devicePoint
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = previewLayer.bounds.size;
    AVCaptureVideoPreviewLayer *videoPreviewLayer = previewLayer;
    if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResize]) {
        pointOfInterest = CGPointMake(devicePoint.y / frameSize.height, 1.f - (devicePoint.x / frameSize.width));
    }
    else
    {
        CGRect cleanAperture;
        for(AVCaptureInputPort *port in [[captureSession.inputs lastObject]ports])
        {
            if([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = devicePoint;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResizeAspect]) {
                    if(viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
                        if(point.x >= blackBar && point.x <= blackBar + x2) {
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
                        if(point.y >= blackBar && point.y <= blackBar + y2) {
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                }
                else if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResizeAspectFill])
                {
                    if(viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                        xc = point.y / frameSize.height;
                    }
                }
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    return pointOfInterest;
}

- (void)focusWithDevicePoint:(CGPoint)point
{
    dispatch_async(sessionQueue, ^{
        AVCaptureDevice *device = [inputDevice device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
            {
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:YES];
            [device unlockForConfiguration];
        }
    });
}

#pragma mark - 录像计时操作
- (void)recordVideoTime:(NSTimer *)timer
{
    recordSeconds ++;
    self.timeLabel.text = [Utility getHMSFormatBySeconds:recordSeconds];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"视频录制完成");
    // 保存图库
    [Utility writeVideoToMUKAssetsGroup:outputFileURL completion:nil];
    // 预览显示
    _previewImage = [Utility getVideoImage:outputFileURL];
    self.previewBtn.userInteractionEnabled = YES;
    [self.previewBtn setImage:[UIImage imageNamed:@"media_video_small"] forState:UIControlStateNormal];
    [self.previewBtn setBackgroundImage:_previewImage forState:UIControlStateNormal];
    // 代理回传
    NSDictionary *dic = @{UIImagePickerControllerMediaURL:outputFileURL};
    if ([self.delegate respondsToSelector:@selector(mediaCaptureController:didFinishPickingMediaWithInfo:)]) {
        [self.delegate mediaCaptureController:self didFinishPickingMediaWithInfo:dic];
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"视频开始录制");
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == k_PERMIT) {
        [self backAction];
    }
}

#pragma mark - UI图层区
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, kStatusHeight, kNavHeight, kNavHeight)];
        [_backBtn setImage:[UIImage imageNamed:@"media_top_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)frontBtn
{
    if (!_frontBtn) {
        _frontBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-kNavHeight-10, kStatusHeight, kNavHeight, kNavHeight)];
        [_frontBtn setImage:[UIImage imageNamed:@"media_top_switch"] forState:UIControlStateNormal];
        [_frontBtn addTarget:self action:@selector(frontSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _frontBtn;
}

- (UIButton *)flashBtn
{
    if (!_flashBtn) {
        _flashBtn = [[UIButton alloc] initWithFrame:CGRectMake((kWidth-200)/2, kStatusHeight, 50, kNavHeight)];
        [_flashBtn setImage:[UIImage imageNamed:@"media_flash_2"] forState:UIControlStateNormal];
        [_flashBtn setImage:[UIImage imageNamed:@"media_flash_2"] forState:UIControlStateSelected];
        [_flashBtn addTarget:self action:@selector(flashClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashBtn;
}

- (UIView *)flashView
{
    if (!_flashView) {
        _flashView = [[UIView alloc] initWithFrame:CGRectMake(self.flashBtn.right-10, kStatusHeight, 150, kNavHeight)];
        _flashView.backgroundColor = [UIColor clearColor];
        
        for (NSInteger i = 0; i < 3; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50*i, 0, 50, kNavHeight)];
            btn.tag = 100+(2-i);
            btn.backgroundColor = [UIColor clearColor];
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(flashSwitch:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [btn setTitle:@"自动" forState:UIControlStateNormal];
                [btn setTitleColor:RGBColor(255.0, 197.0, 2, 1.0) forState:UIControlStateNormal];
            } else if (i == 1) {
                [btn setTitle:@"打开" forState:UIControlStateNormal];
            } else {
                [btn setTitle:@"关闭" forState:UIControlStateNormal];
            }
            [_flashView addSubview:btn];
        }
    }
    return _flashView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((kWidth-85)/2, kStatusHeight, 80, kNavHeight)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:18.0];
        _timeLabel.textColor = [UIColor whiteColor];
    }
    return _timeLabel;
}

- (UIImageView *)dotImageView
{
    if (!_dotImageView) {
        _dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"media_dot"]];
        _dotImageView.center = self.timeLabel.center;
        _dotImageView.right = self.timeLabel.left-5;
        _dotImageView.animationImages = @[[UIImage imageNamed:@"media_dot"],[UIImage imageNamed:@"media_dot_clear"]];
        _dotImageView.animationDuration = 0.8;
    }
    return _dotImageView;
}

- (UIButton *)videoBtn
{
    if (!_videoBtn) {
        _videoBtn = [[UIButton alloc] initWithFrame:CGRectMake((kWidth-70)/2, kHeight-110, 70, 70)];
        _videoBtn.selected = NO;
        [_videoBtn setImage:[UIImage imageNamed:@"media_video"] forState:UIControlStateNormal];
        [_videoBtn setImage:[UIImage imageNamed:@"media_video_down"] forState:UIControlStateSelected];
        [_videoBtn addTarget:self action:@selector(captureVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoBtn;
}

- (UIButton *)photoBtn
{
    if (!_photoBtn) {
        _photoBtn = [[UIButton alloc] initWithFrame:CGRectMake((kWidth-70)/2, kHeight-110, 70, 70)];
        [_photoBtn setImage:[UIImage imageNamed:@"media_camera"] forState:UIControlStateNormal];
        [_photoBtn setImage:[UIImage imageNamed:@"media_camera_down"] forState:UIControlStateHighlighted];
        [_photoBtn addTarget:self action:@selector(capturePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoBtn;
}

- (UIButton *)switchBtn
{
    if (!_switchBtn) {
        _switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-65, kHeight-100, 50, 50)];
        _switchBtn.selected = NO;
        [_switchBtn setImage:[UIImage imageNamed:@"media_note_video"] forState:UIControlStateNormal];
        [_switchBtn setImage:[UIImage imageNamed:@"media_note_camera"] forState:UIControlStateSelected];
        [_switchBtn addTarget:self action:@selector(switchFunction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

- (UIButton *)previewBtn
{
    if (!_previewBtn) {
        _previewBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, kHeight-100, 50, 50)];
        _previewBtn.selected = NO;
        [_previewBtn addTarget:self action:@selector(previewFunction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewBtn;
}

- (UIImageView *)focusImageView
{
    if (!_focusImageView) {
        _focusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"media_focus"]];
        _focusImageView.alpha = 0;
    }
    return _focusImageView;
}

- (AVCaptureMovieFileOutput *)movieFileOutput
{
    if (!_movieFileOutput) {
        _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    }
    return _movieFileOutput;
}

- (AVCaptureStillImageOutput *)imageOutput
{
    if (!_imageOutput) {
        _imageOutput = [[AVCaptureStillImageOutput alloc] init];
        _imageOutput.outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    }
    return _imageOutput;
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_motionManager stopDeviceMotionUpdates];
    _motionManager = nil;
}

@end

