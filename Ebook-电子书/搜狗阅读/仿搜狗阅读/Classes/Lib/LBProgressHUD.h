//
//  LBProgressHUD.h
//  LuckyBuy
//
//  Created by huangtie on 16/3/9.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBProgressHUD : UIView

@property (nonatomic , copy) NSString *tipText;

@property (nonatomic , strong) UIColor *toastColor;

@property (nonatomic , strong) UIColor *contentColor;

@property (nonatomic , assign) BOOL showMask;

- (void)show:(BOOL)animated;

- (void)hide:(BOOL)animated;


+ (instancetype)showHUDto:(UIView *)view animated:(BOOL)animated;

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated;

@end
