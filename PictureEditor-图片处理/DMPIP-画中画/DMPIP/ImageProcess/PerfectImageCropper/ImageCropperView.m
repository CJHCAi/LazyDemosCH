//
//  ImageCopperView.m
//  PerfectImageCropper
//
//  Created by Jin Huang on 11/22/12.
//
//

#import "ImageCropperView.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>

#import "UIImage+Rotation.h"

@interface ImageCropperView()
{
@private
    CGSize _originalImageViewSize;
}


@end

@implementation ImageCropperView

@synthesize imageView, image = _image, croppedImage;

- (void)setup
{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    if(self.imageView == nil){
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:imageView];
    }
    
    imageView.userInteractionEnabled = YES;
    
    
    UIRotationGestureRecognizer *rotateGes = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
    [imageView addGestureRecognizer:rotateGes];

    
    UIPinchGestureRecognizer *scaleGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
    [imageView addGestureRecognizer:scaleGes];

    
    UIPanGestureRecognizer *moveGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
    [moveGes setMinimumNumberOfTouches:1];
    [moveGes setMaximumNumberOfTouches:1];
    [imageView addGestureRecognizer:moveGes];

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = frame;
        [self setup];
    }
    
    return self;
}

float _lastTransX = 0.0, _lastTransY = 0.0;
- (void)moveImage:(UIPanGestureRecognizer *)sender
{
    CGPoint translatedPoint = [sender translationInView:self];
    if([sender state] == UIGestureRecognizerStateBegan) {
        _lastTransX = 0.0;
        _lastTransY = 0.0;
    }
    
    CGAffineTransform trans = CGAffineTransformMakeTranslation(translatedPoint.x - _lastTransX, translatedPoint.y - _lastTransY);
    CGAffineTransform newTransform = CGAffineTransformConcat(imageView.transform, trans);
    _lastTransX = translatedPoint.x;
    _lastTransY = translatedPoint.y;
    
    imageView.transform = newTransform;
}

float _lastScale = 1.0;
- (void)scaleImage:(UIPinchGestureRecognizer *)sender
{
    if([sender state] == UIGestureRecognizerStateBegan) {
        
        _lastScale = 1.0;
        return;
    }
    
    CGFloat scale = [sender scale]/_lastScale;
    
    CGAffineTransform currentTransform = imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [imageView setTransform:newTransform];
    
    _lastScale = [sender scale];
}

float _lastRotation = 0.0;
- (void)rotateImage:(UIRotationGestureRecognizer *)sender
{
    if([sender state] == UIGestureRecognizerStateEnded) {
        
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = -_lastRotation + [sender rotation];
    
    CGAffineTransform currentTransform = imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    [imageView setTransform:newTransform];
    
    _lastRotation = [sender rotation];
    
}

- (void)setImage:(UIImage *)image
{
    if (_image != image) {
        _image = [image copy];
    }
    
    float _imageScale = self.frame.size.width / image.size.width;
    self.imageView.frame = CGRectMake(0, 0, image.size.width*_imageScale, image.size.height*_imageScale);
    _originalImageViewSize = CGSizeMake(image.size.width*_imageScale, image.size.height*_imageScale);
    imageView.image = image;
    imageView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
}

- (void)finishCropping {
    float zoomScale = [[self.imageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
    float rotate = [[self.imageView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
    
    float _imageScale = _image.size.width/_originalImageViewSize.width;
    CGSize cropSize = CGSizeMake(self.frame.size.width/zoomScale, self.frame.size.height/zoomScale);
    CGPoint cropperViewOrigin = CGPointMake((0.0 - self.imageView.frame.origin.x)/zoomScale,
                                            (0.0 - self.imageView.frame.origin.y)/zoomScale);
    
    if((NSInteger)cropSize.width % 2 == 1)
    {
        cropSize.width = ceil(cropSize.width);
    }
    if((NSInteger)cropSize.height % 2 == 1)
    {
        cropSize.height = ceil(cropSize.height);
    }
    
    CGRect CropRectinImage = CGRectMake((NSInteger)(cropperViewOrigin.x*_imageScale) ,(NSInteger)( cropperViewOrigin.y*_imageScale), (NSInteger)(cropSize.width*_imageScale),(NSInteger)(cropSize.height*_imageScale));
    
    UIImage *rotInputImage = [self.image imageRotatedByRadians:rotate];
    CGImageRef tmp = CGImageCreateWithImageInRect([rotInputImage CGImage], CropRectinImage);
    self.croppedImage = [UIImage imageWithCGImage:tmp scale:self.image.scale orientation:self.image.imageOrientation];
    CGImageRelease(tmp);
}

- (void)reset
{
    self.imageView.transform = CGAffineTransformIdentity;
}



//- (void)dealloc {
//    self.image = nil;
//    self.croppedImage = nil;
//    self.imageView = nil;
//    
////    [super dealloc];
//}
//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    return self;
//}

@end
