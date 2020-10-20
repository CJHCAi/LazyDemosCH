//
//  UIColor+LSLColor.h
//  BubbleButton
//
//  Created by lisonglin on 15/05/2017.
//  Copyright © 2017 lisonglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LSLColor)

/**
 使用十六进制设置颜色
 */
+ (UIColor *)colorWithLSLString: (NSString *)color;


/**
 利用16进制获取颜色

 @param color color
 @param alpha alpha
 @return color  
 */
+ (UIColor *)colorWithLSLString: (NSString *)color alpha:(CGFloat)alpha;

@end
