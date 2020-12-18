//
//  ZJProgressHUDView.h
//  ZJProgressHUD
//
//  Created by ZeroJ on 16/9/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJProgressHUD : UIView
// 单例方法
+ (instancetype)sharedInstance;
// 初始化方法
- (instancetype)init;
// 设置/添加hudView的方法
- (void)setHudView:(UIView *)hudView;
// 被window弹出的方法, 同时设置显示的时间, 当设置的时间小于等于0的时候将不会自动移除
- (void)showWithTime:(CGFloat)time;
// 移除hud的方法
- (void)hide;
// 移除所有hud的方法
- (void)hideAllHUDs;
@end

@interface ZJProgressHUD (Public)
/** 提示文字, 不会自动隐藏*/
+ (void)showStatus:(NSString *)status;
/** 提示文字, 会自动隐藏*/
+ (void)showStatus:(NSString *)status andAutoHideAfterTime:(CGFloat)showTime;

/** 提示成功 显示默认的图片, 不会自动隐藏*/
+ (void)showSuccess;
/** 提示成功 显示默认的图片, 会自动隐藏*/
+ (void)showSuccessAndAutoHideAfterTime:(CGFloat)showTime;

/** 提示成功 显示默认的图片, 同时显示设定的文字提示, 不会自动隐藏*/
+ (void)showSuccessWithStatus:(NSString *)status;
/** 提示成功 显示默认的图片, 同时显示设定的文字提示, 会自动隐藏*/
+ (void)showSuccessWithStatus:(NSString *)status andAutoHideAfterTime:(CGFloat)showTime;

/** 提示失败 显示默认的图片, 不会自动隐藏*/
+ (void)showError;
/** 提示失败 显示默认的图片, 会自动隐藏*/
+ (void)showErrorAndAutoHideAfterTime:(CGFloat)showTime;

/** 提示失败 显示默认的图片, 同时显示设定的文字提示, 不会自动隐藏*/
+ (void)showErrorWithStatus:(NSString *)status;
/** 提示失败 显示默认的图片, 同时显示设定的文字提示, 会自动隐藏*/
+ (void)showErrorWithStatus:(NSString *)status andAutoHideAfterTime:(CGFloat)showTime;

/** 提示正在加载 显示默认的图片 不会自动隐藏*/
+ (void)showProgress;
/** 提示正在加载 显示默认的图片, 同时显示设定的文字提示 不会自动隐藏*/
+ (void)showProgressWithStatus:(NSString *)status;

/** 弹出自定义的提示框 不会自动隐藏*/
+ (void)showCustomHUD:(UIView *)hudView;
/** 弹出自定义的提示框 会自动隐藏*/
+ (void)showCustomHUD:(UIView *)hudView andAutoHideAfterTime:(CGFloat)showTime;

/** 移除提示框*/
+ (void)hideHUD;
/** 移除所有提示框*/
+ (void)hideAllHUDs;
@end
