//
//  VPImageCropperViewController.h
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VPImageCropperViewController;

@protocol VPImageCropperDelegate <NSObject>

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController;

@end

@interface VPImageCropperViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<VPImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;
@property (nonatomic, strong) NSString *confirmTitle;
@property (nonatomic, strong) NSString *cancelTitle;
@property (nonatomic, strong) UIColor *btnBgColor;
@property (nonatomic, strong) UIFont *cancelBtnFont;
@property (nonatomic, strong) UIFont *confirmBtnFont;

/** Color of the crop rectangle (defaults to yellow if not specified) */
@property (nonatomic, strong) UIColor *cropRectColor;

/** If YES, then the image will be sized to initally aspect fill the dimensions of the controller's view */
@property (nonatomic, assign) BOOL shouldInitiallyAspectFillImage;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
