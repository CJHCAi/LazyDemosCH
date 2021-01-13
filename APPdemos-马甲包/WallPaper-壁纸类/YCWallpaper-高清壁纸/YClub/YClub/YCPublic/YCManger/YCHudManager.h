//
//  YCHudManager.h
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YCHudManager : NSObject

// Hud
+ (void)showHudInView:(UIView *)view;
+ (void)showHudMessage:(NSString *)message InView:(UIView *)view;
+ (void)showMessage:(NSString *)message InView:(UIView *)view;
+ (void)hideHudInView:(UIView *)view;

// Loading
+ (void)showLoadingInView:(UIView *)view;
+ (void)hideLoadingInView:(UIView *)view;
@end
