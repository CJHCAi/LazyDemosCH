//
//  UIColor+WJColor.h
//  LQZB
//
//  Created by 周文静 on 16/7/13.
//  Copyright © 2016年 lechuangshidai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WJColor)

///< 根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

///< 根据颜色、图片大小 生成图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

// 将十六进制颜色的字符串转化为复合iphone/ipad的颜色
// 字符串为"FFFFFF"
+ (UIColor *)wjColorFloat:(NSString *) hexColor;


@end
