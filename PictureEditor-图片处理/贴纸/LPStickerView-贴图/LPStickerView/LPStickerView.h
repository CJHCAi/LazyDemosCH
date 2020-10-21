//
//  LPStickerView.h
//  LPStickerView
//
//  Created by 罗平 on 2017/6/14.
//  Copyright © 2017年 罗平. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const LPStickerInfoCentreXName;
UIKIT_EXTERN NSString * const LPStickerInfoCentreYName;
UIKIT_EXTERN NSString * const LPStickerInfoScaleName;
UIKIT_EXTERN NSString * const LPStickerInfoAngleName; //0 ~ 360

@interface LPStickerView : UIView

@property (nonatomic, copy) void(^deleteBlock)();
@property (nonatomic, copy) void(^stickerInfoChangeBlock)(NSDictionary *stickerInfoDict);

@property (nonatomic, assign) BOOL lp_isTransfromResponse; // default NO

@property (nonatomic, weak, readonly) UIView *lp_contentView;
@property (nonatomic, strong) UIColor *lp_borderColor; //default redColor

@property (nonatomic, assign) CGFloat lp_maxScaleRadio; // default 3.0
@property (nonatomic, assign) CGFloat lp_minScaleRadio; // default 0.5

@property (nonatomic, strong) UIImage *lp_deleteImage;
@property (nonatomic, strong) UIImage *lp_transfromImage;

@end
