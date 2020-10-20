//
//  UIImage+ZJExtension.h
//  WeiboDemo
//
//  Created by Zj on 16/9/13.
//  Copyright © 2016年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZJExtension)

/**
 从图片中间拉伸
 
 @param imgName 图片名
 
 @return 拉伸后的图片
 */
+ (UIImage *)resizedImageNamed:(NSString *)imgName;

/**
 设置图片永不渲染
 
 @param imgName 图片名
 
 @return 原图并永不会被渲染
 */
+ (UIImage *)renderingModeOriginalImageNamed:(NSString *)imgName;

/**
 设置图片永远渲染

 @param imgName 图片名
 @return 原图永远跟随tintColor显然 IOS9之前渲染颜色为0.8倍颜色RGB值
 */
+ (UIImage *)renderingModeAlwaysTemplateImageNamed:(NSString *)imgName;

/**
 绘制纯色图片
 
 @param color 图片颜色

 @return 生成的纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 生成纯色制定大小图片

 @param color 图片颜色
 @param size 图片尺寸
 @return 生成的图
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 调整图像大小

 @param size 最大尺寸
 @param kilobyte 最大kb
 @return 调整后图片
 */
- (UIImage *)resizeImageWithSize:(CGSize)size kilobyte:(CGFloat)kilobyte;

/**
 调整图像的size

 @param size 尺寸
 @return 调整后的图片
 */
- (UIImage *)resizeTo:(CGSize)size;

/**
 生成圆角图片

 @param radius 图片圆角半径
 @return 生成的圆角图片
 */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

/**
 剪切原图片为圆形
 
 @return 原型图片
 */
- (UIImage *)cycleImage;

@end
