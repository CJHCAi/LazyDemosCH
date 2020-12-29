//
//  Tools.m
//  WallPaper
//
//  Created by Never on 2017/2/15.
//  Copyright © 2017年 Never. All rights reserved.
//

#import "Tools.h"

@class MBProgressHUD;

@implementation Tools

//默认样式
+ (MBProgressHUD *)MBProgressHUD:(NSString *)text{
   MBProgressHUD *HUD = [self creatHUDwith:text andMod:MBProgressHUDModeIndeterminate];
    return HUD;
}

//带进度条
+ (MBProgressHUD *)MBProgressHUDProgress:(NSString *)text{
    
    MBProgressHUD *HUD = [self creatHUDwith:text andMod:MBProgressHUDModeAnnularDeterminate];
    return HUD;
    
}

//仅文字提示
+ (MBProgressHUD *)MBProgressHUDOnlyText:(NSString *)text{
    
    MBProgressHUD *HUD = [self creatHUDwith:text andMod:MBProgressHUDModeText];
    return HUD;
}
//自定义view
+ (MBProgressHUD *)MBProgressHUDCustomView:(NSString *)text{

    MBProgressHUD *HUD = [self creatHUDwith:text andMod:MBProgressHUDModeCustomView];
    return HUD;
}

//封装
+ (MBProgressHUD *)creatHUDwith:(NSString *)text andMod:(MBProgressHUDMode)mod{

    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    HUD.mode = mod;
    if (mod == MBProgressHUDModeCustomView) {
        UIImageView *customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minion"]];
        HUD.customView = customView;
    }
    //NO允许点击其他地方，YES不允许点击其他地方
    HUD.userInteractionEnabled = NO;
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.color = [UIColor colorWithWhite:0.3 alpha:0.9];
    HUD.label.text = text;
//    HUD.contentColor = [UIColor whiteColor];
    HUD.animationType = MBProgressHUDAnimationZoomOut;
    [window addSubview:HUD];
    [HUD showAnimated:YES];
    return HUD;
}

@end
