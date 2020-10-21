//
//  WMZTool.h
//  WMZTags
//
//  Created by wmz on 2019/5/27.
//  Copyright © 2019年 wmz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMZTool : NSObject
//文字转图片
+ (UIImage *)imageWithString:(NSString *)string
                        font:(UIFont *)font
                       width:(CGFloat)width
               textAlignment:(NSTextAlignment)textAlignment
                   backColor:(UIColor*)backGroundcolor
                       color:(UIColor*)color;

//获取当前VC
+ (UIViewController *)getCurrentVC;

//16进制颜色
+ (UIColor *)stringTOColor:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
