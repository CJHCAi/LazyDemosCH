//
//  CustomCamera.m
//  压缩视频
//
//  Created by 施永辉 on 16/7/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CustomCamera.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "UIView+SDAutoLayout.h"

#import "SendVideoView.h"
#import "ShortVideoProgressView.h"

#define kMaxVideoLength 20  //设置拍摄时间


#define kProgressTimerTimeInterval 0.015
#define Global_tintColor [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1]

typedef NS_ENUM(NSInteger,VideoStatus){
    VideoStatusEnded = 0,
    VideoStatusStarted
    
};
const CGFloat kHomeTableViewAnimationDuration = 0.25;
extern const CGFloat kHomeTableViewAnimationDuration;

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface CustomCamera () <AVCaptureFileOutputRecordingDelegate, UIGestureRecognizerDelegate>

@property (strong,nonatomic)AVCaptureDevice * videoDevice;
@property (strong,nonatomic) AVCaptureSession * captureSession;//负责输入和输出设备之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput * captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureStillImageOutput * captureStillImageOutput;//照片输出流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer * captureVideoPreviewLayer;//相机拍摄预览图层
@property (nonatomic,assign) VideoStatus status;
@property (weak, nonatomic) UIImageView *focusCursor; //聚焦光标

@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;//视频输出流
@property (assign,nonatomic) BOOL enableRotation;//是否允许旋转（注意在视频录制过程中禁止屏幕旋转）
@property (assign,nonatomic) CGRect *lastBounds;//旋转的前大小
@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;//后台任务标识
@property (nonatomic,strong) CADisplayLink *link;
@property (nonatomic, assign) CGFloat videoLength;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;//触摸手势

@property (nonatomic, assign) BOOL shouldCancel;


/**
 页面布局控件
 */
@property (strong, nonatomic) UIView *videoView;//播放层
@property (strong, nonatomic) UIButton *takeButton;//拍照按钮
@property (nonatomic,strong)UIButton *cancelButton;//取消按钮
@property (strong, nonatomic) UIButton *flashModelBtn;//闪光灯按钮
@property (nonatomic, strong) ShortVideoProgressView *progressView;//进度条
@property (nonatomic, strong) UIView *topBarView;//导航栏View

@property (nonatomic, strong) UILabel *cancelTip;//松手取消

@property (nonatomic, strong) NSTimer *progressTimer;//进度条计时器
@property (nonatomic,weak) UIView *focusCircle;//聚焦光标

@end

@implementation CustomCamera
#pragma mark - 控制器视图方法
- (void)viewDidLoad {
    [super viewDidLoad];
    //布局页面
    [self setupView];
    [self setupCaptureSession];
    
    [self hidde];
}
//布局页面
- (void)setupView
{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.pan = pan;
    
    CGRect rect = self.view.bounds;
    rect.size.height = 400;
    self.videoView = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:self.videoView];
    
    self.topBarView.hidden = NO;
    
    self.progressView = [ShortVideoProgressView new];
    //    self.progressView.hidden = YES;
    [self.view addSubview:self.progressView];
    
    self.takeButton = [UIButton new];
    
    [self.takeButton setTitle:@"按住拍" forState:UIControlStateNormal];
    [self.takeButton addTarget:self action:@selector(startRecordingVideo) forControlEvents:UIControlEventTouchDown];
    [self.takeButton addTarget:self action:@selector(endRecordingVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.takeButton setTitleColor:Global_tintColor forState:UIControlStateNormal];
    [self.view addSubview:self.takeButton];
    self.takeButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.takeButton.layer.borderWidth = 1;
    
    
    self.cancelTip = [UILabel new];
    self.cancelTip.text = @"上滑取消↑";
    self.cancelTip.textColor = [UIColor greenColor];
    
    self.cancelTip.hidden = YES;
    [self.view addSubview:self.cancelTip];
    
    self.flashModelBtn = [[UIButton alloc]init];
    [self.flashModelBtn setImage:[UIImage imageNamed:@"camera-flash-lamp-icon_25x27_"] forState:UIControlStateNormal];
    [self.flashModelBtn addTarget:self action:@selector(flashClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashModelBtn];
    //进度条
    self.progressView.sd_layout
    .leftSpaceToView(self.view, 0)
    .widthIs(self.view.width)
    .topSpaceToView(self.videoView, 0)
    .heightIs(2);
    //拍照按钮
    self.takeButton.sd_layout
    .topSpaceToView(self.videoView, 60)
    .bottomSpaceToView(self.view, 60)
    .widthEqualToHeight()
    .centerXEqualToView(self.view);
    self.takeButton.sd_cornerRadiusFromWidthRatio = @(0.5);
    //松手取消label
    self.cancelTip.sd_layout
    .centerXEqualToView(self.videoView)
    .topSpaceToView(self.videoView, -40)
    .heightIs(20);
    [self.cancelTip setSingleLineAutoResizeWithMaxWidth:200];
    //闪光灯按钮
    self.flashModelBtn.sd_layout
    .topSpaceToView(self.cancelButton,20)
    .leftSpaceToView(self.view,10)
    .widthIs(30)
    .heightIs(40);
}
//自定义的导航栏View
- (UIView *)topBarView
{
    if (!_topBarView) {
        _topBarView = [UIView new];
        _topBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _topBarView.frame = CGRectMake(0, 0, self.view.width, 64);
        [self.view addSubview:_topBarView];
        
        self.cancelButton = [UIButton new];
        [self.cancelButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton.frame = CGRectMake(20, 20, 40, _topBarView.height - 20);
        
        [_topBarView addSubview:self.cancelButton];
    }
    
    return _topBarView;
}


#pragma  mark ------------------触摸拍照的事件 ------------------
#pragma mark touchs
- (void)panView:(UIPanGestureRecognizer *)pan
{
    if ([self.captureMovieFileOutput isRecording]) {
        CGPoint point = [pan locationInView:pan.view];
        CGRect touchRect = CGRectMake(point.x, point.y, 1, 1);
        BOOL isIn = CGRectIntersectsRect(self.takeButton.frame, touchRect);
        
        self.cancelTip.hidden = isIn;
        self.shouldCancel = !isIn;
        
        UIColor *tintColor = Global_tintColor;
        if (!isIn) {
            tintColor = [UIColor redColor];
        }
        
        [self.takeButton setTitleColor:tintColor forState:UIControlStateNormal];
        self.progressView.progressLine.backgroundColor = tintColor;
        
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed) {
            [self endRecordingVideo];
        }
    }
}


//取消按钮事件
- (void)cancelButtonClicked
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupTimer
{
    self.progressView.hidden = NO;
    self.videoLength = 0;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:kProgressTimerTimeInterval target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

- (void)removeTimer
{
    self.progressView.progress = 0;
    self.progressView.hidden = YES;
    
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgress
{
    if (self.videoLength >= kMaxVideoLength) {
        [self removeTimer];
        [self endRecordingVideo];
        return;
    }
    self.videoLength += kProgressTimerTimeInterval;
    CGFloat progress = self.videoLength / kMaxVideoLength;
    self.progressView.progress = progress;
}

- (void)setupCaptureSession
{
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480])
    {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPreset640x480;
    }
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //初始化设备输出对象，用于获得输出数据
    _captureMovieFileOutput=[[AVCaptureMovieFileOutput alloc]init];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection=[_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported ]) {
            captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    CALayer *layer=self.videoView.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame=layer.bounds;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    //将视频预览层添加到界面中
    //[layer addSublayer:_captureVideoPreviewLayer];
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
    _enableRotation=YES;
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupCaptureSession];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

- (BOOL)isRecordingVideo
{
    return [self.captureMovieFileOutput isRecording];
}

-(void)dealloc{
    [self removeNotification];
}

#pragma mark - UI方法


- (void)show
{
    if (!_captureDeviceInput) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法获取到后置摄像头" message:@"请退出操作" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil];
        [alert show];
    }
    //    self.pan.enabled = YES;
    self.view.frame = [UIScreen mainScreen].bounds;
    self.videoView.hidden = NO;
    self.takeButton.hidden = self.videoView.hidden;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kHomeTableViewAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.captureSession startRunning];
    });
    [self.view layoutSubviews];
}

- (void)hidde
{
    //    self.pan.enabled = NO;
    self.view.height = 300;
    //    self.view.backgroundColor = [UIColor whiteColor];
    //    self.videoView.hidden = YES;
    self.takeButton.hidden = self.videoView.hidden;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kHomeTableViewAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.captureSession stopRunning];
    });
}

#pragma mark         ==================        闪光灯          ==================

//切换闪光灯
- (void)flashClick:(UIButton *)sender
{
    _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
    BOOL con1 = [_videoDevice hasTorch];    //支持手电筒模式
    BOOL con2 = [_videoDevice hasFlash];    //支持闪光模式
    
    if (con1 && con2)
    {
        [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
            if (_videoDevice.flashMode == AVCaptureFlashModeOn)         //闪光灯开
            {
                [_videoDevice setFlashMode:AVCaptureFlashModeOff];
                [_videoDevice setTorchMode:AVCaptureTorchModeOff];
            }else if (_videoDevice.flashMode == AVCaptureFlashModeOff)  //闪光灯关
            {
                [_videoDevice setFlashMode:AVCaptureFlashModeOn];
                [_videoDevice setTorchMode:AVCaptureTorchModeOn];
            }
            NSLog(@"现在的闪光模式是AVCaptureFlashModeOn么?是你就扣1, %zd",_videoDevice.flashMode == AVCaptureFlashModeOn);
        }];
        sender.selected=!sender.isSelected;
    }else{
        NSLog(@"不能切换闪光模式");
    }
    
}
#pragma mark 获取摄像头-->前/后

- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}


#pragma mark -              =============== 屏幕旋转 事件 =================
//是否可以选择屏幕
-(BOOL)shouldAutorotate{
    return self.enableRotation;
}

//屏幕旋转时调整视频预览图层的方向
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    AVCaptureConnection *captureConnection=[self.captureVideoPreviewLayer connection];
    captureConnection.videoOrientation=(AVCaptureVideoOrientation)toInterfaceOrientation;
}
//旋转后重新设置大小
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    _captureVideoPreviewLayer.frame=self.videoView.bounds;
}



#pragma mark     ============-------      视频录制     ------===============


//按住开始拍摄！！！！
- (void)startRecordingVideo
{
    self.cancelTip.hidden = YES;
    [self setupTimer];
    
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    if (![self.captureMovieFileOutput isRecording]) {
        self.enableRotation=NO;
        //如果支持多任务则则开始多任务
        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
            self.backgroundTaskIdentifier=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        }
        //预览图层和视频方向保持一致
        captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
        NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mp4"];
        NSLog(@"save path is11 :%@",outputFielPath);
        NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
        [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    }
}

//松开手时候的事件
- (void)endRecordingVideo
{
    [self removeTimer];
    if ([self.captureMovieFileOutput isRecording]) {
        [self.captureMovieFileOutput stopRecording];//停止录制
    }
}

- (void)takeButtonClick:(UIButton *)sender {
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    if (![self.captureMovieFileOutput isRecording]) {
        self.enableRotation=NO;
        //如果支持多任务则则开始多任务
        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
            self.backgroundTaskIdentifier=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        }
        //预览图层和视频方向保持一致
        captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
        NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mp4"];
        NSLog(@"save path is :%@",outputFielPath);
        NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
        [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    }
    else{
        [self.captureMovieFileOutput stopRecording];//停止录制
    }
}
//yasuo
- (CGFloat)fileSize:(NSURL *)path
{
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}

#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制...");
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    
    self.cancelTip.hidden = YES;
    [self.takeButton setTitleColor:Global_tintColor forState:UIControlStateNormal];
    self.progressView.progressLine.backgroundColor = Global_tintColor;
    
    
    if (self.shouldCancel) {
        self.shouldCancel = NO;
        return;
    }
    NSLog(@"视频录制完成.");
    //视频录入完成之后在后台将视频存储到相簿
    self.enableRotation=YES;
    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier=self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier=UIBackgroundTaskInvalid;
    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
        }
        if (lastBackgroundTaskIdentifier!=UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdentifier];
        }
        NSLog(@"成功保存视频到相簿.");
        [self pushToPlay:outputFileURL];
    }];
    
}
//跳转到发送页面
- (void)pushToPlay:(NSURL *)url
{
    SendVideoView *postVC = [[SendVideoView alloc]init];
    postVC.videoUrl = url;
    [self presentViewController:postVC animated:YES completion:nil];
}
#pragma mark - 通知
/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}


/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    NSLog(@"会话发生错误.");
}

#pragma mark - 私有方法

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}


/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    
    UITapGestureRecognizer *singleTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.delaysTouchesBegan = YES;
    
    UITapGestureRecognizer *doubleTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.delaysTouchesBegan = YES;
    
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [self.videoView addGestureRecognizer:singleTapGesture];
    [self.videoView addGestureRecognizer:doubleTapGesture];
}

//设置焦距
//单击
-(void)singleTap:(UITapGestureRecognizer *)tapGesture{
    
    NSLog(@"单击");
    
    CGPoint point= [tapGesture locationInView:self.videoView];
    //将UI坐标转化为摄像头坐标,摄像头聚焦点范围0~1
    CGPoint cameraPoint= [_captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorAnimationWithPoint:point];
    
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        
        //聚焦
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            NSLog(@"聚焦模式修改为%zd",AVCaptureFocusModeContinuousAutoFocus);
        }else{
            NSLog(@"聚焦模式修改失败");
        }
        
        //聚焦点的位置
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:cameraPoint];
        }
        
        /*
         @constant AVCaptureExposureModeLocked  曝光锁定在当前值
         Indicates that the exposure should be locked at its current value.
         
         @constant AVCaptureExposureModeAutoExpose 曝光自动调整一次然后锁定
         Indicates that the device should automatically adjust exposure once and then change the exposure mode to AVCaptureExposureModeLocked.
         
         @constant AVCaptureExposureModeContinuousAutoExposure 曝光自动调整
         Indicates that the device should automatically adjust exposure when needed.
         
         @constant AVCaptureExposureModeCustom 曝光只根据设定的值来
         Indicates that the device should only adjust exposure according to user provided ISO, exposureDuration values.
         
         */
        //曝光模式
        if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }else{
            NSLog(@"曝光模式修改失败");
        }
        
        //曝光点的位置
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:cameraPoint];
        }
        
        
    }];
}
//双击
-(void)doubleTap:(UITapGestureRecognizer *)tapGesture{
    
    NSLog(@"双击");
    
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        if (captureDevice.videoZoomFactor == 1.0) {
            CGFloat current = 1.5;
            if (current < captureDevice.activeFormat.videoMaxZoomFactor) {
                [captureDevice rampToVideoZoomFactor:current withRate:10];
            }
        }else{
            [captureDevice rampToVideoZoomFactor:1.0 withRate:10];
        }
    }];
}
//光圈动画
-(void)setFocusCursorAnimationWithPoint:(CGPoint)point{
    self.focusCircle.center = point;
    self.focusCircle.transform = CGAffineTransformIdentity;
    self.focusCircle.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.focusCircle.transform=CGAffineTransformMakeScale(0.5, 0.5);
        self.focusCircle.alpha = 0.0;
    }];
}
//更改设备属性前一定要锁上
-(void)changeDevicePropertySafety:(void (^)(AVCaptureDevice *captureDevice))propertyChange{
    //也可以直接用_videoDevice,但是下面这种更好
    AVCaptureDevice *captureDevice= [_captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁,意义是---进行修改期间,先锁定,防止多处同时修改
    BOOL lockAcquired = [captureDevice lockForConfiguration:&error];
    if (!lockAcquired) {
        NSLog(@"锁定设备过程error，错误信息：%@",error.localizedDescription);
    }else{
        [_captureSession beginConfiguration];
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
        [_captureSession commitConfiguration];
    }
}
//光圈
- (UIView *)focusCircle{
    if (!_focusCircle) {
        UIView *focusCircle = [[UIView alloc] init];
        focusCircle.frame = CGRectMake(0, 0, 100, 100);
        focusCircle.layer.borderColor = [UIColor orangeColor].CGColor;
        focusCircle.layer.borderWidth = 2;
        focusCircle.layer.cornerRadius = 50;
        focusCircle.layer.masksToBounds =YES;
        _focusCircle = focusCircle;
        [self.videoView addSubview:focusCircle];
    }
    return _focusCircle;
}
@end
