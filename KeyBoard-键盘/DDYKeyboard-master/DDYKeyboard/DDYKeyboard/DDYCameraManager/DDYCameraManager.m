#import "DDYCameraManager.h"

#ifndef DDYScreenW
#define DDYScreenW [UIScreen mainScreen].bounds.size.width
#endif

#ifndef DDYScreenH
#define DDYScreenH [UIScreen mainScreen].bounds.size.height
#endif

/** 更改属性 */
typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface DDYCameraManager ()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>
/** 串行队列 */
@property (nonatomic, strong) dispatch_queue_t cameraSerialQueue;
/** 视频预览层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
/** 捕获会话 */
@property (nonatomic, strong) AVCaptureSession *captureSession;
/** 音频输入 */
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;
/** 视频输入 */
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
/** 图片输出 */
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;
/** 音频输出 */
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioOutput;
/** 视频输出 */
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
/** 录制视屏的保存路径URL */
@property (nonatomic, strong) NSURL *videoURL;
/** 资源写入 */
@property (nonatomic, strong) AVAssetWriter *assetWriter;
/** 音频输出 */
@property (nonatomic, strong) AVAssetWriterInput *assetAudioInput;
/** 视频输出 */
@property (nonatomic, strong) AVAssetWriterInput *assetVideoInput;
/** 像素缓存适配器 */
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor;
/** 是否录制 */
@property (nonatomic, assign) BOOL isRecording;

@end

@implementation DDYCameraManager

#pragma mark - 懒加载

- (dispatch_queue_t)cameraSerialQueue {
    if (!_cameraSerialQueue) {
        _cameraSerialQueue = dispatch_queue_create("com.ddyCamera.serialQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _cameraSerialQueue;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = [UIScreen mainScreen].bounds;
    }
    return _previewLayer;
}

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        // 会话质量
        if ([_captureSession canSetSessionPreset:self.sessionPreset]) {
            [_captureSession setSessionPreset:self.sessionPreset];
        }
        // 视频输入
        if ([_captureSession canAddInput:self.videoInput]) {
            [_captureSession addInput:self.videoInput];
        }
        // 音频输入
        if ([_captureSession canAddInput:self.audioInput]) {
            [_captureSession addInput:self.audioInput];
        }
        // 图片输出
        if ([_captureSession canAddOutput:self.imageOutput]) {
            [_captureSession addOutput:self.imageOutput];
        }
        // 视频输出
        if ([_captureSession canAddOutput:self.videoOutput]) {
            [_captureSession addOutput:self.videoOutput];
        }
        // 音频输出
        if ([_captureSession canAddOutput:self.audioOutput]) {
            [_captureSession addOutput:self.audioOutput];
        }
    }
    return _captureSession;
}

#pragma mark 会话质量
- (NSString *)sessionPreset {
    if (!_sessionPreset) {
        _sessionPreset = AVCaptureSessionPresetHigh;
    }
    return _sessionPreset;
}

#pragma mark 音频输入
- (AVCaptureDeviceInput *)audioInput {
    if (!_audioInput) {
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        _audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:nil];
    }
    return _audioInput;
}

#pragma mark 视频输入
- (AVCaptureDeviceInput *)videoInput {
    if (!_videoInput) {
        AVCaptureDevice *videoDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
        _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:nil];
    }
    return _videoInput;
}

#pragma mark 图片输出
- (AVCaptureStillImageOutput *)imageOutput {
    if (!_imageOutput) {
        _imageOutput = [[AVCaptureStillImageOutput alloc] init];
        _imageOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    }
    return _imageOutput;
}

#pragma mark 音频输出
- (AVCaptureAudioDataOutput *)audioOutput {
    if (!_audioOutput) {
        _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [_audioOutput setSampleBufferDelegate:self queue:self.cameraSerialQueue];
    }
    return _audioOutput;
}

#pragma mark 视频输出
- (AVCaptureVideoDataOutput *)videoOutput {
    if (!_videoOutput) {
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        _videoOutput.alwaysDiscardsLateVideoFrames = YES; // 是否允许卡顿时丢帧
        [_videoOutput setSampleBufferDelegate:self queue:self.cameraSerialQueue];
    }
    return _videoOutput;
}

#pragma mark 视屏格式
- (AVFileType)videoType {
    if (!_videoType) {
        _videoType = AVFileTypeMPEG4;
    }
    return _videoType;
}

#pragma mark 视屏录制保存路径
- (NSURL *)videoURL {
    if (!_videoURL) {
//        NSString *videoPath = [NSString stringWithFormat:@"%@%lf.mov",NSTemporaryDirectory(), ceil([[NSDate date] timeIntervalSince1970])];
        NSString *videoPath = [NSString stringWithFormat:@"%@%@.mov",NSTemporaryDirectory(), @"ddy_record"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
        }
        _videoURL = [NSURL fileURLWithPath:videoPath];
    }
    return _videoURL;
}

#pragma mark 视屏资源输入
- (AVAssetWriterInput *)assetVideoInput {
    if (!_assetVideoInput) {
        //写入视频大小
        NSInteger numPixels = DDYScreenW * DDYScreenH;
        //每像素比特
        CGFloat bitsPerPixel = 6.0;
        NSInteger bitsPerSecond = numPixels * bitsPerPixel;
        // 码率和帧率设置
        NSDictionary *compressionProperties = @{AVVideoAverageBitRateKey:@(bitsPerSecond),
                                                AVVideoExpectedSourceFrameRateKey:@(30),
                                                AVVideoMaxKeyFrameIntervalKey:@(30),
                                                AVVideoProfileLevelKey:AVVideoProfileLevelH264BaselineAutoLevel};
        // AVVideoWidthKey,AVVideoHeightKey 是横屏状态高宽 当不是16整数倍可能出现绿边
        NSDictionary *outputSetting = @{AVVideoCodecKey:AVVideoCodecH264,
                                        AVVideoWidthKey:@(ceil(DDYScreenH / 16) * 16),
                                        AVVideoHeightKey:@(ceil(DDYScreenW / 16) * 16),
                                        AVVideoCompressionPropertiesKey:compressionProperties};
        _assetVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:outputSetting];
        // 要从captureSession实时获取数据
        _assetVideoInput.expectsMediaDataInRealTime = YES;
        _assetVideoInput.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
    }
    return _assetVideoInput;
}

#pragma mark 音频资源输入
- (AVAssetWriterInput *)assetAudioInput {
    if (!_assetAudioInput) {
        AudioChannelLayout acl;
        bzero(&acl, sizeof(acl));
        acl.mChannelLayoutTag = kAudioChannelLayoutTag_Mono;
        
        NSDictionary *outputSetting = @{AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                                        AVSampleRateKey:@(22050), // 设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
                                        AVEncoderBitRatePerChannelKey:@(28000),
                                        AVNumberOfChannelsKey:@(1),
                                        AVChannelLayoutKey:[NSData dataWithBytes: &acl length: sizeof(acl)]};
        _assetAudioInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio outputSettings:outputSetting];
        _assetAudioInput.expectsMediaDataInRealTime = YES;
    }
    return _assetAudioInput;
}

#pragma mark 资源写入
- (AVAssetWriter *)assetWriter {
    if (!_assetWriter) {
        // 初始化写入媒体类型为MP4类型
        _assetWriter = [AVAssetWriter assetWriterWithURL:self.videoURL fileType:AVFileTypeMPEG4 error:nil];
        // 使其更适合在网络上播放
        _assetWriter.shouldOptimizeForNetworkUse = YES;
        // 添加视屏资源输入
        if ([_assetWriter canAddInput:self.assetVideoInput]) {
            [_assetWriter addInput:self.assetVideoInput];
        }
        // 添加音频资源输入
        if ([_assetWriter canAddInput:self.assetAudioInput]) {
            [_assetWriter addInput:self.assetAudioInput];
        }
    }
    return _assetWriter;
}

+ (instancetype)ddy_CameraWithContainerView:(UIView *)view {
    return [[self alloc] initWithContainerView:view];
}

- (instancetype)initWithContainerView:(UIView *)view {
    if (self = [super init]) {
        [view.layer insertSublayer:self.previewLayer atIndex:0];
        [self.captureSession startRunning];
    }
    return self;
}

#pragma mark 开启捕捉会话
- (void)ddy_StartCaptureSession {
    if (!_captureSession.isRunning){
        [_captureSession startRunning];
    }
}

#pragma mark 停止捕捉会话
- (void)ddy_StopCaptureSession {
    if (_captureSession.isRunning){
        [_captureSession stopRunning];
    }
}

#pragma mark 切换摄像头
- (void)ddy_ToggleCamera {
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1) {
        AVCaptureDevice *currentDevice = [self.videoInput device];
        AVCaptureDevicePosition currentPosition = [currentDevice position];
        // 如果原来是前置摄像头或未设置则切换后为后置摄像头
        BOOL toChangeBack = (currentPosition==AVCaptureDevicePositionUnspecified || currentPosition==AVCaptureDevicePositionFront);
        AVCaptureDevicePosition toChangePosition = toChangeBack ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
        AVCaptureDevice *toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
        // 获得要调整的设备输入对象
        AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
        // 改变会话的配置前一定要先开启配置，配置完成后提交配置改变
        [self.captureSession beginConfiguration];
        // 移除原有输入对象
        [self.captureSession removeInput:self.videoInput];
        // 添加新的输入对象
        if ([self.captureSession canAddInput:toChangeDeviceInput]) {
            [self.captureSession addInput:toChangeDeviceInput];
            self.videoInput = toChangeDeviceInput;
        }
        // 提交会话配置
        [self.captureSession commitConfiguration];
        // 切换摄像头后原来闪光灯失效
        [self ddy_SetFlashMode:AVCaptureFlashModeAuto];
    }
}

#pragma mark 设置闪光灯模式
- (void)ddy_SetFlashMode:(AVCaptureFlashMode)flashMode {
    __weak __typeof__ (self)weakSelf = self;
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        __strong __typeof__ (weakSelf)strongSelf = weakSelf;
        if ([captureDevice hasFlash] &&[captureDevice isFlashModeSupported:flashMode]) {
            // 如果手电筒补光打开则先关闭
            if ([captureDevice hasTorch] && [captureDevice torchMode]==AVCaptureTorchModeOn) {
                [strongSelf ddy_SetTorchMode:AVCaptureTorchModeOff];
            }
            [captureDevice setFlashMode:flashMode];
        }
    }];
}

#pragma mark 设置补光模式
- (void)ddy_SetTorchMode:(AVCaptureTorchMode)torchMode {
    __weak __typeof__ (self)weakSelf = self;
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        __strong __typeof__ (weakSelf)strongSelf = weakSelf;
        if ([captureDevice hasTorch] &&[captureDevice isTorchModeSupported:torchMode]) {
            // 如果闪光灯打开则先关闭
            if ([captureDevice hasFlash] && [captureDevice flashMode]==AVCaptureFlashModeOn) {
                [strongSelf ddy_SetFlashMode:AVCaptureFlashModeOff];
            }
            [captureDevice setTorchMode:torchMode];
        }
    }];
}

#pragma mark 光感系数
- (void)ddy_ISO:(BOOL)isMAX {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        CGFloat maxISO = captureDevice.activeFormat.maxISO;
        [captureDevice setExposureModeCustomWithDuration:AVCaptureExposureDurationCurrent ISO:isMAX ? maxISO : 400 completionHandler:nil];
    }];
}

#pragma mark 聚焦/曝光
- (void)ddy_FocusAtPoint:(CGPoint)point {
    CGPoint cameraPoint = [self.previewLayer captureDevicePointOfInterestForPoint:point];
    
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:cameraPoint];
        }
        if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:cameraPoint];
        }
    }];
}

#pragma mark 焦距范围 0.0-1.0
- (void)ddy_ChangeFocus:(CGFloat)focus {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [captureDevice setFocusModeLockedWithLensPosition:focus completionHandler:^(CMTime syncTime) { }];
        }
    }];
}

#pragma mark 数码变焦 1-3倍
- (void)ddy_ChangeZoom:(CGFloat)zoom {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        [captureDevice rampToVideoZoomFactor:zoom withRate:50];
    }];
}

#pragma mark 慢动作拍摄开关
- (void)ddy_VideoSlow:(BOOL)isSlow {
    [self.captureSession stopRunning];
    CGFloat desiredFPS = isSlow ? 240. : 60.;
    AVCaptureDevice *videoDevice = self.videoInput.device;
    AVCaptureDeviceFormat *selectedFormat = nil;
    int32_t maxWidth = 0;
    AVFrameRateRange *frameRateRange = nil;
    for (AVCaptureDeviceFormat *format in [videoDevice formats]) {
        for (AVFrameRateRange *range in format.videoSupportedFrameRateRanges) {
            CMFormatDescriptionRef desc = format.formatDescription;
            CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(desc);
            int32_t width = dimensions.width;
            if (range.minFrameRate <= desiredFPS && desiredFPS <= range.maxFrameRate && width >= maxWidth) {
                selectedFormat = format;
                frameRateRange = range;
                maxWidth = width;
            }
        }
    }
    if (selectedFormat) {
        if ([videoDevice lockForConfiguration:nil]) {
            videoDevice.activeFormat = selectedFormat;
            videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
            videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
            [videoDevice unlockForConfiguration];
        }
    }
    [self.captureSession startRunning];
}

#pragma mark 防抖模式 AVCaptureVideoStabilizationModeCinematic AVCaptureVideoStabilizationModeOff
- (void)ddy_VideoStabilizationMode:(AVCaptureVideoStabilizationMode)stabilizationMode {
    AVCaptureConnection *captureConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *videoDevice = self.videoInput.device;
    if ([videoDevice.activeFormat isVideoStabilizationModeSupported:stabilizationMode]) {
        captureConnection.preferredVideoStabilizationMode = stabilizationMode;
    }
}

#pragma mark 拍照
- (void)ddy_TakePhotos {
    AVCaptureConnection *imageConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (imageConnection.isVideoOrientationSupported) {
        // https://blog.csdn.net/mrtianxiang/article/details/78339388
        imageConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    }
    __weak __typeof__ (self)weakSelf = self;
    // 根据连接取得设备输出的数据
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:imageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        __strong __typeof__ (weakSelf)strongSelf = weakSelf;
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf.takeFinishBlock) {
                    strongSelf.takeFinishBlock([UIImage imageWithData:imageData]);
                }
            });
        }
    }];
}

#pragma mark 播放系统拍照声
- (void)ddy_palySystemTakePhotoSound {
    AudioServicesPlaySystemSound(1108);
}

#pragma mark 录制重置
- (void)ddy_ResetRecorder {
    _assetVideoInput = nil;
    _assetAudioInput = nil;
    _videoURL = nil;
    _assetWriter = nil;
    _isRecording = NO;
}

#pragma mark 开始录制视频
- (void)ddy_StartRecorder {
    self.isRecording = YES;
}

#pragma mark 结束录制视频
- (void)ddy_StopRecorder {
    __weak __typeof__ (self)weakSelf = self;
    [self.assetWriter finishWritingWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof__ (weakSelf)strongSelf = weakSelf;
            if (strongSelf.recordFinishBlock) {
                strongSelf.recordFinishBlock(strongSelf.videoURL);
            }
        });
    }];
    self.isRecording = NO;
}

#pragma mark - Private methods
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in devices) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

#pragma mark 改变设备属性(闪光灯,手电筒,切换摄像头)
- (void)changeDeviceProperty:(PropertyChangeBlock)propertyChange {
    AVCaptureDevice *captureDevice = [self.videoInput device];
    // 注意改变设备属性前先加锁,调用完解锁
    if ([captureDevice lockForConfiguration:nil]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    @autoreleasepool {
        // 录制
        if (self.isRecording) {
            if (!_assetWriter) {
                [self.assetWriter startWriting];
                [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
            }
            
            if (CMSampleBufferDataIsReady(sampleBuffer) && self.assetWriter.status == AVAssetWriterStatusWriting) {
                CFRetain(sampleBuffer);
                if (captureOutput == self.videoOutput && self.assetVideoInput.readyForMoreMediaData) {
                    [self.assetVideoInput appendSampleBuffer:sampleBuffer];
                } else if (captureOutput == self.audioOutput && self.assetAudioInput.readyForMoreMediaData) {
                    [self.assetAudioInput appendSampleBuffer:sampleBuffer];
                }
                CFRelease(sampleBuffer);
            }
        }
        // 光强检测
        if (captureOutput == self.videoOutput) {
            CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
            NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
            CFRelease(metadataDict); 
            NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
            float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
            if (self.brightnessValueBlock) {
                self.brightnessValueBlock(brightnessValue);
            }
        }
    }
}

@end
