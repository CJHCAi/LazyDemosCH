//
//  UIViewController+SmartScale.h
//  Mine
//
//  Created by Miaolegemi on 15/12/16.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WIDTH 375
#define HEIGHT 667
//屏幕比例系数 x、y、width、height
#define SCALE_X [UIScreen mainScreen].bounds.size.width/375
#define SCALE_Y [UIScreen mainScreen].bounds.size.height/667

//内联函数 编译的时候将代码原封不动的编译到函数调用的地方，运行时就会顺序执行，比普通的函数效率更高
//定义
CG_INLINE CGRect CGRectMake1(CGFloat x,CGFloat y,CGFloat width,CGFloat height)
{
    //s缩放比例
    CGRect rect;
    rect.origin.x = SCALE_X*x;//当前屏幕大小（宽）/开发时所用屏幕（宽）
    rect.origin.y = SCALE_Y*y;//当前屏幕大小（高）/开发时所用屏幕（高）
    rect.size.width = SCALE_X*width;
    rect.size.height = SCALE_Y*height;
    return rect;
}

CG_INLINE CGRect CGRectMake2(CGFloat x,CGFloat y,CGFloat width,CGFloat height)
{
    //s缩放比例
    CGRect rect;
    rect.origin.x = SCALE_X*x;//当前屏幕大小（宽）/开发时所用屏幕（宽）
    rect.origin.y = y;//当前屏幕大小（高）/开发时所用屏幕（高）
    rect.size.width = SCALE_X*width;
    rect.size.height = SCALE_Y*height;
    return rect;
}

CG_INLINE CGRect CGRectMake3(CGFloat x,CGFloat y,CGFloat width,CGFloat height)
{
    //s缩放比例
    CGRect rect;
    rect.origin.x = x;//当前屏幕大小（宽）/开发时所用屏幕（宽）
    rect.origin.y = y;//当前屏幕大小（高）/开发时所用屏幕（高）
    rect.size.width = SCALE_X*width;
    rect.size.height = SCALE_Y*height;
    return rect;
}

CG_INLINE CGRect CGRectMake4(CGFloat x,CGFloat y,CGFloat width,CGFloat height)
{
    //s缩放比例
    CGRect rect;
    rect.origin.x = SCALE_X*x;//当前屏幕大小（宽）/开发时所用屏幕（宽）
    rect.origin.y = SCALE_Y*y;//当前屏幕大小（高）/开发时所用屏幕（高）
    rect.size.width = SCALE_Y*width;
    rect.size.height = SCALE_Y*height;
    return rect;
}

CG_INLINE CGRect CGRectMake5(CGFloat x,CGFloat y,CGFloat width,CGFloat height)
{
    //s缩放比例
    CGRect rect;
    rect.origin.x = x;//当前屏幕大小（宽）/开发时所用屏幕（宽）
    rect.origin.y = SCALE_Y*y;//当前屏幕大小（高）/开发时所用屏幕（高）
    rect.size.width = SCALE_X*width;
    rect.size.height = SCALE_Y*height;
    return rect;
}
CG_INLINE CGRect CGRectMake6(CGFloat x,CGFloat y,CGFloat width,CGFloat height)
{
    //s缩放比例
    CGRect rect;
    rect.origin.x = SCALE_X*x;//当前屏幕大小（宽）/开发时所用屏幕（宽）
    rect.origin.y = SCALE_Y*y;//当前屏幕大小（高）/开发时所用屏幕（高）
    rect.size.width = SCALE_Y*width;
    rect.size.height = SCALE_Y*height;
    return rect;
}
CG_INLINE CGRect CGRectMake7(CGFloat x,CGFloat y,CGFloat width,CGFloat height)
{
    //s缩放比例
    CGRect rect;
    rect.origin.x = SCALE_X*x;//当前屏幕大小（宽）/开发时所用屏幕（宽）
    rect.origin.y = y;//当前屏幕大小（高）/开发时所用屏幕（高）
    rect.size.width = SCALE_Y*width;
    rect.size.height = SCALE_Y*height;
    return rect;
}
@interface UIViewController (SmartScale)

@end
