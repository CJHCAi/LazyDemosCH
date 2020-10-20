//
//  UIColor+hex.m
//  DemoMoment
//
//  Created by hs on 2018/6/11.
//  Copyright © 2018年 shj. All rights reserved.
//

#import "UIColor+hex.h"

@implementation UIColor (hex)

+ (UIColor *)colorWithHex:(NSUInteger)hex {
    CGFloat red, green, blue, alpha;
    red = ((CGFloat)((hex >> 16) & 0xFF)) / ((CGFloat)0xFF);
    green = ((CGFloat)((hex >> 8) & 0xFF)) / ((CGFloat)0xFF);
    blue = ((CGFloat)((hex >> 0) & 0xFF)) / ((CGFloat)0xFF);
    alpha = hex > 0xFFFFFF ? ((CGFloat)((hex >> 24) & 0xFF)) / ((CGFloat)0xFF) : 1;
    return [UIColor colorWithRed: red green:green blue:blue alpha:alpha];
}

+ (UIColor *)ss_blackColor {
    return [UIColor colorWithHex:0x333333];
}

+ (UIColor *)ss_blueColor {
    return [UIColor colorWithHex:0x43a9f1];
}

+ (UIColor *)ss_blueLightColor {
    return [UIColor colorWithHex:0x49b2f5];
}

+ (UIColor *)ss_redColor {
    return [UIColor colorWithHex:0xff5648];
}

+ (UIColor *)ss_greenColor {
    return [UIColor colorWithHex:0x47b34f];
}

+ (UIColor *)ss_orangeColor {
    return [UIColor colorWithHex:0xffaf32];
}



@end
