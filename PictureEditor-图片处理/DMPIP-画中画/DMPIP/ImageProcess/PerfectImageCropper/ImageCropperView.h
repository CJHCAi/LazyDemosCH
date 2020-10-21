//
//  ImageCopperView.h
//  PerfectImageCropper
//
//  Created by Jin Huang on 11/22/12.
//
//

#import <UIKit/UIKit.h>

@protocol ImageCropperDelegate;

@interface ImageCropperView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *croppedImage;
@property(nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id <ImageCropperDelegate> delegate;

- (void)setup;
- (void)finishCropping;
- (void)reset;

- (void)moveImage:(UIPanGestureRecognizer *)sender;
- (void)scaleImage:(UIPinchGestureRecognizer *)sender;
- (void)rotateImage:(UIRotationGestureRecognizer *)sender;

@end

@protocol ImageCropperDelegate <NSObject>
- (void)imageCropper:(ImageCropperView *)cropper didFinishCroppingWithImage:(UIImage *)image;
@end