//
//  LMCameraManager.m
//  Test1030
//
//  Created by xx11dragon on 15/10/30.
//  Copyright © 2015年 xx11dragon. All rights reserved.
//

#import "LMCameraManager.h"
#import "GPUImage.h"
#import "LMFilterGroup.h"
#import "LMCameraFilters.h"
#import "UBLookupEffectFilter.h"
#import "LMHahaFilters.h"

@interface LMCameraManager ()<CAAnimationDelegate, AVCaptureMetadataOutputObjectsDelegate>{
    CGRect _frame;
    CALayer *_focusLayer;
    CALayer * _faceLayer;
}
//@property (nonatomic , strong) NSArray *filters;

@property (nonatomic , strong) GPUImageStillCamera *camera;

@property (nonatomic , strong) GPUImageView *cameraScreen;

@property (nonatomic , strong) LMFilterGroup *currentGroup;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;
@property (nonatomic, assign) NSInteger lastFaceId;

@end


@implementation LMCameraManager

+ (LMCameraManager *)cameraManager {
    static LMCameraManager * _cameraManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cameraManager = [[LMCameraManager alloc] init];
    });
    return _cameraManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void) setVieweFrame:(CGRect)frame superview:(UIView *)superview{
    _frame = frame;
    [superview addSubview:self.cameraScreen];
}

#pragma mark 初始化
- (void)setup {
    [self setFlashMode:LMCameraManagerFlashModeAuto];
    _filters = [self createFilterList];
    
    _lastFaceId = -1;
    _faceLayer = [[CALayer alloc] init];

    UIImage * face = [UIImage imageNamed:@"faceRect"];
    _faceLayer.contents = (id) face.CGImage;
    _faceLayer.contentsCenter = CGRectMake(0.4, 0.4, 0.2, 0.2);
}

#pragma mark create filter list
-(NSArray *) createFilterList{
    NSMutableArray * arr = [NSMutableArray new];
    LMFilterGroup *f1 = [LMCameraFilters normal];
    LMFilterGroup *f2 = [LMCameraFilters beautyGroup];
    [arr addObject:f1];
    [arr addObject:f2];
    

    NSArray * lookupArr = [UBLookupEffectFilter loadLookupFilter];
    
    [arr addObjectsFromArray:lookupArr];
    
    LMFilterGroup * f3 = [LMHahaFilters vignetteGroup];
    [arr addObject:f3];
    
    LMFilterGroup * f4 = [LMHahaFilters swirlGroup];
    [arr addObject:f4];
    
    LMFilterGroup * f5 = [LMHahaFilters bulgeDistortionGroup];
    [arr addObject:f5];
    
    LMFilterGroup * f6 = [LMHahaFilters pinchDistortionGroup];
    [arr addObject:f6];
    
    LMFilterGroup * f7 = [LMHahaFilters stretchDistortionGroup];
    [arr addObject:f7];
    
    LMFilterGroup * f8 = [LMHahaFilters glassSphereGroup];
    [arr addObject:f8];
    
    LMFilterGroup * f9 = [LMHahaFilters sphereRefractionGroup];
    [arr addObject:f9];
    
    LMFilterGroup *f10 = [LMCameraFilters contrast];
    [arr addObject:f10];
    LMFilterGroup *f11 = [LMCameraFilters exposure];
    [arr addObject:f11];
    LMFilterGroup *f12 = [LMCameraFilters saturation];
    [arr addObject:f12];
    LMFilterGroup *f13 = [LMCameraFilters testGroup1];
    [arr addObject:f13];

    self.currentGroup = f1;
    
    return arr;
}

#pragma mark 启用预览
- (void)startCamera{
    [self.camera startCameraCapture];
    [self autoFocusAndExpose];

    [self.cameraScreen.layer addSublayer:_faceLayer];
    if (!self.previewLayer) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.camera.captureSession];
        self.previewLayer.frame = self.cameraScreen.frame;
        [self addFaceRecognize];
    }
}

#pragma mark 关闭预览
- (void)stopCamera{
    [_faceLayer removeFromSuperlayer];

    [self.camera.captureSession stopRunning];
    [self.camera stopCameraCapture];
    [self.camera removeAllTargets];
}
#pragma mark 摄像头
- (GPUImageStillCamera *)camera {
    
    if (!_camera) {
        GPUImageStillCamera *camera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto
                                                                          cameraPosition:AVCaptureDevicePositionFront];
        camera.outputImageOrientation = UIInterfaceOrientationPortrait;
        camera.horizontallyMirrorFrontFacingCamera = YES;
        _camera = camera;
        
        
    }
    return _camera;
}

#pragma mark add face recognize
- (void) addFaceRecognize{
    AVCaptureMetadataOutput* metaDataOutput =[[AVCaptureMetadataOutput alloc] init];
    if ([self.camera.captureSession canAddOutput:metaDataOutput]) {
        [self.camera.captureSession addOutput:metaDataOutput];
     
        NSArray* supportTypes =metaDataOutput.availableMetadataObjectTypes;
        
        if ([supportTypes containsObject:AVMetadataObjectTypeFace]) {
            [metaDataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
            [metaDataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            
        }
    }
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex :0];
        if (metadataObject.type == AVMetadataObjectTypeFace) {
            
            AVMetadataObject *objec = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
            if ([objec isKindOfClass:[AVMetadataFaceObject class]]) {
                AVMetadataFaceObject * faceObj = (AVMetadataFaceObject *) objec;
                 _faceLayer.hidden = NO;
                _faceLayer.frame = faceObj.bounds;

//                if (_lastFaceId != faceObj.faceID) {
//                    _lastFaceId = faceObj.faceID;
//                    _faceLayer.hidden = NO;
//                    _faceLayer.frame = faceObj.bounds;
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        _faceLayer.hidden = YES;
//                    });
//                }else if (!_faceLayer.hidden){
//                    _faceLayer.frame = faceObj.bounds;
//                }

            }

            NSLog(@"%@",objec);
        }
    }else{
        _faceLayer.hidden = YES;
    }
}

#pragma mark 输出视图
- (GPUImageView *)cameraScreen {
    if (!_cameraScreen) {
        GPUImageView *cameraScreen = [[GPUImageView alloc] initWithFrame:_frame];
        cameraScreen.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        _cameraScreen = cameraScreen;
    }
    return _cameraScreen;
}

#pragma mark 添加手势
- (void) addGesture:(UIGestureRecognizer *)gesture{
    [_cameraScreen addGestureRecognizer:gesture];
}

#pragma mark 调焦距
- (void) setZoomFactor:(CGFloat)lenPosistion{
   
    if (lenPosistion < 1) {
        lenPosistion = 1;
    }
    
    if (lenPosistion > self.camera.inputCamera.activeFormat.videoMaxZoomFactor) {
        lenPosistion = self.camera.inputCamera.activeFormat.videoMaxZoomFactor;
    }
    @synchronized (self) {
        if (_zoomFactor == lenPosistion) {
            return;
        }
    
        NSError * error = nil;
        if([self.camera.inputCamera lockForConfiguration:&error]){
            
            self.camera.inputCamera.videoZoomFactor = lenPosistion;
            _zoomFactor = lenPosistion;
        }else{
            NSLog(@"error: %@", error);
        }
    }
}

#pragma mark 设置对焦图片
- (void)setfocusImage:(UIImage *)focusImage {
    if (!focusImage) return;
    
    if (!_focusLayer) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focus:)];
        [self.cameraScreen addGestureRecognizer:tap];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, focusImage.size.width, focusImage.size.height)];
    imageView.image = focusImage;
    CALayer *layer = imageView.layer;
    layer.hidden = YES;
    [self.cameraScreen.layer addSublayer:layer];
    _focusLayer = layer;
    
}

#pragma mark 摄像头位置
- (void)setPosition:(LMCameraManagerDevicePosition)position {
    _faceLayer.hidden = YES;
    _position = position;
    switch (position) {
        case LMCameraManagerDevicePositionBack: {
            if (self.camera.cameraPosition != AVCaptureDevicePositionBack) {
                [self.camera pauseCameraCapture];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    // something
                    [self.camera rotateCamera];
                    [self.camera resumeCameraCapture];
                    [self autoFocusAndExpose];
                    
                });
                [self performSelector:@selector(animationCamera) withObject:self afterDelay:0.2f];
            }

        }
            
            break;
        case LMCameraManagerDevicePositionFront: {
            if (self.camera.cameraPosition != AVCaptureDevicePositionFront) {
                [self.camera pauseCameraCapture];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    // something
                    [self.camera rotateCamera];
                    [self.camera resumeCameraCapture];
                    [self autoFocusAndExpose];
                    
                });
                [self performSelector:@selector(animationCamera) withObject:self afterDelay:0.2f];
            }
        }

            break;
        default:
            break;
    }
}

- (void) animationCamera {
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = .5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    [self.cameraScreen.layer addAnimation:animation forKey:nil];
    
}

#pragma mark 闪光灯
- (void)setFlashMode:(LMCameraManagerFlashMode)flashMode {
    _flashMode = flashMode;
    
    if (self.camera.cameraPosition != AVCaptureDevicePositionBack) {
        return;
    }
    
    switch (flashMode) {
        case LMCameraManagerFlashModeAuto: {
            [self.camera.inputCamera lockForConfiguration:nil];
            [self.camera.inputCamera setTorchMode:AVCaptureTorchModeAuto];
            [self.camera.inputCamera unlockForConfiguration];
        }
            break;
        case LMCameraManagerFlashModeOff: {
            [self.camera.inputCamera lockForConfiguration:nil];
            [self.camera.inputCamera setTorchMode:AVCaptureTorchModeOff];
            [self.camera.inputCamera unlockForConfiguration];
        }
            
            break;
        case LMCameraManagerFlashModeOn: {
            [self.camera.inputCamera lockForConfiguration:nil];
            [self.camera.inputCamera setTorchMode:AVCaptureTorchModeOn];
            [self.camera.inputCamera unlockForConfiguration];
        }
            break;
        default:
            break;
    }
}

#pragma mark 对焦

- (void)focus:(UITapGestureRecognizer *)tap {
    self.cameraScreen.userInteractionEnabled = NO;
    CGPoint touchPoint = [tap locationInView:tap.view];
    
    [self layerAnimationWithPoint:touchPoint];
   
    [self setFocusPoint:touchPoint in:tap.view];
}

-(void) setFocusPoint:(CGPoint ) point in:(UIView *) view{
    if ([self.camera cameraPosition] == AVCaptureDevicePositionFront) {
        point.x = view.bounds.size.width - point.x;
    }
    
    point = CGPointMake( point.y / view.bounds.size.height, 1 - point.x / view.bounds.size.width);
    
    NSError *error;
    if ([self.camera.inputCamera lockForConfiguration:&error]) {
        if ([self.camera.inputCamera isFocusPointOfInterestSupported] && [self.camera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]){
            [self.camera.inputCamera setFocusPointOfInterest:point];
            
            [self.camera.inputCamera setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if([self.camera.inputCamera isExposurePointOfInterestSupported] && [self.camera.inputCamera isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
            [self.camera.inputCamera setExposurePointOfInterest:point];
            [self.camera.inputCamera setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.camera.inputCamera unlockForConfiguration];
        
    } else {
        NSLog(@"ERROR = %@", error);
    }
}

-(void) autoFocusAndExpose{
    NSError * error = nil;
    if ([self.camera.inputCamera lockForConfiguration:&error]){
        if ([self.camera.inputCamera isFocusPointOfInterestSupported] && [self.camera.inputCamera isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]){
            [self.camera.inputCamera setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        
        if([self.camera.inputCamera isExposurePointOfInterestSupported] && [self.camera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]){
            
            [self.camera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
    }
}

#pragma mark 对焦动画
- (void)layerAnimationWithPoint:(CGPoint)point {
    if (_focusLayer) {
        CALayer *focusLayer = _focusLayer;
        
        focusLayer.hidden = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [focusLayer setPosition:point];
        focusLayer.transform = CATransform3DMakeScale(2.0f,2.0f,1.0f);
        [CATransaction commit];
        
        
        CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
        animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0f,1.0f,1.0f)];
        animation.delegate = self;
        animation.duration = 0.3f;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [focusLayer addAnimation: animation forKey:@"animation"];
    }
}

#pragma mark 拍照

- (void)snapshotSuccess:(void(^)(UIImage *image))success
        snapshotFailure:(void (^)(void))failure {
    
    [self.camera capturePhotoAsImageProcessedUpToFilter:self.currentGroup withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        
        if (!processedImage){
            failure();
        }else {
            success(processedImage);
        }

    }];

}

#pragma mark 设置滤镜

- (void)setFilterAtIndex:(NSInteger)index {
    _filterIndex = index;
    if (_filterIndex >= self.filters.count) {
        NSAssert(NO, @"filter index out of range: index= %ld", (long)index);
        _filterIndex = self.filters.count -1;
    }
    
    if (self.currentGroup) {
        [self.currentGroup removeTarget:self.cameraScreen];
    }
    
    [self.camera removeTarget:self.currentGroup];
    GPUImageFilterGroup *filter = self.filters[index];
    [self.camera addTarget:filter];
    self.currentGroup = (LMFilterGroup *)filter;
    [filter addTarget:self.cameraScreen];
}

#pragma mark 当前滤镜
-(LMFilterGroup *) currentFilterGroup{
    return self.filters[self.filterIndex];
}

#pragma mark - AnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    1秒钟延时
    [self performSelector:@selector(focusLayerNormal) withObject:self afterDelay:1.0f];
}

#pragma mark focusLayer回到初始化状态
- (void)focusLayerNormal {
    self.cameraScreen.userInteractionEnabled = YES;
    _focusLayer.hidden = YES;
}

-(CGFloat) combiIntensity  {
    return self.currentGroup.combiIntensity;
}

-(void) setCombiIntensity:(CGFloat)combiIntensity{
    self.currentGroup.combiIntensity = combiIntensity;
}
@end
