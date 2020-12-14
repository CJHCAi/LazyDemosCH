//
//  MBProgressHUD+YT.h
//  每日烹
//
//  Created by Mac on 16/5/10.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (YT)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
+(void)showNormalMessage:(NSString *)NormalMessage showDetailText:(NSString*)DetailText toView:(UIView *)view;
@end
