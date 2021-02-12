//
//  UIColor+CHColor.h
//  CHVideoEditorDemo
//
//  Created by 火虎MacBook on 2020/7/8.
//  Copyright © 2020 Allen_Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CHColor)

+ (UIColor *)colorWithRealRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

 - (UIColor *)colorWithRealRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/**随机颜色*/
 + (UIColor *)randomColor;
/**随机颜色 + 透明度*/
 + (UIColor *)randomColorWithAlpha:(CGFloat)alpha;
/**颜色 + HexStr*/
 + (UIColor *)colorWithHexString:(NSString *)hexStr;
/**颜色 +HexStr +alpha*/
 + (UIColor *)colorWithHexString: (NSString *)hexStr alpha:(CGFloat)alpha;
/**生成纯色图片 + color + size*/
 + (UIImage*)createImageWithColor:(UIColor *)color withRect:(CGRect)rect;

/**设置状态栏背景颜色*/
+(void)setNavStatusBarBgColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
