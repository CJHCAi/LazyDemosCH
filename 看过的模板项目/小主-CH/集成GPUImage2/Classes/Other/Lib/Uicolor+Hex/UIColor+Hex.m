//
//  UIColor+Hex.m
//  MIT_itrade
//
//  Created by Mega on 14-4-8.
//  Copyright (c) 2014年 ___ZhengDaXinXi___. All rights reserved.
//

#import "UIColor+Hex.h"
#define WHITE_HEX_COLOR @"c1c1c1"
#define RED_HEX_COLOR @"#ff4746"
#define YELLOW_HEX_COLOR @"ffff00"
#define GREEN_HEX_COLOR @"77d850"
#define SELECT_HEX_COLOR @"0f2439"
#define DEFAULT_VOID_COLOR [UIColor whiteColor]

@implementation UIColor (Hex)

+ (UIColor *)colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)colorWithSETPRICE:(NSString *)SETPRICE price:(NSString*)PRICE
{
    UIColor *color = [UIColor colorWithHexString:WHITE_HEX_COLOR];
    UIColor *red = [UIColor colorWithHexString:RED_HEX_COLOR];
    UIColor *green = [UIColor colorWithHexString:GREEN_HEX_COLOR];
    
    if ([PRICE isEqual:@"--"]||[PRICE isEqual:@"0"]) {
        return color;
    }
    
    if (PRICE.floatValue > SETPRICE.floatValue) {
        color = red;
    }
    else if (PRICE.floatValue < SETPRICE.floatValue)
    {
        color = green;
    }
    return color;
}

+ (UIColor *)colorWithRAISELOSE:(NSString *)RAISELOSE
{
    UIColor *color = [UIColor colorWithHexString:WHITE_HEX_COLOR];
    UIColor *red = [UIColor colorWithHexString:RED_HEX_COLOR];
    UIColor *green = [UIColor colorWithHexString:GREEN_HEX_COLOR];
    
    if ([RAISELOSE isEqual:@"--"]||[RAISELOSE isEqual:@"0"]) {
        return color;
    }
    if (RAISELOSE.floatValue > 0) {
        color = red;
    }
    else if (RAISELOSE.floatValue < 0)
    {
        color = green;
    }
    return color;
}

@end
