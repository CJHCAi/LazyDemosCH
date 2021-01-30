//
//  UIColor+CHColor.m
//  CHVideoEditorDemo
//
//  Created by 火虎MacBook on 2020/7/8.
//  Copyright © 2020 Allen_Macbook Pro. All rights reserved.
//

#import "UIColor+CHColor.h"

#define DEFAULT_VOID_COLOR                    [UIColor blackColor]

@implementation UIColor (CHColor)


+ (CGFloat)getFrom:(CGFloat)value {
    return (value / 255.f);
}

+ (UIColor *)colorWithRealRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:[self getFrom:red] green:[self getFrom:green] blue:[self getFrom:blue] alpha:alpha];
}

- (UIColor *)colorWithRealRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:[UIColor getFrom:red] green:[UIColor getFrom:green] blue:[UIColor getFrom:blue] alpha:alpha];
}

/**随机颜色*/
+ (UIColor *)randomColor {
    CGFloat red =  (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

/**随机颜色 + 透明度*/
+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha {
    CGFloat red =  (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/**颜色 +HexStr +alpha*/
+ (UIColor *)colorWithHexString: (NSString *)hexStr alpha:(CGFloat)alpha {
    NSString *cString = [[hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    // strip # if it appears
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

/**颜色 + HexStr*/
+ (UIColor *)colorWithHexString: (NSString *)hexStr{
    UIColor * color = [self colorWithHexString:hexStr alpha:1];
    return color;
}

/**生成纯色图片 + color + size*/
+ (UIImage*)createImageWithColor:(UIColor*)color withRect:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**设置状态栏背景颜色*/
+(void)setNavStatusBarBgColor:(UIColor *)color{
    if (@available(iOS 13.0, *)) {
        UIView *statusBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame];
        statusBar.backgroundColor = color;;
        [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
    }else{
        //简单粗暴KVC获取到状态栏View
         UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
         if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]){
         //设置状态栏背景色
        statusBar.backgroundColor = color;
        }
    }
}

@end
