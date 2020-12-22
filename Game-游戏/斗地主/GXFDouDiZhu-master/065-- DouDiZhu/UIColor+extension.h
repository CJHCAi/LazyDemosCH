//
//  UIColor+extension.h
//  061-- GXFApplication
//
//  Created by 顾雪飞 on 17/4/17.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (extension)

+ (UIColor *)randomColor;

+ (UIColor *)colorWithHex:(uint32_t)hex;

+ (UIColor *)colorWithHex:(uint32_t)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

- (NSString *)HEXString;

@end
