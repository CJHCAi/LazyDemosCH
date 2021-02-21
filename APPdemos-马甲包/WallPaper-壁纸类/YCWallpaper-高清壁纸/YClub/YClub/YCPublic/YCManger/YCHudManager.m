//
//  YCHudManager.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCHudManager.h"
#import "MMMaterialDesignSpinner.h"

@implementation YCHudManager

+ (void)showHudInView:(UIView *)view
{
    if (!view) {
        return;
    }
    MBProgressHUD *oldHud = [MBProgressHUD HUDForView:view];
    if (oldHud) {
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    //hud.bezelView.color = [UIColor blackColor];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    //设置转轮颜色
    //[UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = ;
    [view addSubview:hud];
    [hud showAnimated:YES];
}
+ (void)showHudMessage:(NSString *)message InView:(UIView *)view
{
    if (!view) {
        return;
    }
    MBProgressHUD *oldHud = [MBProgressHUD HUDForView:view];
    if (oldHud) {
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.bezelView.color = [UIColor blackColor];
    hud.mode = MBProgressHUDModeText;
    [view addSubview:hud];
    [hud showAnimated:YES];
}
+ (void)showMessage:(NSString *)message InView:(UIView *)view
{
    if (!view) {
        return;
    }
    MBProgressHUD *preHud = [MBProgressHUD HUDForView:view];
    if (preHud) {
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.color = [UIColor blackColor];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = message;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.label.textColor        = [UIColor whiteColor];
    [view addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1];
}
+ (void)hideHudInView:(UIView *)view
{
    if (!view) {
        return;
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}

#pragma mark - loading
+ (void)showLoadingInView:(UIView *)view
{
    if (!view) {
        return;
    }
    view.userInteractionEnabled = NO;
    MMMaterialDesignSpinner *spiner = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    spiner.center = CGPointMake(view.centerX, view.centerY-32);
    spiner.lineWidth = 4;
    spiner.hidesWhenStopped = YES;
    spiner.tintColor = YC_TabBar_SeleteColor;
    [view addSubview:spiner];
    [spiner startAnimating];
}
+ (void)hideLoadingInView:(UIView *)view
{
    if (!view) {
        return;
    }
    view.userInteractionEnabled = YES;
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[MMMaterialDesignSpinner class]]) {
            [(MMMaterialDesignSpinner *)subView stopAnimating];
            [subView removeFromSuperview];
        }
    }
}
@end
