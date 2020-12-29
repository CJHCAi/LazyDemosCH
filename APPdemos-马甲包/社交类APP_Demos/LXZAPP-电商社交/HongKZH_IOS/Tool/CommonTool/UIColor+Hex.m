//
//  UIColor+Hex.m
//  SnailProject
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 Snail Partnership. All rights reserved.
//

#import "UIColor+Hex.h"
#import <UIKit/UIKit.h>
@implementation UIColor (Hex)

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    
    if ([[hexString substringToIndex:1] isEqualToString:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    
    unsigned rgbValue = 0;  
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                           alpha:1.0];
}
+ (UIImage *)imageWithString:(NSString *)colorString size:(CGSize)size
{
    UIColor *color = [self colorFromHexString:colorString];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr{ // CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer]; gradientLayer.frame = view.bounds;
    // 创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHex:fromHexColorStr].CGColor,(__bridge id)[UIColor colorWithHex:toHexColorStr].CGColor];
    // 设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0); gradientLayer.endPoint = CGPointMake(0, 1);
    // 设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    return gradientLayer;
    
} //获取16进制颜色的方法
+ (UIColor *)colorWithHex:(NSString *)hexColor {
    hexColor = [hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([hexColor length] < 6) {
        return nil;
        
    }
    if ([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
        
    }
    NSRange range;
    range.length = 2;
    range.location = 0;
    NSString *rs = [hexColor substringWithRange:range];
    range.location = 2;
    NSString *gs = [hexColor substringWithRange:range]; range.location = 4;
    NSString *bs = [hexColor substringWithRange:range];
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rs] scanHexInt:&r];
    [[NSScanner scannerWithString:gs] scanHexInt:&g];
    [[NSScanner scannerWithString:bs] scanHexInt:&b];
    if ([hexColor length] == 8) {
        range.location = 4;
        NSString *as = [hexColor substringWithRange:range];
        [[NSScanner scannerWithString:as] scanHexInt:&a];
        
    } else {
        a = 255;
        
    }
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:((float)a / 255.0f)];
    
}

@end
