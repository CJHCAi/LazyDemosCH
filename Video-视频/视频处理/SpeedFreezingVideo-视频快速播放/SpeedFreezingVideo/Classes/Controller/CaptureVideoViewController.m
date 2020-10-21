//
//  CaptureVideoViewController.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/14.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "CaptureVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CapturePreviewView.h"
#import "CaptureVideoButton.h"
#import "VideoEditingController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMotion/CoreMotion.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define ERROR_TO_EXIT_WITH_MSG(msg) [self errorToExitWithMessage:msg]
//todo 发生某些错误需要停止视频拍摄功能，对策：返回上一页

@interface CaptureVideoViewController () <CapturePreviewViewDelegate, AVCaptureFileOutputRecordingDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet CapturePreviewView *videoPreviewView;
@property (weak, nonatomic) IBOutlet UIImageView *assetThumbnailImageView;
@property (weak, nonatomic) IBOutlet UIView *prepareMaskView;
@property (weak, nonatomic) IBOutlet UIButton *changeCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *switchFlashButton;

@property (strong, nonatomic) AVCaptureSession *captureSession;

@property (strong, nonatomic) AVCaptureDevice *audioDevice;
@property (strong, nonatomic) AVCaptureDevice *videoDevice;

@property (strong, nonatomic) AVCaptureDeviceInput *audioInput;
@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;

@property (strong, nonatomic) AVCaptureMovieFileOutput *videoOutput;
@property (strong, nonatomic) NSURL *videoOutputUrl;

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (assign, nonatomic) AVCaptureVideoOrientation deviceOrientation;
@property (strong, nonatomic) ALAsset *albumLastVideo;
@property (assign, nonatomic) BOOL isCaptureSessionPrepared;
@end

@implementation CaptureVideoViewController

- (void)dealloc {
    [_motionManager stopDeviceMotionUpdates];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self rebootCapture];
    [self selectLastVideoAssetFromAblum];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _prepareMaskView.hidden = NO;
    [self accessAuthorization];
    [self configureAlbumLastVideoImageView];
    [self startMotionManager];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)accessAuthorization {
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized:
            [self configureCapture];
            break;
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [self configureCapture];
                } else {
                    ERROR_TO_EXIT_WITH_MSG(@"摄像头或麦克风权限被拒绝，如需正常使用请于设置->隐私打开权限");
                }
            }];
            break;
        }
        case AVAuthorizationStatusDenied:
            ERROR_TO_EXIT_WITH_MSG(@"摄像头或麦克风权限被拒绝，如需正常使用请于设置->隐私打开权限");
            break;
        case AVAuthorizationStatusRestricted:
            ERROR_TO_EXIT_WITH_MSG(@"您无法改变被锁定的权限");
            break;
        default:
            break;
    }
}

- (void)configureAlbumLastVideoImageView {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLastVideo)];
    [self.assetThumbnailImageView addGestureRecognizer:tapGesture];
    [self.assetThumbnailImageView setUserInteractionEnabled:YES];
}

- (void)selectLastVideo {
    UIImagePickerController *myImagePickerController = [[UIImagePickerController alloc] init];
    myImagePickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    myImagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    myImagePickerController.delegate = self;
    myImagePickerController.editing = NO;
    [self presentViewController:myImagePickerController animated:YES completion:nil];
}

- (void)configureCapture {
    //session
    self.captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    } else {
        NSLog(@"ERROR: using default SessionPreset");
        if ([_captureSession canSetSessionPreset:_captureSession.sessionPreset]) {
            [_captureSession setSessionPreset:_captureSession.sessionPreset];
        } else {
            NSString *errorString = [NSString stringWithFormat:@"Can not set AVCaptureSession sessionPreset, using default %@", _captureSession.sessionPreset];
            ERROR_TO_EXIT_WITH_MSG(errorString);
        }
    }
    
    [_captureSession beginConfiguration];
    //使用后置摄像头
    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //配置video input
    self.videoInput = [self createMediaInputWithDevice:_videoDevice mediaType:AVMediaTypeVideo];
    [self captureSessionAddInput:_videoInput mediaType:AVMediaTypeVideo];
    //配置音频
    self.audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //配置audio input
    self.audioInput = [self createMediaInputWithDevice:_audioDevice mediaType:AVMediaTypeAudio];
    [self captureSessionAddInput:_audioInput mediaType:AVMediaTypeAudio];
    //视频输出
    self.videoOutput = [[AVCaptureMovieFileOutput alloc] init];
    if (![_captureSession canAddOutput:_videoOutput]) {
        ERROR_TO_EXIT_WITH_MSG(@"视频输出配置出错");
    } else {
        [_captureSession addOutput:_videoOutput];
        //todo 这些有用?
        AVCaptureConnection *captureConnection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
//            captureConnection.videoScaleAndCropFactor = captureConnection.videoMaxScaleAndCropFactor;
        } else {
            ERROR_TO_EXIT_WITH_MSG(@"视频稳定性配置出错");
        }
    }
    //配置预览view
    [self configureVideoPreview];
    [_captureSession commitConfiguration];
    //准备好了
    self.isCaptureSessionPrepared = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //启动会话
        [_captureSession startRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            _prepareMaskView.hidden = YES;
        });
    });
}

- (void)configureVideoOutput {
    self.videoOutput = [[AVCaptureMovieFileOutput alloc] init];
}

- (void)rebootCapture {
    if (_isCaptureSessionPrepared) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_captureSession startRunning];
        });
    }
}

//是否有摄像头工作
- (BOOL)hasMultipleCameraDevices {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (devices != nil) {
        return YES;
    }
    return NO;
}

- (NSUInteger)cameraCount {
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

- (BOOL)canSwitchCamera {
    return [self cameraCount] > 1;
}

//切换摄像头
- (void)changeCameraDevice {
    if (! [self canSwitchCamera]) {
        NSLog(@"部分摄像头设备无法工作");
        return;
    }
    switch (_videoDevice.position) {
        case AVCaptureDevicePositionBack:
            self.videoDevice = [self cameraWithPosition:AVCaptureDevicePositionFront];
            break;
        case AVCaptureDevicePositionFront:
            self.videoDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
            break;
        default:
            break;
    }
    
    //todo 切换时锁定设备，防止同时修改
    AVCaptureDeviceInput *videoInput = [self createMediaInputWithDevice:_videoDevice mediaType:AVMediaTypeVideo];
    [_captureSession beginConfiguration];
    [self captureSessionChangeVideoInput:videoInput];
    [_captureSession commitConfiguration];
}

//配置媒体输入容错
- (AVCaptureDeviceInput *)createMediaInputWithDevice:(AVCaptureDevice *)device mediaType:(NSString *)mediaType {
    if (nil != device) {
        NSError *videoInputError;
        AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&videoInputError];
        if (nil == videoInputError) {
            return videoInput;
        } else {
            if ([mediaType isEqualToString:AVMediaTypeAudio]) {
                ERROR_TO_EXIT_WITH_MSG(@"配置音频输入设备出错");
            } else if ([mediaType isEqualToString:AVMediaTypeVideo]) {
                ERROR_TO_EXIT_WITH_MSG(@"配置视频输入设备出错");
            }
        }
    }
    return nil;
}

- (BOOL)captureSessionAddInput:(AVCaptureDeviceInput *)input mediaType:(NSString *)mediaType {
    if (nil != input) {
        if ([_captureSession canAddInput:input]) {
            [_captureSession addInput:input];
            if ([mediaType isEqualToString:AVMediaTypeAudio]) {
                _audioInput = input;
            } else if ([mediaType isEqualToString:AVMediaTypeVideo]) {
                _videoInput = input;
            }
            
            return YES;
        }
    } else {
        ERROR_TO_EXIT_WITH_MSG(@"获取媒体输入设备出错");
    }
    return NO;
}

//切换摄像头
- (void)captureSessionChangeVideoInput:(AVCaptureDeviceInput *)input {
    if (nil != input) {
        [_captureSession removeInput:_videoInput];
        if ( ![self captureSessionAddInput:input mediaType:AVMediaTypeVideo]) {
            if (nil != _videoInput) {
                [_captureSession addInput:_videoInput];
                NSLog(@"ERROR: 不能成功切换摄像头");
            }
        }
    } else {
        ERROR_TO_EXIT_WITH_MSG(@"获取视频输入设备错误");
    }
}

//获取指定摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    AVCaptureDevice *willingDevice;
    NSArray *cameraDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in cameraDevices) {
        if (device.position == position) {
            willingDevice = device;
            break;
        }
    }
    if (nil == willingDevice) {
        NSLog(@"ERROR: 获取指定摄像头失败");
    }
    return willingDevice;
}

- (void)configureVideoPreview {
    [self.videoPreviewView setSession:_captureSession];
    self.videoPreviewView.delegate = self;
    
    //Gesture
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [_videoPreviewView addGestureRecognizer:panGesture];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translate = [gesture translationInView:self.view];
    if (translate.x > 150) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//解决点击对焦后每移动一下就zoom一下摄像头整个焦段问题
- (void)correctFocus {
    [self focusAtCapturePoint:CGPointMake(0.5f, 0.5f)];
}

//对焦
- (void)focusAtCapturePoint:(CGPoint)point {
    if ([_videoDevice isFocusPointOfInterestSupported] &&
        [_videoDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        //获得锁再操作设备
        NSError *error;
        if ([_videoDevice lockForConfiguration:&error]) {
            _videoDevice.focusPointOfInterest = point;
            _videoDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            [_videoDevice unlockForConfiguration];
        } else {
            NSLog(@"Configuration Failed ERROR: %@", error);
        }
    }
}

//测光
- (void)exposeAtCapturePoint:(CGPoint)point {
    if ([_videoDevice isExposurePointOfInterestSupported] &&
            [_videoDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        //获得锁再操作设备
        NSError *error;
        if ([_videoDevice lockForConfiguration:&error]) {
            _videoDevice.exposurePointOfInterest = point;
            _videoDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            //测光完毕后 锁定曝光
            /*
            if ([_videoDevice isExposureModeSupported:AVCaptureExposureModeLocked]) {
                [_videoDevice addObserver:self forKeyPath:@"adjustingExposure" options:NSKeyValueObservingOptionNew context:nil];
            }
            */
            [_videoDevice unlockForConfiguration];
        } else {
            NSLog(@"Configuration Failed ERROR: %@", error);
        }
    }
}

- (void)startRecording {
    if (![self videoRecording]) {
        AVCaptureConnection *videoConnection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([videoConnection isVideoOrientationSupported]) {
            videoConnection.videoOrientation = _deviceOrientation;
        }
        
        if ([videoConnection isVideoStabilizationSupported]) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {//iOS8.0以下
                videoConnection.enablesVideoStabilizationWhenAvailable = YES;
            } else {
                videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
            }
        }
        
        //todo 这里为什么做这个set NO?
        if (_videoDevice.isSmoothAutoFocusSupported) {
            NSError *error;
            if ([_videoDevice lockForConfiguration:&error]) {
                [_videoDevice setSmoothAutoFocusEnabled:NO];
                [_videoDevice unlockForConfiguration];
            } else {
                NSLog(@"ERROR");
            }
        }
        
        _videoOutputUrl = [self outputUrl];
        [_videoOutput startRecordingToOutputFileURL:_videoOutputUrl recordingDelegate:self];
        
    }
}

- (NSURL *)outputUrl {
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    //todo 以上两步为何
    NSString *outputFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"speedFreezing.mov"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputFilePath]) {
        NSError *error;
        if (![[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:&error]) {
            NSLog(@"ERROR: 清除旧文件发生错误");
        }
    }
    return [NSURL fileURLWithPath:outputFilePath];
}

- (void)stopRecording {
    if ([self videoRecording]) {
        [_videoOutput stopRecording];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_captureSession stopRunning];
        });
    }
}

- (AVCaptureVideoOrientation)currentVideoOrientation {
    AVCaptureVideoOrientation orientation;
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        default:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
    }
    return orientation;
}

- (BOOL)videoRecording {
    return [_videoOutput isRecording];
}

- (void)startMotionManager{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 1/2.0;
    if (_motionManager.deviceMotionAvailable) {
        NSLog(@"Device Motion Available");
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler: ^(CMDeviceMotion *motion, NSError *error){
            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    } else {
        NSLog(@"No device motion on device.");
        [self setMotionManager:nil];
    }
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion {
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    if (fabs(y) >= fabs(x)) {
        if (y >= 0) {
            self.deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
        } else {
            self.deviceOrientation = AVCaptureVideoOrientationPortrait;
        }
    } else {
        if (x >= 0) {
            self.deviceOrientation = UIDeviceOrientationLandscapeRight;
        }
        else {
            self.deviceOrientation = UIDeviceOrientationLandscapeLeft;
        }
    }
}

//setter
- (void)setDeviceOrientation:(AVCaptureVideoOrientation)deviceOrientation {
    if (_deviceOrientation != deviceOrientation) {
        //变化
        [self synchroniseThumbnailImageViewOrientation:deviceOrientation];
    }
    _deviceOrientation = deviceOrientation;
}

//同步相册预览View旋转
- (void)synchroniseThumbnailImageViewOrientation:(AVCaptureVideoOrientation)deviceOrientation {
    CGAffineTransform transform;
    switch (deviceOrientation) {
        case AVCaptureVideoOrientationPortrait:
            transform = CGAffineTransformMakeRotation(0);
            break;
        case UIDeviceOrientationLandscapeLeft:
            transform = CGAffineTransformMakeRotation(M_PI/2);
            break;
        case UIDeviceOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(-M_PI/2);
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            transform = CGAffineTransformMakeRotation(M_PI);
            break;
    }
    [UIView animateWithDuration:0.5f animations:^{
        _assetThumbnailImageView.transform = transform;
        _changeCameraButton.transform = transform;
    }];
}

- (void)selectLastVideoAssetFromAblum {
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    self.albumLastVideo = result;
                    [self.assetThumbnailImageView setImage:[UIImage imageWithCGImage:result.thumbnail]];
                }
                *stop = YES;
            }];
            *stop = YES;
        }
    } failureBlock:^(NSError *error) {
        ;
    }];
}

- (void)errorToExitWithMessage:(NSString *)message {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    NSLog(@"ERROR: %@", message);
    [errorAlert show];
}

#pragma mark - delegate
- (void)previewViewFocusAtCapturePoint:(CGPoint)point {
    //刷新对焦
    [self focusAtCapturePoint:point];
    //刷新测光
    [self exposeAtCapturePoint:point];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self correctFocus];
    });
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    NSLog(@"开始录制");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    NSLog(@"录制完成");
    if (outputFileURL.absoluteString.length == 0) {
        ERROR_TO_EXIT_WITH_MSG(@"保存视频错误，有可能由内存不足导致");
    } else {
        //这里可以考虑保存相册
        VideoEditingController *editingController = [[VideoEditingController alloc] initWithAssetUrl:outputFileURL];
        //绑定视频方向
        objc_setAssociatedObject(outputFileURL, &kOrientation, @(_deviceOrientation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.navigationController pushViewController:editingController animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *infoKey = UIImagePickerControllerMediaURL;
    NSURL *assetUrl = [info objectForKey:infoKey];
    [picker dismissViewControllerAnimated:YES completion:^{
        VideoEditingController *editingController = [[VideoEditingController alloc] initWithAssetUrl:assetUrl];
        [self.navigationController pushViewController:editingController animated:YES];
    }];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - KVO
//部分版本不支持AutoExposure来持续保持曝光，需用KVO修改成Locked
/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"adjustingExposure"]) {
        if (![_videoDevice isAdjustingExposure] &&
            [_videoDevice isExposureModeSupported:AVCaptureExposureModeLocked]) {
            //移除监听
            [object removeObserver:self forKeyPath:@"adjustingExposure"];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                if ([_videoDevice lockForConfiguration:&error]) {
                    //锁定曝光
                    _videoDevice.exposureMode = AVCaptureExposureModeLocked;
                    [_videoDevice unlockForConfiguration];
                }
            });
        }
    }
}
*/

#pragma mark - IBAction
- (IBAction)clickCaptureButton:(CaptureVideoButton *)sender {
    if ([self videoRecording]) {
        //停止
        [sender endCaptureAnimation];
        [self stopRecording];
    } else {
        //开始
        [sender beginCaptureAnimation];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self startRecording];
        });
    }
}

- (IBAction)clickChangeCameraButton:(id)sender {
    [self changeCameraDevice];
}

- (IBAction)clickSwitchFlashButton:(id)sender {
    if ([_videoDevice hasTorch]) {
        NSError *error;
        if ([_videoDevice lockForConfiguration:&error]) {
            if (_videoDevice.torchMode == AVCaptureTorchModeOff) {
                [_videoDevice setTorchMode:AVCaptureTorchModeOn];
                [sender setTitle:@"打开" forState:UIControlStateNormal];
                [((UIButton *)sender) setTransform:CGAffineTransformMakeScale(-1, 1)];
                [UIView animateWithDuration:0.3f animations:^{
                    [((UIButton *)sender) setTransform:CGAffineTransformMakeScale(1, 1)];
                }];
            } else {
                [_videoDevice setTorchMode:AVCaptureTorchModeOff];
                [sender setTitle:@"关闭" forState:UIControlStateNormal];
                [((UIButton *)sender) setTransform:CGAffineTransformMakeScale(-1, 1)];
                [UIView animateWithDuration:0.3f animations:^{
                    [((UIButton *)sender) setTransform:CGAffineTransformMakeScale(1, 1)];
                }];
            }
        }
    }
}

- (IBAction)clickSlideBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
