//
//  SDCutFunctionViewController.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/24.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDDiyBaseFunctionViewController.h"
#import "TOCropView.h"

#import "SDCutFunctionModel.h"


@interface SDCutFunctionViewController : SDDiyBaseFunctionViewController

/**
 The original, uncropped image that was passed to this controller.
 */
@property (nonnull, nonatomic, readonly) UIImage *image;


/**
 If true, when the user hits 'Done', a UIActivityController will appear
 before the view controller ends.
 */
@property (nonatomic, assign) BOOL showActivitySheetOnDone;

/**
 The crop view managed by this view controller.
 */
@property (nonnull, nonatomic, strong, readonly) TOCropView *cropView;

/**
 In the coordinate space of the image itself, the region that is currently
 being highlighted by the crop box.
 
 This property can be set before the controller is presented to have
 the image 'restored' to a previous cropping layout.
 */
@property (nonatomic, assign) CGRect imageCropFrame;

/**
 The angle in which the image is rotated in the crop view.
 This can only be in 90 degree increments (eg, 0, 90, 180, 270).
 
 This property can be set before the controller is presented to have
 the image 'restored' to a previous cropping layout.
 */
@property (nonatomic, assign) NSInteger angle;


/**
 A CGSize value representing a custom aspect ratio, not listed in the presets.
 E.g. A ratio of 4:3 would be represented as (CGSize){4.0f, 3.0f}
 */
@property (nonatomic, assign) CGSize customAspectRatio;

/**
 If true, while it can still be resized, the crop box will be locked to its current aspect ratio.
 
 If this is set to YES, and `resetAspectRatioEnabled` is set to NO, then the aspect ratio
 button will automatically be hidden from the toolbar.
 
 Default is NO.
 */
@property (nonatomic, assign) BOOL aspectRatioLockEnabled;

/**
 If true, tapping the reset button will also reset the aspect ratio back to the image
 default ratio. Otherwise, the reset will just zoom out to the current aspect ratio.
 
 If this is set to NO, and `aspectRatioLockEnabled` is set to YES, then the aspect ratio
 button will automatically be hidden from the toolbar.
 
 Default is YES
 */
@property (nonatomic, assign) BOOL resetAspectRatioEnabled;


/**
 When disabled, an additional rotation button that rotates the canvas in
 90-degree segments in a clockwise direction is shown in the toolbar.
 
 Default is YES.
 */
@property (nonatomic, assign) BOOL rotateClockwiseButtonHidden;

/**
 When enabled, hides the rotation button, as well as the alternative rotation
 button visible when `showClockwiseRotationButton` is set to YES.
 
 Default is NO.
 */
@property (nonatomic, assign) BOOL rotateButtonsHidden;

/**
 When enabled, hides the 'Aspect Ratio Picker' button on the toolbar.
 
 Default is NO.
 */
@property (nonatomic, assign) BOOL aspectRatioPickerButtonHidden;

/**
 If `showActivitySheetOnDone` is true, then these activity items will
 be supplied to that UIActivityViewController in addition to the
 `TOActivityCroppedImageProvider` object.
 */
@property (nullable, nonatomic, strong) NSArray *activityItems;

/**
 If `showActivitySheetOnDone` is true, then you may specify any
 custom activities your app implements in this array. If your activity requires
 access to the cropping information, it can be accessed in the supplied
 `TOActivityCroppedImageProvider` object
 */
@property (nullable, nonatomic, strong) NSArray *applicationActivities;

/**
 If `showActivitySheetOnDone` is true, then you may expliclty
 set activities that won't appear in the share sheet here.
 */
@property (nullable, nonatomic, strong) NSArray *excludedActivityTypes;

/**
 A choice from one of the pre-defined aspect ratio presets
 */
@property (nonatomic, assign) SDCutFunctionType aspectRatioPreset;

@end
