//
//  UIImage+Crop.m
//  incup
//
//  Created by wanglh on 15/5/21.
//  Copyright (c) 2015年 Kule Yang. All rights reserved.
//

#import "UIImage+Crop.h"

@implementation UIImage (Crop)
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    return image;
}
+(UIImage *)fitScreenWithImage:(UIImage *)image
{
    CGSize newSize;
    BOOL min = image.size.height>image.size.width;
    if (min && image.size.width<SCREEN_WIDTH) {
        CGFloat scale = SCREEN_WIDTH/image.size.width;
        newSize = CGSizeMake(SCREEN_WIDTH, image.size.height*scale);
    }else if (min && image.size.width >= SCREEN_WIDTH){ // 比圆大
        CGFloat scale = SCREEN_WIDTH/image.size.width;
        newSize = CGSizeMake(SCREEN_WIDTH, image.size.height*scale);
    }else{
        CGFloat scale = SCREEN_WIDTH/image.size.height;
        newSize = CGSizeMake(image.size.width * scale, SCREEN_WIDTH);
    }
     image = [self imageWithImageSimple:image scaledToSize:newSize];
    return image;
}
@end
