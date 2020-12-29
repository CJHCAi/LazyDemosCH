//
//  Toast.m
//  YiXiu
//
//  Created by QinGuoLi on 16/4/20.
//  Copyright © 2016年 Liqg. All rights reserved.
//

#import "Toast.h"
#import "UIColor+Hex.h"
#import "AppUtils.h"

#define LOADING_VIEW_TAG 100000

UIAlertView *loadingView;
static NSTimer *outTimeTimer;
MBProgressHUD *loadingHUDView;
UIView *loadingMaskView;
UIView *loadingContentView;



@implementation Toast

+ (void)makeText:(NSString *)text
{
    [self makeText:text duration:ToastDurationShort];
}

+ (void)makeText:(NSString *)text duration:(ToastDuration)duration
{
    [self makeText:[UIApplication sharedApplication].keyWindow text:text duration:duration position:ToastPositionMiddle];
}

+ (void)makeText:(UIView *)view text:(NSString *)text
{
    [self makeText:view text:text duration:ToastDurationShort position:ToastPositionMiddle];
}


+ (void)makeText:(UIView *)view text:(NSString *)text duration:(ToastDuration)duration position:(ToastPosition)position
{
    if ([AppUtils isEmpty:text]) {
        return;
    }
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

    hud.mode = MBProgressHUDModeText;
    hud.yOffset = position == ToastPositionMiddle ? -50 : 150;
    if (IS_IPHONE4 && position == ToastPositionMiddle ) {
        hud.yOffset = -120;
    }
    if (position == ToastPositionTop) {
        hud.yOffset = -120;
    }
    hud.detailsLabelText = text;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    NSTimeInterval delay = duration == ToastDurationLong ? TOAST_DURATION_LONG : TOAST_DURATION_SHORT;
    [hud hide:YES afterDelay:delay];
}


+ (void)loading:(UIView *)view
{
    [self loading:view text:@""];
}
+ (void)loading
{
    [self loading:[[[UIApplication sharedApplication] delegate] window]];
}
+ (void)loaded
{
    if (loadingHUDView) {
        [loadingHUDView hide:YES];
        [loadingHUDView removeFromSuperview];
        loadingHUDView = nil;
    }
    [self invalidateTimer:outTimeTimer];
}

+ (void)loading:(UIView *)view text:(NSString *)text
{
    if (loadingHUDView == nil) {
        loadingHUDView = [[MBProgressHUD alloc] initWithView:view];
        loadingHUDView.labelFont = [UIFont boldSystemFontOfSize:15];
        loadingHUDView.labelColor = [UIColor colorFromHexString:@"e2e2e2"];
        loadingHUDView.minSize = CGSizeMake(80, 80);
       // loadingHUDView.backgroundColor =[UIColor redColor];
        [view addSubview:loadingHUDView];
    }
    loadingHUDView.labelText = text;
    [loadingHUDView show:YES];
    [self invalidateTimer:outTimeTimer];
    outTimeTimer = [NSTimer scheduledTimerWithTimeInterval:100 target:self selector:@selector(stopOutTimeTimer) userInfo:nil repeats:NO];
}

+ (UIAlertView *)loading:(NSString *)text delegate:(id)delegate buttonTitle:(NSString *)buttonTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:text delegate:delegate cancelButtonTitle:buttonTitle otherButtonTitles:nil, nil];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    if (!IS_IOS6) {
        [alert setValue:activityView forKey:@"accessoryView"];
    } else {
        activityView.frame = CGRectMake(5, 15, 20, 20);
        [alert addSubview:activityView];
    }
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert show];
    return alert;
}
+ (void)loaded:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

+ (void)stopOutTimeTimer
{
    [self loaded];
}
+ (void)invalidateTimer:(NSTimer *)timer
{
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
}

@end
