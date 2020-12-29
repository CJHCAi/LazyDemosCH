//
//  UIImage+Utility.m
//  H850Samba
//
//  Created by zhengying on 3/25/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "UIImage+Utility.h"

@implementation UIImage (Utility)

+(UIImage*)imageFitForSize:(CGSize)inSize forSourceImage:(UIImage*)sourceImage
{
    // redraw the image to fit |yourView|'s size
    CGSize imageOriginalSize = sourceImage.size;
    UIImage *resultImage = nil;
    if (imageOriginalSize.width<=inSize.width && imageOriginalSize.height<=inSize.height)
    {
        UIGraphicsBeginImageContextWithOptions(inSize, NO, 0.f);
        [sourceImage drawInRect:CGRectMake(0, 0, inSize.width, inSize.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return resultImage;
}

+(UIImage*) drawText:(NSString*) text
                font:(UIFont*)   font
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
               color:(UIColor*)  color
{
    UIGraphicsBeginImageContextWithOptions(image.size, 0, image.scale);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [color set];
    [text drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage*) drawImage:(UIImage*)sourceImage
               inSize:(CGSize)inSize
              atPoint:(CGPoint)point {
    
    UIImage *resultImage = nil;
    CGSize imageOriginalSize = sourceImage.size;
    if (imageOriginalSize.width<=inSize.width && imageOriginalSize.height<=inSize.height) {
        UIGraphicsBeginImageContextWithOptions(inSize, NO, sourceImage.scale);
        [sourceImage drawInRect:CGRectMake(point.x, point.y, imageOriginalSize.width, imageOriginalSize.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return resultImage;
}

@end
