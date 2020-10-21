//
//  MBProgressHUD+Utils.m
//  LuoChang
//
//  Created by Rick on 15/5/7.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import "MBProgressHUD+Utils.h"

@implementation MBProgressHUD (Utils)

+(void)hudShow:(NSString *)msg{
    if (hud==nil) {
        hud = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
    }
//    hud.color = RGBA(194, 194, 194,0);
    hud.mode = MBProgressHUDModeCustomView;
    UIImageView *animationImageView = [[UIImageView alloc]init];
    animationImageView.bounds = CGRectMake(0, 0, 50, 50);
    NSArray *imagesArray = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"loading_000"],
                           [UIImage imageNamed:@"loading_001"],
                           [UIImage imageNamed:@"loading_002"],
                           [UIImage imageNamed:@"loading_003"],
                           [UIImage imageNamed:@"loading_004"],
                           [UIImage imageNamed:@"loading_005"],
                           [UIImage imageNamed:@"loading_006"],
                           [UIImage imageNamed:@"loading_007"],
                           [UIImage imageNamed:@"loading_008"],
                           nil];
    animationImageView.animationImages = imagesArray;//将序列帧数组赋给UIImageView的animationImages属性
    animationImageView.animationDuration = 1;//设置动画时间
    animationImageView.animationRepeatCount = 0;//设置动画次数 0 表示无限
    [animationImageView startAnimating];
    hud.customView = animationImageView;
    if (msg) {
        hud.labelText = msg;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud show:YES];
}

+(void)hudShow:(NSString *)msg inView:(UIView *)view{
    if (hud==nil) {
        hud = [[MBProgressHUD alloc]initWithView:view];
    }
//    hud.color = RGB(194, 194, 194);
    hud.mode = MBProgressHUDModeCustomView;
    UIImageView *animationImageView = [[UIImageView alloc]init];
    animationImageView.bounds = CGRectMake(0, 0, 50, 50);
    NSArray *imagesArray = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"loading_000"],
                            [UIImage imageNamed:@"loading_001"],
                            [UIImage imageNamed:@"loading_002"],
                            [UIImage imageNamed:@"loading_003"],
                            [UIImage imageNamed:@"loading_004"],
                            [UIImage imageNamed:@"loading_005"],
                            [UIImage imageNamed:@"loading_006"],
                            [UIImage imageNamed:@"loading_007"],
                            [UIImage imageNamed:@"loading_008"],
                            nil];
    animationImageView.animationImages = imagesArray;//将序列帧数组赋给UIImageView的animationImages属性
    animationImageView.animationDuration = 1;//设置动画时间
    animationImageView.animationRepeatCount = 0;//设置动画次数 0 表示无限
    [animationImageView startAnimating];
    hud.customView = animationImageView;
    if (msg) {
        hud.labelText = msg;
    }
    [view addSubview:hud];
    [hud show:YES];
}

//+(void)hudShow:(NSString *)msg inView:(UIView *)view backGroundTransparent:(BOOL)select;
//{
//    if (hud==nil) {
//        hud = [[MBProgressHUD alloc]initWithView:view];
//    }
//    hud.color = RGB(255, 194, 194);
//    hud.alpha = 0.0f;
//    hud.mode = MBProgressHUDModeCustomView;
//    UIImageView *animationImageView = [[UIImageView alloc]init];
//    animationImageView.bounds = CGRectMake(0, 0, 50, 50);
//    NSArray *imagesArray = [NSArray arrayWithObjects:
//                            [UIImage imageNamed:@"loading_000"],
//                            [UIImage imageNamed:@"loading_001"],
//                            [UIImage imageNamed:@"loading_002"],
//                            [UIImage imageNamed:@"loading_003"],
//                            [UIImage imageNamed:@"loading_004"],
//                            [UIImage imageNamed:@"loading_005"],
//                            [UIImage imageNamed:@"loading_006"],
//                            [UIImage imageNamed:@"loading_007"],
//                            [UIImage imageNamed:@"loading_008"],
//                            nil];
//    animationImageView.animationImages = imagesArray;//将序列帧数组赋给UIImageView的animationImages属性
//    animationImageView.animationDuration = 1;//设置动画时间
//    animationImageView.animationRepeatCount = 0;//设置动画次数 0 表示无限
//    [animationImageView startAnimating];
//    hud.customView = animationImageView;
//    hud.customView.alpha = 0.0f;
//    hud.customView.backgroundColor = [UIColor redColor];
//    if (msg) {
//        hud.labelText = msg;
//    }
//    [view addSubview:hud];
//    [hud show:YES];
//}

+(void)hudShowSuccess:(NSString *)msg{
    if (hud==nil) {
        hud = [[MBProgressHUD alloc]initWithWindow:[[UIApplication sharedApplication].delegate window]];
    }
//    hud.color = RGB(194, 194, 194);
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = msg;
    [[[UIApplication sharedApplication].delegate window] addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:2.0];
}

+(void)hudShowSuccess:(NSString *)msg inView:(UIView *)view{
    if (hud==nil) {
        hud = [[MBProgressHUD alloc]initWithView:view];
    }
//    hud.color = RGB(194, 194, 194);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    if (msg) {
        hud.labelText = msg;
    }
    [view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:2.0f];
    
}

+(void)hudShowError:(NSString *)msg{
    if (hud==nil) {
        hud = [[MBProgressHUD alloc]initWithWindow:[[UIApplication sharedApplication].delegate window]];
    }
//    hud.color = RGB(194, 194, 194);
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUDerror"]];

    hud.labelText = msg;
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:2.0];
}


+(void)hudShowError:(NSString *)msg inView:(UIView *)view{
    if (hud==nil) {
        hud = [[MBProgressHUD alloc]initWithView:view];
    }
//    hud.color = RGB(194, 194, 194);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUDerror"]];
    if (msg) {
        hud.labelText = msg;
    }
    [view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:2.0];
}
@end
