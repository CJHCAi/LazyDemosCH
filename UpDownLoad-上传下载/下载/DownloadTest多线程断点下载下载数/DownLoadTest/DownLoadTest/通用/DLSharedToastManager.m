//
//  DLSharedToastManager.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/26.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLSharedToastManager.h"
#import "MBProgressHUD.h"

@implementation DLSharedToastManager

+ (DLSharedToastManager *)sharedManager
{
    static DLSharedToastManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DLSharedToastManager alloc] init];
    });
    return sharedManager;
}

#pragma mark - Public
- (void)showToast:(NSString *)toast controller:(UIViewController *)controller
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:controller.view];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    hud.labelText = toast;
    [controller.view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1.f];
}

@end
