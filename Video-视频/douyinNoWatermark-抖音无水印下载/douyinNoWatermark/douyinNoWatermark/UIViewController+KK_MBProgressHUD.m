//
//  UIViewController+KK_MBProgressHUD.m
//  ColorPicking
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 apple. All rights reserved.
//

#import "UIViewController+KK_MBProgressHUD.h"
#import "JK_MBProgressHUD.h"
@implementation UIViewController (KK_MBProgressHUD)
-(void)mb_showSuccess:(NSString *)success
{
    [self hudFriend];
    
    JK_MBProgressHUD *HUD=[[JK_MBProgressHUD alloc]initWithView:[self getView]];
    HUD.contentColor=[UIColor whiteColor];
    HUD.bezelView.color=[UIColor blackColor];
    HUD.mode=JK_MBProgressHUDModeText;
    HUD.label.text=success;
    HUD.removeFromSuperViewOnHide=YES;
    [[self getView] addSubview:HUD];
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
}
-(void)mb_showError:(NSString *)error
{
    [self hudFriend];
    
    JK_MBProgressHUD *HUD=[[JK_MBProgressHUD alloc]initWithView:[self getView]];
    HUD.contentColor=[UIColor whiteColor];
    HUD.bezelView.color=[UIColor blackColor];
    HUD.mode=JK_MBProgressHUDModeText;
    //    HUD.label.text=error;
    HUD.detailsLabel.text = error;
    HUD.detailsLabel.font = [UIFont boldSystemFontOfSize:16];
    HUD.removeFromSuperViewOnHide=YES;
    [[self getView] addSubview:HUD];
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
}
-(void)mb_showMessage:(NSString *)message
{
    [self hudFriend];
    
    JK_MBProgressHUD *HUD=[[JK_MBProgressHUD alloc]initWithView:[self getView]];
    HUD.contentColor=[UIColor whiteColor];
    HUD.bezelView.color=[UIColor blackColor];
    HUD.mode=JK_MBProgressHUDModeText;
    //    HUD.label.text=message;
    HUD.detailsLabel.text = message;
    HUD.detailsLabel.font = [UIFont boldSystemFontOfSize:16];
    HUD.removeFromSuperViewOnHide=YES;
    [[self getView] addSubview:HUD];
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
}
-(void)mb_showWaiting
{
    [self mb_showWaitingDelay:0 Enable:NO];
}
-(void)mb_showWaitingDelay:(CGFloat)delayTime Enable:(BOOL)enable {
    [self hudFriend];
    
    JK_MBProgressHUD *HUD=[[JK_MBProgressHUD alloc]initWithView:[self getView]];
    HUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor=[UIColor whiteColor];
    HUD.removeFromSuperViewOnHide=YES;
    
    HUD.userInteractionEnabled = !enable;//To still allow touches to pass through the HUD, you can set hud.userInteractionEnabled = NO.
    
    [[self getView] addSubview:HUD];
    [HUD showAnimated:YES];
    
    if (delayTime != 0) {
        [HUD hideAnimated:YES afterDelay:delayTime];
    }
}

-(void)mb_showLoading
{
    [self mb_showLoadingDelay:0 Enable:NO];
}
-(void)mb_showLoadingDelay:(CGFloat)delayTime Enable:(BOOL)enable {
    [self hudFriend];
    
    JK_MBProgressHUD *HUD=[[JK_MBProgressHUD alloc]initWithView:[self getView]];
    HUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor=[UIColor whiteColor];
    HUD.label.text=@"正在加载";
    HUD.removeFromSuperViewOnHide=YES;
    HUD.userInteractionEnabled = !enable;
    [[self getView] addSubview:HUD];
    [HUD showAnimated:YES];
    if (delayTime != 0) {
        [HUD hideAnimated:YES afterDelay:delayTime];
    }
}

-(void)mb_showLoadingWithMessage:(NSString *)message
{
    [self mb_showLoadingWithMessage:message Delay:0 Enable:NO];
}
-(void)mb_showLoadingWithMessage:(NSString *)message Delay:(CGFloat)delayTime Enable:(BOOL)enable {
    [self hudFriend];
    
    JK_MBProgressHUD *HUD=[[JK_MBProgressHUD alloc]initWithView:[self getView]];
    HUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor=[UIColor whiteColor];
    //    HUD.label.text=message;
    HUD.detailsLabel.text = message;
    HUD.detailsLabel.font = [UIFont boldSystemFontOfSize:14];
    HUD.removeFromSuperViewOnHide=YES;
    HUD.userInteractionEnabled = !enable;
    [[self getView] addSubview:HUD];
    [HUD showAnimated:YES];
    if (delayTime != 0) {
        [HUD hideAnimated:YES afterDelay:delayTime];
    }
}
-(void)mb_showSaving
{
    [self mb_showSavingDelay:0 Enable:NO];
}
-(void)mb_showSavingDelay:(CGFloat)delayTime Enable:(BOOL)enable {
    [self hudFriend];
    
    JK_MBProgressHUD *HUD=[[JK_MBProgressHUD alloc]initWithView:[self getView]];
    HUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor=[UIColor whiteColor];
    HUD.label.text=@"正在保存";
    HUD.removeFromSuperViewOnHide=YES;
    HUD.userInteractionEnabled = !enable;
    [[self getView] addSubview:HUD];
    [HUD showAnimated:YES];
    if (delayTime != 0) {
        [HUD hideAnimated:YES afterDelay:delayTime];
    }
}

-(void)mb_showMessage:(NSString *)message selector:(SEL)selector
{
    [self hudFriend];
    
    //    JK_MBProgressHUD *HUD=[[JK_MBProgressHUD alloc]initWithView:[self getView]];
    JK_MBProgressHUD *HUD = [JK_MBProgressHUD showHUDAddedTo:[self getView] animated:YES];
    HUD.mode = JK_MBProgressHUDModeCustomView;
    //    HUD.label.text = message;
    HUD.detailsLabel.text = message;
    HUD.detailsLabel.font = [UIFont boldSystemFontOfSize:16];
    [HUD.button setTitle:@"退出" forState:UIControlStateNormal];
    [HUD.button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    //    HUD.removeFromSuperViewOnHide=YES;
    //    [[self getView] addSubview:HUD];
    
}

-(void)mb_hideHUD
{
    [JK_MBProgressHUD hideHUDForView:[self getView] animated:YES];
}
-(UIView *)getView
{
    UIView *view;
    if (self.navigationController.view) {
        view=self.navigationController.view;
    }else
    {
        view=self.view;
    }
    return view;
}
-(BOOL)hasMBhud{
    JK_MBProgressHUD *hud = [JK_MBProgressHUD HUDForView:[self getView]];
    if (hud != nil) {
        return YES;
    }
    return NO;
}
-(void)hudFriend{
    BOOL ex = [self hasMBhud];
    if (ex) {//屏幕上有hud 先移除
        [self mb_hideHUD];
    }
}
@end
