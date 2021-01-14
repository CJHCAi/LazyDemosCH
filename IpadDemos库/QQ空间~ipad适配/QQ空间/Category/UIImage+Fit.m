//
//  UIImage+Fit.m
//  QQ_Zone
//
//  Created by apple on 14-12-7.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIImage+Fit.h"

@implementation UIImage (Fit)

/**
 *  传入图片名称,返回拉伸好的图片
 */
+ (UIImage *)resizeImage:(NSString *)imageName
{
    return [[UIImage imageNamed:imageName] resizeImage];
}

- (UIImage *)resizeImage
{
    CGFloat width = self.size.width * 0.5;
    CGFloat height = self.size.height * 0.5;
    return [self stretchableImageWithLeftCapWidth:width topCapHeight:height];
}

@end
