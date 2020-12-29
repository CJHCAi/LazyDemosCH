//
//  UIImage+Utility.h
//  H850Samba
//
//  Created by zhengying on 3/25/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)

+(UIImage*)imageFitForSize:(CGSize)inSize forSourceImage:(UIImage*)sourceImage;

+(UIImage*) drawText:(NSString*) text
                font:(UIFont*)   font
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
               color:(UIColor*)  color;

+(UIImage*) drawImage:(UIImage*)sourceImage
               inSize:(CGSize)inSize
              atPoint:(CGPoint)point;

@end
