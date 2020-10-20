//
//  MMImageClipper.h
//  MMImageClipperDemo
//
//  Created by LEA on 2017/7/13.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  图片裁剪
//

#import <UIKit/UIKit.h>

// 点的宽度
#define k_POINT_WIDTH       30

@interface MMImageClipper : UIView

// 点的颜色
@property (nonatomic, strong) UIColor *pointColor;
// 边线颜色
@property (nonatomic, strong) UIColor *sideLineColor;
// 填充颜色
@property (nonatomic, strong) UIColor *fillColor;
// 可拖动点的个数
@property (nonatomic, assign) NSInteger pointNumber;
// 视图偏移量
@property (nonatomic, assign) CGFloat margin;

// 裁剪后的图片
- (UIImage *)getClippedImage:(UIImageView *)imageView;
// 等比处理
+ (CGSize)scaleAspectFromSize:(CGSize)fromSize toSize:(CGSize)toSize;

@end
