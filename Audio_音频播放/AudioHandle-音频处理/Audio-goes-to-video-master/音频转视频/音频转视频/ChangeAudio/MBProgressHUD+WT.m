//
//  MBProgressHUD+WT.m
//  项目框架封装
//
//  Created by 王涛 on 16/3/6.
//  Copyright © 2016年 304. All rights reserved.
//

#import "MBProgressHUD+WT.h"

@implementation MBProgressHUD (WT)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:0.7];
}
#pragma mark 显示有偏移量的显示信息
+(void)showHint:(NSString *)hint yOffset:(float)yoffset xOffset:(float)xoffset
{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = YES;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = 200.f;
    hud.yOffset += yoffset;
    hud.xOffset += xoffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}
#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些其他信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}
+(void)showHudInView:(UIView *)view hint:(NSString *)text
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = text;
    HUD.userInteractionEnabled = YES;
    [view addSubview:HUD];
    [HUD show:YES];
}

#pragma mark 显示loading的加载信息
+ (void)showCustomLoading:(NSString *)text name:(NSString *)name imageNum:(NSInteger)imageNum
{
    // 显示加载失败
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // 显示一张图片(mode必须写在customView设置之前)
    hud.mode = MBProgressHUDModeCustomView;
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    imgView.animationDuration = 3;
    imgView.animationRepeatCount = 9999;
    NSMutableArray *imgArray=[NSMutableArray array];
    for (int i =1; i<=imageNum; i++) {
        NSString *imageN=[NSString stringWithFormat:@"page_loading_%d",i];
        UIImage *image = [UIImage imageNamed:imageN];
        [imgArray addObject:image];
    }
    imgView.animationImages = imgArray;
    [imgView startAnimating];
    hud.customView=imgView;
    hud.labelText = text;
    
    // 隐藏的时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒后自动隐藏
    [hud hide:YES afterDelay:10];
}
#pragma mark 隐藏提示
+(void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;

    [self hideHUDForView:view animated:YES];
}
+(void)hideHUD
{
    
    [self hideHUDForView:nil];
}
@end
