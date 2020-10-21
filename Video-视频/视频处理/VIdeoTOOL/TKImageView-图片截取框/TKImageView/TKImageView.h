//
//  TKImageView.h
//  TKImageDemo
//
//  Created by yinyu on 16/7/10.
//  Copyright © 2016年 yinyu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TKCropAreaCornerStyle) {
    TKCropAreaCornerStyleRightAngle,
    TKCropAreaCornerStyleCircle
};
@interface TKImageView : UIView
/**裁剪的图片*/
@property (strong, nonatomic) UIImage * toCropImage;
/**<#name#>*/
@property (assign, nonatomic) BOOL needScaleCrop;
@property (assign, nonatomic) BOOL showMidLines;
@property (assign, nonatomic) BOOL showCrossLines;
/**裁剪的宽高比*/
@property (assign, nonatomic) CGFloat cropAspectRatio;
/**裁剪区 边框线 颜色 宽*/
@property (strong, nonatomic) UIColor *cropAreaBorderLineColor;
@property (assign, nonatomic) CGFloat cropAreaBorderLineWidth;
/**裁剪区 边角线 颜色 线宽 */
@property (strong, nonatomic) UIColor *cropAreaCornerLineColor;
@property (assign, nonatomic) CGFloat cropAreaCornerLineWidth;
@property (assign, nonatomic) CGFloat cropAreaCornerWidth;
@property (assign, nonatomic) CGFloat cropAreaCornerHeight;

/**最小间距*/
@property (assign, nonatomic) CGFloat minSpace;
/**交叉线 线宽和颜色*/
@property (assign, nonatomic) CGFloat cropAreaCrossLineWidth;
@property (strong, nonatomic) UIColor *cropAreaCrossLineColor;

/**中线宽 高 颜色*/
@property (assign, nonatomic) CGFloat cropAreaMidLineWidth;
@property (assign, nonatomic) CGFloat cropAreaMidLineHeight;
@property (strong, nonatomic) UIColor *cropAreaMidLineColor;
/**蒙版颜色*/
@property (strong, nonatomic) UIColor *maskColor;
/**边框是否在图片内*/
@property (assign, nonatomic) BOOL cornerBorderInImage;
@property (assign, nonatomic) CGFloat initialScaleFactor;
- (UIImage *)currentCroppedImage;
@end
