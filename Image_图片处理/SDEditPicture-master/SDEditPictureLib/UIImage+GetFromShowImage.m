//
//  UIImage+GetFromShowImage.m
//  SDEditPicture
//
//  Created by shansander on 2017/8/1.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "UIImage+GetFromShowImage.h"

@implementation UIImage (GetFromShowImage)

+ (UIImage *)makeImageFromShowView:(UIView *)view
{
    CGSize s = view.bounds.size;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

// get part of the image // not woking partRect
- (UIImage *)getPartOfImagerect:(CGRect)partRect
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, partRect);
    UIImage *retImg = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return retImg;
}

@end
