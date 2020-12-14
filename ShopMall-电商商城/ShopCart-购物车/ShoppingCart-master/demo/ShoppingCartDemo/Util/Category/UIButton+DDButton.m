//
//  UIButton+DDButton.m
//  CategoryTest
//
//  Created by Dry on 2017/7/26.
//  Copyright © 2017年 Dry. All rights reserved.
//

#import "UIButton+DDButton.h"
#import <objc/runtime.h>

@implementation UIButton (DDButton)

/// 设置button的选中和非选中颜色
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    self.clipsToBounds = YES;
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
