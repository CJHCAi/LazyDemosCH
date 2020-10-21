//
//  MBProgressHUD+Utils.h
//  LuoChang
//
//  Created by Rick on 15/5/7.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Utils)
+(void)hudShow:(NSString *)msg;

+(void)hudShow:(NSString *)msg inView:(UIView *)view;
//+(void)hudShow:(NSString *)msg inView:(UIView *)view backGroundTransparent:(BOOL)select;

+(void)hudShowSuccess:(NSString *)msg;

+(void)hudShowSuccess:(NSString *)msg inView:(UIView *)view;

+(void)hudShowError:(NSString *)msg;
+(void)hudShowError:(NSString *)msg inView:(UIView *)view;
@end
