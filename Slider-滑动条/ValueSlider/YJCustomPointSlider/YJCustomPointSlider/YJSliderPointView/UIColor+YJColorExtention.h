//
//  UIColor+YJColorExtention.h
//  YJCustomPointSlider
//
//  Created by 于英杰 on 2019/5/15.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (YJColorExtention)
+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
