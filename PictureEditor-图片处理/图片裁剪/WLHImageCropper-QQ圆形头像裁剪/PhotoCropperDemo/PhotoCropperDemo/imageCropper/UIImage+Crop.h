//
//  UIImage+Crop.h
//  incup
//
//  Created by wanglh on 15/5/21.
//  Copyright (c) 2015年 Kule Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
//屏幕宽和高
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

@interface UIImage (Crop)
/*
 * 改变图片size
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
/**
 * 将image适配屏幕
 */
+(UIImage *)fitScreenWithImage:(UIImage *)image;
/*
 * 裁剪图片
 */
- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
@end
