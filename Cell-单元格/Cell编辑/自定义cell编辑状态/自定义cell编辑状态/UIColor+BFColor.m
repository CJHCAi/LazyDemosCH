//
//  UIColor+BFColor.m
//  codePackage
//
//  Created by 周冰烽 on 2017/7/5.
//  Copyright © 2017年 周冰烽. All rights reserved.
//

#import "UIColor+BFColor.h"

@implementation UIColor (BFColor)

+(instancetype)BF_RandomColor{
    return [UIColor BF_Red:arc4random_uniform(256) Green:arc4random_uniform(256) Blue:arc4random_uniform(256) Alpha:1.0];
}

+(instancetype)BF_Red:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

+(instancetype)BF_ColorWithHex:(uint32_t)hex{
    uint8_t r = (hex & 0xff0000) >> 16;
    uint8_t g = (hex & 0x00ff00) >> 8;
    uint8_t b = hex & 0x0000ff;
    return [self BF_Red:r Green:g Blue:b Alpha:1.0];
}

@end
