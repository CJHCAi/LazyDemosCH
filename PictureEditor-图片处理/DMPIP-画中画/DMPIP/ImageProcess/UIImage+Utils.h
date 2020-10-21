//
//  UIImage+Utils.h
//  LuoChang
//
//  Created by Rick on 15/4/22.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)
+(UIImage *) stretchImageWithName:(NSString *) imageName;

+(UIImage *) stretchImageWithName:(NSString *) imageName widthScale:(CGFloat)widthScale heightScale:(CGFloat)heightScale;

/**
 *  根据颜色创建一张1*1的图片
 *
 *  @param colour 颜色
 *
 *  @return 创建好的图片
 */
+(UIImage *) imageWithColor:(UIColor *)colour;

/**
 *  指定宽度按比例缩放
 *
 *  @param sourceImage <#sourceImage description#>
 *  @param defineWidth <#defineWidth description#>
 *
 *  @return <#return value description#>
 */
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

/**
 *  图片滤镜处理
 *
 *  @param image      图片
 *  @param filterName 滤镜名称
 *
 *  @return 处理好的图片
 */
+(UIImage *)filteredImage:(UIImage *)image withFilterName:(NSString *)filterName;

- (UIImage*)resize:(CGSize)size;
- (UIImage*)aspectFit:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size offset:(CGFloat)offset;


+ (UIImage*)imageByApplyingLightEffectToImage:(UIImage*)inputImage;
+ (UIImage*)imageByApplyingExtraLightEffectToImage:(UIImage*)inputImage;
+ (UIImage*)imageByApplyingDarkEffectToImage:(UIImage*)inputImage;
+ (UIImage*)imageByApplyingTintEffectWithColor:(UIColor *)tintColor toImage:(UIImage*)inputImage;

//| ----------------------------------------------------------------------------
//! Applies a blur, tint color, and saturation adjustment to @a inputImage,
//! optionally within the area specified by @a maskImage.
//!
//! @param  inputImage
//!         The source image.  A modified copy of this image will be returned.
//! @param  blurRadius
//!         The radius of the blur in points.
//! @param  tintColor
//!         An optional UIColor object that is uniformly blended with the
//!         result of the blur and saturation operations.  The alpha channel
//!         of this color determines how strong the tint is.
//! @param  saturationDeltaFactor
//!         A value of 1.0 produces no change in the resulting image.  Values
//!         less than 1.0 will desaturation the resulting image while values
//!         greater than 1.0 will have the opposite effect.
//! @param  maskImage
//!         If specified, @a inputImage is only modified in the area(s) defined
//!         by this mask.  This must be an image mask or it must meet the
//!         requirements of the mask parameter of CGContextClipToMask.
+ (UIImage*)imageByApplyingBlurToImage:(UIImage*)inputImage withRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end
