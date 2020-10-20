//
//  CamerasManager.m
//  CameraDemo
//
//  Created by apple on 2017/4/11.
//  Copyright © 2017年 yangchao. All rights reserved.
//

#import "CamerasManager.h"
#import "GPUImageBeautyFilter.h"
#import "GPUImageBeautifyFilter.h"
//#import "UIImage+Rotating.h"
#define kWeakSelf __weak typeof(self) weakSelf = self;
@interface CamerasManager()<CAAnimationDelegate,AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,GPUImageVideoCameraDelegate>
{
    CALayer * _faceLayer;
    CGRect _faceFrame;
}

@property (nonatomic, strong)GPUImageFilterGroup *normalFilter;
@property(nonatomic,strong)GPUImageBeautyFilter * beautyFilter;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;

@property (nonatomic, strong) CALayer *focusLayer;//聚焦图片
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;//人脸识别
@property (nonatomic,assign) BOOL canFaceRecognition;//default is No ,是否可以对焦人脸；
@property (nonatomic, assign) BOOL isStartFaceRecognition;

@property (nonatomic, strong) UIImageView *faceImageView;

@property (nonatomic, strong) AVMetadataObject *metadataObject;

@property(nonatomic,strong)NSMutableArray * metadaArray;

@property (nonatomic, strong) CIDetector *faceDetector;
@property(nonatomic,strong)UIImage*image;

@property(nonatomic,strong)UILabel * faceLable;
@end

static int count=0;
@implementation CamerasManager
-(void)dealloc
{
    NSLog(@"wangjunfeng");
}
- (instancetype)initWithParentView:(UIView *)view
{
    self=[super init];
    if (self) {
        
        [self setUIWith:view];
        
    }
    return self;
}
-(void)setGetfloats:(CGFloat)getfloats
{
    _getfloats=getfloats;
}
-(UILabel*)faceLable{
    if (_faceLable==nil) {
        _faceLable=[[UILabel alloc]initWithFrame:CGRectZero];
        _faceLable.backgroundColor=[UIColor clearColor];
    }
    return _faceLable;
}
-(void)setUIWith:(UIView*)view
{
    [view addSubview:self.faceLable];
    
    self.gpuImageView = ({
        GPUImageView *g = [[GPUImageView alloc] init];
        g.frame=view.frame;
        [g.layer addSublayer:self.focusLayer];
        [g addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusTap:)]];
        [g setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
        [view addSubview:g];
        g;
    });
    
         if ([self.stillCamera.inputCamera lockForConfiguration:nil]) {
    
            if ([self.stillCamera.inputCamera isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
                  [self.stillCamera.inputCamera setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            }
            //自动对焦
            if ([self.stillCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                [self.stillCamera.inputCamera setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
//            //自动曝光
//            if ([self.stillCamera.inputCamera isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
//                [self.stillCamera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
//            }
//            
//            [self.stillCamera.inputCamera unlockForConfiguration];
    
     
     }
    self.canFaceRecognition=YES;
    self.isStartFaceRecognition=YES;
    
    self.faceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 3"]];
    self.faceImageView.hidden=YES;
    [view addSubview:_faceImageView];
    
    [self.stillCamera addTarget:self.beautyFilter];
    [self.beautyFilter addTarget:self.gpuImageView];
//    [self.stillCamera addTarget:self.normalFilter];
//    [self.normalFilter addTarget:self.gpuImageView];
    [self.stillCamera startCameraCapture];
    
    
    _faceLayer = [[CALayer alloc] init];
    
    UIImage * face = [UIImage imageNamed:@"facerect"];
    _faceLayer.contents = (id) face.CGImage;
    _faceLayer.contentsCenter = CGRectMake(0.4, 0.4, 0.2, 0.2);
    
    [self.gpuImageView.layer addSublayer:_faceLayer];
    if (!self.previewLayer) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.stillCamera.captureSession];
        self.previewLayer.frame = self.gpuImageView.frame;
        [self addFaceRecognizeWithView:view];
    }


    self.stillCamera.horizontallyMirrorFrontFacingCamera = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.stillCamera.horizontallyMirrorFrontFacingCamera = YES;
    });
    
    
}
- (void) addFaceRecognizeWithView:(UIView*)view{
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    if ([self.stillCamera.captureSession canAddOutput:metadataOutput]) {
        [self.stillCamera.captureSession addOutput:metadataOutput];
        //_faceUICache =[NSMutableDictionary dictionary];
        NSArray* supportTypes =metadataOutput.availableMetadataObjectTypes;
        
        if ([supportTypes containsObject:AVMetadataObjectTypeFace]) {
            [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
            [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            metadataOutput.rectOfInterest = view.bounds;
            
        }
        self.metadataOutput = metadataOutput;
    }

}
-(CALayer*)focusLayer
{
    if (!_focusLayer) {
        UIImage *focusImage = [UIImage imageNamed:@"touch_focus_x"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, focusImage.size.width, focusImage.size.height)];
        imageView.image = focusImage;
        _focusLayer = imageView.layer;
        _focusLayer.hidden = YES;
    }
    return _focusLayer;
}
-(GPUImageBeautyFilter*)beautyFilter
{
    if (!_beautyFilter) {
        _beautyFilter = [[GPUImageBeautyFilter alloc] init];
    }
    return _beautyFilter;
}
- (GPUImageFilterGroup *)normalFilter {
    if (!_normalFilter) {
        GPUImageFilter *filter = [[GPUImageFilter alloc] init]; //默认
        _normalFilter = [[GPUImageFilterGroup alloc] init];
        [(GPUImageFilterGroup *) _normalFilter setInitialFilters:[NSArray arrayWithObject: filter]];
        [(GPUImageFilterGroup *) _normalFilter setTerminalFilter:filter];
    }
    return _normalFilter;
}
- (GPUImageStillCamera *)stillCamera {
    if (!_stillCamera) {
        _stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionFront];
        _stillCamera.delegate=self;
        _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        _stillCamera.horizontallyMirrorFrontFacingCamera = YES;
        self.stillCamera.horizontallyMirrorRearFacingCamera = NO;
      

    }
    return _stillCamera;
}
#pragma mark self.gpuImageView点击聚焦
- (void)focusTap:(UITapGestureRecognizer *)tap
{
    self.gpuImageView.userInteractionEnabled = NO;
    CGPoint touchPoint = [tap locationInView:tap.view];
    [self layerAnimationWithPoint:touchPoint];
    touchPoint = CGPointMake(touchPoint.x / tap.view.bounds.size.width, touchPoint.y / tap.view.bounds.size.height);
    
    if ([self.stillCamera.inputCamera isFocusPointOfInterestSupported] && [self.stillCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([self.stillCamera.inputCamera lockForConfiguration:&error]) {
            [self.stillCamera.inputCamera setFocusPointOfInterest:touchPoint];
            [self.stillCamera.inputCamera setFocusMode:AVCaptureFocusModeAutoFocus];
            
            if([self.stillCamera.inputCamera isExposurePointOfInterestSupported] && [self.stillCamera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [self.stillCamera.inputCamera setExposurePointOfInterest:touchPoint];
                [self.stillCamera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            if ([self.stillCamera.inputCamera isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
                [self.stillCamera.inputCamera setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            }
            
            [self.stillCamera.inputCamera unlockForConfiguration];
            
        } else {
            NSLog(@"ERROR = %@", error);
        }
    }
    
}
#pragma mark - AnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self performSelector:@selector(focusLayerNormal) withObject:self afterDelay:0.1f];
}
- (void)focusLayerNormal {
    self.gpuImageView.userInteractionEnabled = YES;
    _focusLayer.hidden = YES;
}
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

- ( UIImage* )imageWithImageSimple:( UIImage* )image scaledToSize:( CGSize )newSize{

    UIGraphicsBeginImageContext (newSize);

    [image drawInRect : CGRectMake ( 0 , 0 ,newSize. width ,newSize. height )];

    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext ();

    UIGraphicsEndImageContext ();

    return newImage;
}


//拍照方法
- (void)takePhotoWithImageBlock:(void(^)(UIImage *originImage,UIImage*ScreenshotsImage))block
{
    
        [self.stillCamera capturePhotoAsImageProcessedUpToFilter:self.beautyFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
            self.image=processedImage;
            
//            [self saveImageToPhone:processedImage];

            UIImage * getimage=[self imageWithImageSimple:processedImage scaledToSize:CGSizeMake(960, 1280)];
//            [self saveImageToPhone:getimage];

            CGFloat w=getimage.size.width/[UIScreen mainScreen].bounds.size.width;
            CGFloat h=getimage.size.height/[UIScreen mainScreen].bounds.size.height;
            UIImage *image=[self getImageByCuttingImage:getimage Rect:CGRectMake(_faceFrame.origin.x*w-MatchW(270), _faceFrame.origin.y*h-MatchH(400), _faceFrame.size.width*w+MatchW(540), _faceFrame.size.width*w+MatchW(540))];
            
//            CGFloat Wscale=_faceFrame.origin.x*w/2;
//            CGFloat Hscale=_faceFrame.origin.y*h/2;
//            UIImage *image=[self getImageByCuttingImage:processedImage Rect:CGRectMake(Wscale, Hscale, _faceFrame.size.width*w+Wscale*2, _faceFrame.size.width*w+Wscale*2)];
//            NSLog(@"脸面对比 %f==%f==%f==%f",_faceFrame.origin.x,_faceFrame.origin.y,_faceFrame.size.width,_faceFrame.size.width);
            
            if (image) {

//                UIImage * image1=[self GPUImageWithImage:image];

//                [self saveImageToPhone:image1];


                dispatch_async(dispatch_get_main_queue(), ^{

                    block(processedImage,image);
                    
//                    [weak.stillCamera stopCameraCapture];
                });
                
            }

            
            
//            CGFloat wang=SCREENWIDTH/processedImage.size.width;
//            
//            CGRect rect=self.metadataObject.bounds;
//            
//            CGPoint point=CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2);
//            
//            CGFloat X=(rect.origin.y * processedImage.size.width )*wang-MatchW(30);
//            CGFloat Y=(rect.origin.x * processedImage.size.height)*wang-MatchW(30);
//            CGFloat W=(rect.size.width * processedImage.size.width * 3)+MatchW(30);
//            CGFloat H=(rect.size.width * processedImage.size.width * 3)+MatchW(30);
//            
//            self.faceLable.frame=CGRectMake(0, 0, W, W);
//            self.faceLable.center=CGPointMake(point.x*960, point.y*1280);
//            if ((W+X)>=720.0) {
//                W=W-(W+X-720.0);
//                CGRect getRect=CGRectMake(X, Y, W, H);
//
//                UIImage* image= [self getImageByCuttingImage:processedImage Rect:getRect];
//                if (image) {
//                    
//                    UIImage * image1=[self GPUImageWithImage:image];
//                    
//                    [self saveImageToPhone:image1];
//                    
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        block(processedImage,image1);
//                    });
//                    
//                }
//
//            }else{
//                CGRect getRect=CGRectMake(X, Y, W, H);
//                
//                UIImage* image= [self getImageByCuttingImage:processedImage Rect:getRect];
//                if (image) {
//                    
//                    UIImage * image1=[self GPUImageWithImage:image];
//                    
//                    [self saveImageToPhone:image1];
//                    
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        block(processedImage,image1);
//                    });
//                    
//                }
//
//            }
            
        }];

}
- (void)saveImageToPhone:(UIImage*)image {
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
        
    }
    
}
/**
 *  切换闪光灯模式
 *
 *
 */
- (void)switchFlashModeWithBtn:(UIButton*)flashBtn
{
    count++;
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass!=nil) {
    
        if ([self.stillCamera.inputCamera hasFlash] && [self.stillCamera.inputCamera hasTorch]) {
            
            [self.stillCamera.inputCamera lockForConfiguration:nil];
            if (count%2==0) {
                [self.stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOff];
                [self.stillCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
                [flashBtn setBackgroundImage:[UIImage imageNamed:@"facerect"] forState:UIControlStateNormal];
            }else
            {
                [self.stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
                [self.stillCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
                 [flashBtn setBackgroundImage:[UIImage imageNamed:@"icon_flashlight"] forState:UIControlStateNormal];
            }
            
            [self.stillCamera.inputCamera unlockForConfiguration];
            
        }        
    }
}
/**
 *  切换前后镜
 *
 *
 */
- (void)addVideoInputFrontCamera
{
    [self.stillCamera pauseCameraCapture];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.stillCamera rotateCamera];
        [self.stillCamera resumeCameraCapture];
    });
    
    [self performSelector:@selector(animationCamera) withObject:self afterDelay:0.2f];
    
}
#pragma mark 切换前后镜跳转动画

- (void)animationCamera {
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = .5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    [self.gpuImageView.layer addAnimation:animation forKey:nil];
    
}
#pragma mark 美白按钮点击
-(void)filterAction:(id)sender
{
    UIButton * filterBtn=(UIButton*)sender;
    if (filterBtn.selected) {
        filterBtn.selected = NO;
        [self.stillCamera removeAllTargets];
        [self.stillCamera addTarget:self.normalFilter];
        [self.normalFilter addTarget:self.gpuImageView];
    }else {
        filterBtn.selected = YES;
        [self.stillCamera removeAllTargets];
        [self.stillCamera addTarget:self.beautyFilter];
        [self.beautyFilter addTarget:self.gpuImageView];
    }
    
    
}



- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
{

    if (self.metadaArray && self.metadaArray.count > 0) {
//        [self makeFaceWithCIImage:images.CIImage];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.faceImageView.hidden = YES;
        });
        
    }

}
- (void)makeFaceWithCIImage:(CIImage *)inputImage
{
    for (AVMetadataFaceObject *faceObject in self.metadaArray) {
        CGRect faceBounds = faceObject.bounds;
     
        CGFloat centerX = inputImage.extent.size.width * (faceBounds.origin.x + faceBounds.size.width/2);
        CGFloat centerY = inputImage.extent.size.height * (1 - faceBounds.origin.y - faceBounds.size.height /2);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.faceImageView.hidden = NO;
            self.faceImageView.frame = CGRectMake(0, 0, faceBounds.size.height * (self.gpuImageView.frame.size.height), faceBounds.size.height * (self.gpuImageView.frame.size.height));
            self.faceImageView.center = CGPointMake(centerX, centerY + 44);
            
        });
    }
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    uint8_t *baseAddress = (uint8_t*)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    CGImageRelease(quartzImage);
    if (image) {
        //        NSLog(@"image ------------------------- %@",image);
    }
    return (image);
}

#pragma -mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    self.metadaArray=(NSMutableArray*)metadataObjects;
    AVMetadataObject *metadataObjectds=[metadataObjects lastObject];
    
    self.metadataObject=metadataObjectds;
    
    if (self.canFaceRecognition) {
        
        for(AVMetadataObject *metadataObject in metadataObjects) {
            if([metadataObject.type isEqualToString:AVMetadataObjectTypeFace]) {
                
                AVMetadataFaceObject* face = (AVMetadataFaceObject*)metadataObject;
                CGRect faceRectangle = [face bounds];
                
                if (self.metadataObject.bounds.size.width==faceRectangle.size.width) {
                    NSLog(@"相等了");
                }
                
                self.getfloats=MatchW(faceRectangle.size.width* self.gpuImageView.frame.size.width * 2);
            
                
                
                if (metadataObject) {
                    [self showFaceImageWithFrame:faceRectangle];

                }
                
                
                
                AVMetadataObject *objec = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
                if ([objec isKindOfClass:[AVMetadataFaceObject class]]) {
                    AVMetadataFaceObject * faceObj = (AVMetadataFaceObject *) objec;
                    _faceLayer.hidden = YES;
                    _faceLayer.frame = faceObj.bounds;
                    _faceFrame=faceObj.bounds;
                    NSLog(@"%f--%f--%f--%f",faceObj.bounds.origin.x,faceObj.bounds.origin.y,faceObj.bounds.size.width,faceObj.bounds.size.height);
                    
                }

                
            }else{
                _faceLayer.hidden = YES;

            }
        }
        
        
    }
    
}
/**
 *  人脸框的动画
 *
 *
 */
- (void)showFaceImageWithFrame:(CGRect)rect
{
    if (self.metadaArray&&self.metadaArray.count>0&&self.isStartFaceRecognition==YES) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.faceImageView.hidden = YES;
            self.faceImageView.frame = CGRectMake(rect.origin.y * self.gpuImageView.frame.size.width-MatchW(40), rect.origin.x * self.gpuImageView.frame.size.height-MatchW(20), rect.size.width * self.gpuImageView.frame.size.width * 2+MatchW(20), rect.size.width * self.gpuImageView.frame.size.width * 2+MatchW(20));
            NSLog(@"%f==%f",self.faceImageView.center.x,self.faceImageView.center.y);
            self.center=self.faceImageView.center;
        
        
            });

        
//        });
    }else
    {
    }
  //
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.faceImageView.hidden=YES;
    });
//    NSLog(@"王松锋%f",self.faceImageView.frame.size.width);

}

-(UIImage *)getImageByCuttingImage:( UIImage *)image Rect:( CGRect )rect{
    
    // 大图 bigImage
    
    // 定义 myImageRect ，截图的区域
    
    CGRect myImageRect = rect;
    
    UIImage * bigImage= image;
    
    CGImageRef imageRef = bigImage. CGImage ;
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect (imageRef, myImageRect);
    
    CGSize size;
    
    size. width = rect. size . width ;
    
    size. height = rect. size . height ;
    
    UIGraphicsBeginImageContext (size);
    
    CGContextRef context = UIGraphicsGetCurrentContext ();
    
    CGContextDrawImage (context, myImageRect, subImageRef);
    
    UIImage * smallImage = [ UIImage imageWithCGImage :subImageRef];
    
    UIGraphicsEndImageContext ();
    
    return smallImage;
    
}

#pragma  mark 在做一次美颜磨皮

-(UIImage*)GPUImageWithImage:(UIImage*)image
{
//     GPUImageBrightnessFilter *filter1 = [[GPUImageBrightnessFilter alloc] init];
//
//     filter1.brightness=0.2;

    //磨皮
    
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    
    GPUImageBeautifyFilter *filter = [[GPUImageBeautifyFilter alloc] init];
    
    [filter forceProcessingAtSize:image.size];
    
    [pic addTarget:filter];
    
    [pic processImage];
    
    [filter useNextFrameForImageCapture];
    
    image =[filter imageFromCurrentFramebuffer];

    
    
    return image;
}

@end
