//
//  MBProgressHUD+WT.h
//  项目框架封装
//
//  Created by 王涛 on 16/3/6.
//  Copyright © 2016年 304. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (WT)
/**
 *  显示一般信息
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;
/**
 *  显示有偏移量的信息,yoffset,xoffset可以设置为0.f
 *
 */
+(void)showHint:(NSString *)hint yOffset:(float)yoffset xOffset:(float)xoffset;
/**
 *  显示错误信息
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;
/**
 *  显示成功信息
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
/**
 *  显示一些其他信息,有蒙版
 */
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
/**
 *  显示网络请求加载信息
 */
+(void)showHudInView:(UIView *)view hint:(NSString *)text;
/**
 *  显示loading的提示信息
 */
+ (void)showCustomLoading:(NSString *)text name:(NSString *)name imageNum:(NSInteger)imageNum;
/**
 *  从父控件上隐藏提示信息,如果添加到view上
 */
+ (void)hideHUDForView:(UIView *)view;
/**
 *  隐藏提示信息
 */
+ (void)hideHUD;
@end
