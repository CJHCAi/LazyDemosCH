//
//  NPQRCodeManager.h
//  NinePoint
//
//  Created by JXH on 2017/8/7.
//  Copyright © 2017年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NPQRCodeManager : NSObject

#pragma mark - 生成二维码
/** 默认生成黑色的二维码*/
+ (UIImage *)createQRCode:(NSString *)qrString;
/** 生成带颜色的二维码*/
+ (UIImage *)createQRCode:(NSString *)qrString withColor:(UIColor *)color;
/** 生成带颜色的二维码并且带logo*/
+ (UIImage *)createQRCode:(NSString *)qrString withColor:(UIColor *)color andLogoImageView:(UIImage *)logoImage;


#pragma mark - 已经有二维码：改色、加logo
/** 修改二维码的颜色*/
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;
+ (UIImage *)changeQRCodeImage:(UIImage *)image withColor:(UIColor *)color;
/** 二维码添加Logo*/
+ (UIImage *)addLogoImage:(UIImage *)bgImage withLogoImage:(UIImage *)LogoImage ofTheSize:(CGSize)size;

#pragma mark - Logo处理
/** 处理Logo，加边框:不要超过可现实区域的 1/4*/
+ (UIImage *)clipCornerRadius:(UIImage *)image withSize:(CGSize) size cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)borderColor;

/** 给图片加图片：其实可以用来加logo*/
+ (UIImage*)image:(UIImage*)image addToImage:(UIImage*)bigImage;


@end
