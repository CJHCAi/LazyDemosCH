//
//  UIImage+YY.m
//  HandsUp
//
//  Created by wanghui on 2018/5/12.
//  Copyright © 2018年 HandsUp.Network. All rights reserved.
//

#import "UIImage+YY.h"
#import "UIImage+YYWebImage.h"
@implementation UIImage (YY)
-(nullable UIImage *)zsyy_imageByResizeToSize:(CGSize)imageSize contentMode:(UIViewContentMode)contenModel{
   return  [self yy_imageByResizeToSize:imageSize contentMode:contenModel];
}
-(nullable UIImage *)zsyy_imageByResizeToSize:(CGSize)imageSize roundCornerRadius:(CGFloat)radius{
    CGFloat wh = self.size.height<self.size.width?self.size.height:self.size.width*0.5;
    CGSize size;
    if (imageSize.width >0) {
        size = imageSize;
    }else{
        
        size= CGSizeMake(wh, wh);
    }
    if (radius==0) {
        radius = wh*0.5;
    }
    UIImage *imageV = [self zsyy_imageByResizeToSize:size contentMode:UIViewContentModeScaleAspectFill];
    return [imageV yy_imageByRoundCornerRadius:radius];
}
- (nullable UIImage *)zsyy_imageByRoundCornerRadius:(CGFloat)radius{
    
    return [self yy_imageByRoundCornerRadius:radius];
}
- (nullable UIImage *)zsyy_imageByRoundCornerRadius:(CGFloat)radius
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(UIColor *)borderColor{
    return [self yy_imageByRoundCornerRadius:radius borderWidth:borderWidth borderColor:borderColor];;
}
+(nullable UIImage *)zsyy_imageByResizeToSize:(CGSize)imageSize roundCornerRadius:(CGFloat)radius color:(UIColor*)color{
    UIImage *image = [UIImage yy_imageWithColor:color size:imageSize];
   image = [image zsyy_imageByRoundCornerRadius:radius];
    return image;
    
}
@end
