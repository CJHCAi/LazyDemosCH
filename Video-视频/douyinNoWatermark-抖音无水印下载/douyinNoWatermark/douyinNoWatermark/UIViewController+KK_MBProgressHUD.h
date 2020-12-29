//
//  UIViewController+KK_MBProgressHUD.h
//  ColorPicking
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (KK_MBProgressHUD)
-(void)mb_showSuccess:(NSString *)success;
//注意
-(void)mb_showError:(NSString *)error;
-(void)mb_showMessage:(NSString *)message;
-(void)mb_showWaiting;
-(void)mb_showWaitingDelay:(CGFloat)delayTime Enable:(BOOL)enable;
-(void)mb_showLoading;
-(void)mb_showLoadingWithMessage:(NSString *)message;
-(void)mb_showLoadingWithMessage:(NSString *)message Delay:(CGFloat)delayTime Enable:(BOOL)enable;
-(void)mb_showSaving;
-(void)mb_showSavingDelay:(CGFloat)delayTime Enable:(BOOL)enable;
-(void)mb_showMessage:(NSString *)message selector:(SEL)selector;
-(void)mb_hideHUD;
@end

NS_ASSUME_NONNULL_END
