//
//  NPQRCodeManager.m
//  NinePoint
//
//  Created by JXH on 2017/8/7.
//  Copyright © 2017年 JXH. All rights reserved.
//

#import "NPQRCodeManager.h"


@implementation NPQRCodeManager

/** 生成带颜色的二维码并且带logo*/
+ (UIImage *)createQRCode:(NSString *)qrString withColor:(UIColor *)color andLogoImageView:(UIImage *)logoImage {
    
    UIImage *resultImage = nil;
   
    resultImage = [self createQRCode:qrString withColor:color];

    if (logoImage) {
       
        resultImage =  [self addLogoImage:resultImage withLogoImage:logoImage ofTheSize:resultImage.size];
    }
    
    return resultImage;
}


#pragma mark - 生成二维码

+ (UIImage *)createQRCode:(NSString *)qrString {
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSString *string = qrString;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];

    return [self createNonInterpolatedUIImageFormCIImage:image withSize:300];
    
    
}
+ (UIImage *)createQRCode:(NSString *)qrString withColor:(UIColor *)color {
    
    
    UIImage *resultQRImage = nil;
    resultQRImage =  [self createQRCode:qrString];

    if (color) {
        CGFloat R, G, B = 0.0;
        UIColor *uiColor = color;
        CGColorRef cgColor = [uiColor CGColor];
        
        NSUInteger numComponents = CGColorGetNumberOfComponents(cgColor);
        
        if (numComponents == 4)
        {
            const CGFloat *components = CGColorGetComponents(cgColor);
            R = components[0];
            G = components[1];
            B = components[2];
        }
        resultQRImage = [self imageBlackToTransparent:resultQRImage withRed:R*255 andGreen:G*255 andBlue:B*255];
       
    }
    
    return resultQRImage;
}
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
+ (UIImage *)changeQRCodeImage:(UIImage *)image withColor:(UIColor *)color {
    
    if (color) {
        
            CGFloat R, G, B = 0.0;
            UIColor *uiColor = color;
            CGColorRef cgColor = [uiColor CGColor];
            
            NSUInteger numComponents = CGColorGetNumberOfComponents(cgColor);
            
            if (numComponents == 4)
            {
                const CGFloat *components = CGColorGetComponents(cgColor);
                R = components[0];
                G = components[1];
                B = components[2];
            }
        
           return [self imageBlackToTransparent:image withRed:R*255 andGreen:G*255 andBlue:B*255];

    }else{
        
        return image;
    }
    
}
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}
/** 按比例放缩*/
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
//压缩图片
+(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage =UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

#pragma mark - Logo图片的处理
/**
 *  二维码添加头像
 *
 *  @param bgImage     背景（二维码）
 *  @param logoImage  logo
 *  @param size        绘制区域大小
 *
 *  @return newImage
 */

+ (UIImage *)addLogoImage:(UIImage *)bgImage withLogoImage:(UIImage *)LogoImage ofTheSize:(CGSize)size;
{
    if (LogoImage == nil) {
        return bgImage;
    }
    BOOL opaque = 0;
    
    //确定尺寸
    if (!size.width) {
        
        size = bgImage.size;
    }
    
    // 获取当前设备的scale
    CGFloat scale = [UIScreen mainScreen].scale;
    // 创建画布Rect
    CGRect bgRect = CGRectMake(0, 0, size.width, size.height);
    // 头像大小 _不能大于_ 画布的1/4 （这个大小之内的不会遮挡二维码的有效信息）
    CGFloat avatarWidth = LogoImage.size.width < (size.width/4.0)? LogoImage.size.width:(size.width/4.0);
    CGFloat avatarHeight = avatarWidth;
    if (LogoImage.size.width >avatarWidth) {
    
        CGSize newSize = CGSizeMake(avatarWidth, avatarHeight);
        /** 会导致模糊*/
       LogoImage = [self imageWithImageSimple:LogoImage scaledToSize:newSize];
        
    }
    // 设置头像的位置信息
    CGPoint position = CGPointMake(size.width/2.0, size.height/2.0);
    CGRect avatarRect = CGRectMake(position.x-(avatarWidth/2.0), position.y-(avatarHeight/2.0), avatarWidth, avatarHeight);
    
    // 设置画布信息
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);{// 开启画布
        // 翻转context （画布）
        CGContextTranslateCTM(context, 0, size.height);
        CGContextScaleCTM(context, 1, -1);
        
        
        UIColor *fillColor = [UIColor whiteColor];//[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextFillPath(context);
        
        // 根据 bgRect 用二维码填充视图
        CGContextDrawImage(context, bgRect, bgImage.CGImage);
        //  根据newLogoImage 填充头像区域
        CGContextDrawImage(context, avatarRect, LogoImage.CGImage);
        
    }CGContextRestoreGState(context);// 提交画布
    // 从画布中提取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 释放画布
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)clipCornerRadius:(UIImage *)image withSize:(CGSize) size cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)borderColor;
{
        // 白色border的宽度
        CGFloat outerWidth = borderWidth >0 ? borderWidth : size.width/15.0;
        // 黑色border的宽度
        CGFloat innerWidth = 1;
        // 圆角这个就是我觉着的适合的一个值 ，可以自行改
        CGFloat corenerRadius = radius > 0 ? radius: size.width/5.0;
        // 为context创建一个区域
        CGRect areaRect = CGRectMake(0, 0, size.width, size.height);
        UIBezierPath *areaPath = [UIBezierPath bezierPathWithRoundedRect:areaRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corenerRadius, corenerRadius)];
    
        // 因为UIBezierpath划线是双向扩展的 初始位置就不会是（0，0）
        // origin position
        CGFloat outerOrigin = outerWidth/2.0;
        CGFloat innerOrigin = innerWidth/2.0 + outerOrigin/1.2;
        CGRect outerRect = CGRectInset(areaRect, outerOrigin, outerOrigin);
        CGRect innerRect = CGRectInset(outerRect, innerOrigin, innerOrigin);
        //  外层path
        UIBezierPath *outerPath = [UIBezierPath bezierPathWithRoundedRect:outerRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
        //  内层path
        UIBezierPath *innerPath = [UIBezierPath bezierPathWithRoundedRect:innerRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
        // 创建上下文
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);{
            // 翻转context
            CGContextTranslateCTM(context, 0, size.height);
            CGContextScaleCTM(context, 1, -1);
            // context  添加 区域path -> 进行裁切画布
            CGContextAddPath(context, areaPath.CGPath);
            CGContextClip(context);
            // context 添加 背景颜色，避免透明背景会展示后面的二维码不美观的。（当然也可以对想遮住的区域进行clear操作，但是我当时写的时候还没有想到）
          
            CGContextAddPath(context, outerPath.CGPath);
            UIColor *fillColor = [UIColor whiteColor];//[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
            CGContextSetFillColorWithColor(context, fillColor.CGColor);
            CGContextFillPath(context);

            // context 执行画头像
            CGContextDrawImage(context, innerRect, image.CGImage);
            // context 添加白色的边框 -> 执行填充白色画笔
            CGContextAddPath(context, outerPath.CGPath);
            CGContextSetStrokeColorWithColor(context, fillColor.CGColor/*[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor*/);
            CGContextSetLineWidth(context, outerWidth);
            CGContextStrokePath(context);
            
            
            // context 添加黑色的边界假象边框 -> 执行填充黑色画笔
            CGContextAddPath(context, innerPath.CGPath);
            CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetLineWidth(context, innerWidth);
            CGContextStrokePath(context);
    
        }CGContextRestoreGState(context);
        UIImage *radiusImage  = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return radiusImage;
}

+ (UIImage*)image:(UIImage*)image addToImage:(UIImage*)bigImage{
    
    CGFloat w = bigImage.size.width;
    
    CGFloat h = bigImage.size.height;
    
    //bitmap上下文使用的颜色空间
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //绘制图形上下文
    
    CGContextRef ref =CGBitmapContextCreate(NULL, w, h,8,444* bigImage.size.width, colorSpace,kCGImageAlphaPremultipliedFirst);
    
    //给bigImage画图
    
    CGContextDrawImage(ref,CGRectMake(0,0, w, h), bigImage.CGImage);
    
    CGContextDrawImage(ref,CGRectMake((w-image.size.width) * 0.5,(h - image.size.height) * 0.5, image.size.width, image.size.height), image.CGImage);
    
    //合成图片
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(ref);
    
    //关闭图形上下文
    
    CGContextClosePath(ref);
    
    CGColorSpaceRelease(colorSpace);
    
    return [UIImage imageWithCGImage:imageMasked];
    
}


@end
