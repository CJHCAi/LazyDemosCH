//
//  CPJImageClipping.m
//  IOSTestFramework
//
//  Created by shuaizhai on 11/27/15.
//  Copyright © 2015 com.shuaizhai. All rights reserved.
//

#import "CPJImageClipping.h"
#import "CPJClippingPanel.h"

#define BOUNDCE_DURATION 0.3f

@interface CPJImageClipping ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign)CGFloat scale;
@property (nonatomic, assign)CGFloat rotaion;
@property (nonatomic, assign)CGPoint centerPoint;
@property (nonatomic, assign)CGPoint touchPoint;

@end

@implementation CPJImageClipping


- (void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.view.clipsToBounds = YES;
    
    self.view.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
    pinchGesture.delegate = self;
    [self.view addGestureRecognizer:pinchGesture];
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureAction:)];
    rotationGesture.delegate = self;
    
    // 暂时不开启旋转功能
    //
    /*[self.view addGestureRecognizer:rotationGesture];*/

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 将图片缩放至裁剪框的边缘
    //
    CGRect squareFrame = self.clippingPanel.gridLayer.clippingRect;
    CGFloat length = MIN(squareFrame.size.height , squareFrame.size.width);
    CGFloat imageLength = MIN(self.image.size.width, self.image.size.height);
    self.clippingPanel.imageView.transform = CGAffineTransformScale(self.clippingPanel.imageView.transform, length/imageLength, length/imageLength);
    // 处理图片小于裁剪框的情况
    //
    [self.clippingPanel handleScaleOverflowWithPoint:self.clippingPanel.imageView.center];
    CGPoint newCenter = [self.clippingPanel handleBorderOverflow];
    self.clippingPanel.imageView.center = newCenter;
    [self.clippingPanel show];
}

- (UIImage *)rotateImage:(UIImage *)image onDegrees:(float)degrees
{
    CGFloat rads = degrees;
    float newSide = MAX([image size].width, [image size].height);
    CGSize size =  CGSizeMake(newSide, newSide);
    CGSize tempSize = image.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(ctx, -image.size.width/2, -image.size.height/2);
    
    CGContextRotateCTM(ctx, -rads);
    CGContextTranslateCTM(ctx, image.size.width, image.size.height);
    CGFloat rotation = atan2(self.clippingPanel.imageView.transform.b, self.clippingPanel.imageView.transform.a);
    CGFloat x = [image size].width/2, y = [image size].height/2;
    x= x * cosf(-rotation) - y * sinf(-rotation);
    y= x * sinf(-rotation) + y * cosf(-rotation);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(),CGRectMake(-[image size].width/2,-[image size].height/2,tempSize.width, tempSize.height),image.CGImage);
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}

- (UIImage *)clippImage{

    CGRect squareFrame = self.clippingPanel.gridLayer.clippingRect;
    CGFloat scaleRatio = self.clippingPanel.imageView.frame.size.width / self.image.size.width;
    CGFloat x = (squareFrame.origin.x - self.clippingPanel.imageView.frame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - self.clippingPanel.imageView.frame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.height / scaleRatio;
    CGRect myImageRect = CGRectMake(x, y, w, h);
    UIImage *image = [self.image copy];
    image = [self croppIngimageByImageName:image toRect:myImageRect];

    return image;
    
}

- (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}


+(UIImage*)scaleDown:(UIImage*)img withSize:(CGSize)newSize{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newSize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, newSize.width, newSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
    
}

#pragma mark - 手势操作
/**
 * 平移手势
 */
- (void)panGestureAction:(UIPanGestureRecognizer *)panGestureRecognizer{
    UIView *view = self.clippingPanel.imageView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x , view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
        self.centerPoint = CGPointMake(self.centerPoint.x + translation.x, self.centerPoint.y + translation.y);

    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint newCenter = [self.clippingPanel handleBorderOverflow];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.clippingPanel.imageView.center = newCenter; 
        }];

    }
}

/**
 * 放缩手势
 */
- (void)pinchGestureAction:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    UIView *view = self.clippingPanel.imageView;
    self.touchPoint = [pinchGestureRecognizer locationInView:self.view];
    CGPoint point = [pinchGestureRecognizer locationInView:self.view];
    if(pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGFloat vectorX,vectorY;
        vectorX = (point.x - view.center.x)*pinchGestureRecognizer.scale;
        vectorY = (point.y - view.center.y)*pinchGestureRecognizer.scale;
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        
        [view setCenter:(CGPoint){(point.x - vectorX) , (point.y - vectorY)}];
        pinchGestureRecognizer.scale = 1;

    }else if(pinchGestureRecognizer.state == UIGestureRecognizerStateEnded){
        [self.clippingPanel handleScaleOverflowWithPoint:point];
        CGPoint newCenter = [self.clippingPanel handleBorderOverflow];
        self.clippingPanel.imageView.center = newCenter;
    }
}

/**
 * 旋转手势
 */
- (void)rotationGestureAction:(UIRotationGestureRecognizer *)rotationGestureRecognizer{
    UIView *view = self.clippingPanel.imageView;
    CGPoint point = [rotationGestureRecognizer locationInView:self.view];
    if(rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGFloat vectorX,vectorY;
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        vectorX = (point.x - view.center.x) * cos(rotationGestureRecognizer.rotation) - (point.y - view.center.y) * sin(rotationGestureRecognizer.rotation);
        vectorY = (point.x - view.center.x) * sin(rotationGestureRecognizer.rotation) + (point.y - view.center.y) * cos(rotationGestureRecognizer.rotation);
        [view setCenter:(CGPoint){(point.x - vectorX) , (point.y - vectorY)}];
        rotationGestureRecognizer.rotation = 0;

    }else if(rotationGestureRecognizer.state == UIGestureRecognizerStateEnded){
        CGPoint newCenter = [self.clippingPanel handleBorderOverflow];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.clippingPanel.imageView.center = newCenter;
        }];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

/**
 * 解决图片旋转的问题
 */
- (UIImage *)fixOrientation:(UIImage *)srcImg {
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - 懒加载

- (CPJClippingPanel *)clippingPanel{
    if(!_clippingPanel){
        _clippingPanel = [[CPJClippingPanel alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_clippingPanel];
    }
    return _clippingPanel;
}

- (void)setClippingRect:(CGRect)clippingRect{
    self.clippingPanel.gridLayer.clippingRect = clippingRect;
    [self.clippingPanel initializeImageViewSize];
}

- (CGRect)clippingRect{
    return self.clippingPanel.gridLayer.clippingRect;
}

- (void)setImage:(UIImage *)image{
    self.clippingPanel.imageView.image = [self fixOrientation:image];
    [self.clippingPanel initializeImageViewSize];
}

- (UIImage *)image{
    return self.clippingPanel.imageView.image;
}




@end
