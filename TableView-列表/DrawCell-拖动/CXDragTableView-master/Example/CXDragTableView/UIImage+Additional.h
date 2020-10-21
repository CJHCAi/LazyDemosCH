//
//  UIImage+Additional.h
//  
//
//  Created by vernepung on 15/4/10.
//  Copyright (c) 2015年 vernepung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additional)

+ (UIImage *)imageWithColors:(NSArray<UIColor *>*)colors size:(CGSize)size;

+ (UIImage *)imageWithColors:(NSArray<UIColor *>*)colors
                        size:(CGSize)size leftToRight:(BOOL)leftToRight;

/**
 *  @brief 通过色值生成图片()
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;



/*
 *  extend stretchableImageWithLeftCapWidth:topCapHeight on ios5++
 *
 *  on ios4 make sure your capInsets's left as stretchableImageWithLeftCapWidth:topCapHeight 's width and capInsets'top as stretchableImageWithLeftCapWidth:topCapHeight 's height
 *  on ios5&ios5++ like call resizableImageWithCapInsets:
 */
- (UIImage *)resizableImageExtendWithCapInsets:(UIEdgeInsets)capInsets;


/*
 * Creates an image from the contents of a URL
 */
+ (UIImage*)imageWithContentsOfURL:(NSURL*)url;

/*
 * Scales the image to the given size
 */
- (UIImage*)scaleToSize:(CGSize)size;

/*
 *高斯模糊效果，渲染很费电，占内存，慎用。
 */
- (UIImage *)blurred;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

/**
 *  将某个视图渲染成一张图片
 */
+ (UIImage *)createImageFromView:(UIView *)view;
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin;


/**
 默认MainBundle的resource的文件
 
 @param name 文件名字（不用包含@2x,@3x)
 @return image
 */
+ (UIImage *)imageWithFileName:(NSString *)name;
+ (UIImage *)imageWithBundle:(NSBundle *)bundle fileName:(NSString *)name;
@end
