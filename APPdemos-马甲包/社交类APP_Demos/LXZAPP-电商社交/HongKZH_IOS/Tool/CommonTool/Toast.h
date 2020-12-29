//
//  Toast.h
//  YiXiu
//
//  Created by QinGuoLi on 16/4/20.
//  Copyright © 2016年 Liqg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


#define TOAST_DURATION_LONG 3
#define TOAST_DURATION_SHORT 1.5


// 信息提示显示时间(秒)
typedef enum {
    ToastDurationLong,
    ToastDurationShort
} ToastDuration;

typedef enum {
    ToastPositionMiddle,
    ToastPositionBottom,
    ToastPositionTop
} ToastPosition;


@interface Toast : NSObject


+ (void)makeText:(NSString *)text;

+ (void)makeText:(NSString *)text duration:(ToastDuration)duration;

+ (void)makeText:(UIView *)view text:(NSString *)text;

+ (void)makeText:(UIView *)view text:(NSString *)text duration:(ToastDuration)duration position:(ToastPosition)position;

/**
 *  显示加载提示(自动隐藏)
 *
 *  @param view
 */
+ (void)loading:(UIView *)view;

+ (void)loading;

+ (void)loaded;
+ (void)loading:(UIView *)view text:(NSString *)text;

/**
 *  显示加载提示(手动隐藏)
 *
 *  @return
 */

+ (UIAlertView *)loading:(NSString *)text delegate:(id)delegate buttonTitle:(NSString *)buttonTitle;

+ (void)loaded:(UIAlertView *)alertView;

@end
