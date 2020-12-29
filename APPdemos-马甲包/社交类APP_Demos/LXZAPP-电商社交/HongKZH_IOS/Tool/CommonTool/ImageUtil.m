//
//  ImageUtil.m
//  YiXiu
//
//  Created by QinGuoLi on 16/4/5.
//  Copyright © 2016年 Liqg. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil

+ (UIImage *)compress:(UIImage *)image newWidth:(int)newWidth
{
    int oldWidth = image.size.width;
    int oldHeight = image.size.height;
    if (oldWidth <= newWidth) {
        return image;
    }
    int newHeight =  newWidth  * oldHeight / oldWidth;
    return [self drawInRect:image width:newWidth height:newHeight];
}

+ (UIImage *)drawInRect:(UIImage *)image width:(int)width height:(int)height
{
    CGRect rect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //    CGImageRelease(image.CGImage);
    return newImage;
}

+ (UIImage *)compress:(UIImage *)image newWidth:(int)newWidth newHeight:(int)newHeight
{
    int oldWidth = image.size.width;
    int oldHeight = image.size.height;
    if (oldWidth <= newWidth && oldHeight <= newHeight) {
        return image;
    }
    CGFloat oldRate = oldHeight * 1.0 / oldWidth;
    CGFloat minRate = 1.0 / 3;
    if (oldRate <= 3 && oldRate >= minRate) {
        if (oldWidth > newWidth) {
            newHeight = newWidth * oldHeight / oldWidth;
        } else if (oldHeight > newHeight) {
            newWidth = newHeight * oldWidth / oldHeight;
        }
        return [self drawInRect:image width:newWidth height:newHeight];
    } else {
        int cutWidth = newWidth;
        int cutHeight = newHeight;
        UIImage *newImage = nil;
        if (oldRate > 3) {
            if (oldWidth > newWidth / 3) {
                newWidth = newWidth / 3;
                newHeight = newWidth * oldHeight / oldWidth;
                cutWidth = newWidth;
                newImage = [self drawInRect:image width:newWidth height:newHeight];
            } else {
                cutWidth = oldWidth;
                newImage = image;
            }
        } else if (oldRate < minRate) {
            if (oldHeight > newHeight / 3) {
                newHeight = newHeight / 3;
                newWidth = newHeight * oldWidth / oldHeight;
                cutHeight = newHeight;
                newImage = [self drawInRect:image width:newWidth height:newHeight];
            } else {
                cutHeight = oldHeight;
                newImage = image;
            }
        }
        CGImageRef imageRef = CGImageCreateWithImageInRect(newImage.CGImage, CGRectMake(0, 0, cutWidth, cutHeight));
        newImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        return newImage;
    }
}

+ (UIImage *)cutImage:(UIImage *)image width:(int)width
{
    int oldWidth = image.size.width;
    int oldHeight = image.size.height;
    if (oldWidth == width && oldHeight == width) {
        return image;
    }
    int newWidth = width;
    int newHeight = width;
    if (oldWidth > oldHeight) {
        newWidth = newHeight * oldWidth / oldHeight;
    } else if (oldWidth < oldHeight) {
        newHeight = newWidth * oldHeight / oldWidth;
    }
    UIImage *newImage = [self drawInRect:image width:newWidth height:newHeight];
    int x = 0;
    int y = 0;
    if (newWidth > newHeight) {
        x = (newWidth - width) / 2;
    } else if (newWidth < newHeight) {
        y = (newHeight - width) / 2;
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect(newImage.CGImage, CGRectMake(x, y, width, width));
    newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return newImage;
}

+ (UIImage *)cutImage:(UIImage *)image withScale:(float)scale;
{
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    if (oldHeight/oldWidth == scale) {
        return image;
    }
    float x=0;
    float y=0;
    CGFloat newWidth = oldWidth;
    CGFloat newHeight =oldHeight;
    if(oldHeight/oldWidth > scale){ //高太长，截取高
        newHeight = newWidth*scale;
        y =(oldHeight-newHeight)/2;
    }else if (oldHeight/oldWidth < scale){//宽太长，截取宽
        newWidth =newHeight/scale;
        x=(oldWidth-newWidth)/2;
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(x, y, newWidth, newHeight));
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return newImage;
}

+ (UIImage *)fixImageOrientation:(UIImage *)image
{
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp)
        return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
+ (NSData *)compressImageQuality:(UIImage *)image
{
    CGFloat compression = 0.7;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while (imageData.length > IMAGE_MAX_SIZE && compression > 0.1) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return imageData;
}


@end
