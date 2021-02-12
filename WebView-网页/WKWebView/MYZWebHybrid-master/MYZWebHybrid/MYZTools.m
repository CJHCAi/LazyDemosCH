//
//  MYZTools.m
//  MYZWebHybrid
//
//  Created by MA806P on 2019/2/23.
//  Copyright © 2019 myz. All rights reserved.
//

#import "MYZTools.h"
#import <UIKit/UIKit.h>

@implementation MYZTools

/// 弹框显示信息，2秒后消失
+ (void)showMessage:(NSString *)message {
    [MYZTools showMessage:message delay:2.0];
}

/// 弹框显示信息，几秒后消失
+(void)showMessage:(NSString *)message delay:(NSTimeInterval)delay
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    CGFloat viewW = 190;
    CGFloat viewH = 50;
    CGFloat viewX = ([UIScreen mainScreen].bounds.size.width - viewW) * 0.5;
    CGFloat viewY = ([UIScreen mainScreen].bounds.size.height - viewH) * 0.5;
    
    UIView *showview =  [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
    showview.backgroundColor = [UIColor blackColor];
    showview.layer.cornerRadius =4.0;
    showview.clipsToBounds = YES;
    [window addSubview:showview];
    
    CGFloat labelMargin = 8.0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelMargin, 0, viewW - labelMargin*2.0, viewH)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    [showview addSubview:label];
    
    
    [UIView animateWithDuration:1.0 delay:delay options:0 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

//系统AlertView显示
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    if([MYZTools is_stringEmpty:title] || [MYZTools is_stringEmpty:message]) {return;}
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

// 判断字符串是否为空
+ (BOOL)is_stringEmpty:(NSString *)string {
    BOOL isString = YES;
    if (string && [string isKindOfClass:[NSString class]] && string.length > 0) {
        isString = NO;
    }
    return isString;
}

// 判断是否为数组类型
+ (BOOL)is_array:(NSArray *)array {
    BOOL isArray = NO;
    if (array && [array isKindOfClass:[NSArray class]]) {
        isArray = YES;
    }
    return isArray;
}

// 判断是否为字典类型
+ (BOOL)is_dcitionary:(NSDictionary *)dic {
    BOOL isDic = NO;
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        isDic = YES;
    }
    return isDic;
}


@end
