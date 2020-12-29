//
//  UIColor+Hex.h
//  SnailProject
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 Snail Partnership. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface UIColor (Hex)
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIImage *)imageWithString:(NSString *)colorString size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
