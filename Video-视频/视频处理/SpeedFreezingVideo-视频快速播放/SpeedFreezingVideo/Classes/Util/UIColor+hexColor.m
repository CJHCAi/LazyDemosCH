//
//  UIColor+hexColor.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/24.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "UIColor+hexColor.h"

@implementation UIColor (hexColor)

+ (UIColor *)hexColor:(NSString *)hexColor{
    if ([hexColor length] < 6) {
        return nil;
    }
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}

@end
