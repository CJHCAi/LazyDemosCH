//
//  UIImage+YY.h
//  HandsUp
//
//  Created by wanghui on 2018/5/12.
//  Copyright © 2018年 HandsUp.Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YY)
+(nullable UIImage *)zsyy_imageByResizeToSize:(CGSize)imageSize roundCornerRadius:(CGFloat)radius color:(UIColor*)color;
-(nullable UIImage *)zsyy_imageByResizeToSize:(CGSize)imageSize roundCornerRadius:(CGFloat)radius;
-(nullable UIImage *)zsyy_imageByResizeToSize:(CGSize)imageSize contentMode:(UIViewContentMode)contenModel;
- (nullable UIImage *)zsyy_imageByRoundCornerRadius:(CGFloat)radius;
- (nullable UIImage *)zsyy_imageByRoundCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth  borderColor:(UIColor *)borderColor;
@end
