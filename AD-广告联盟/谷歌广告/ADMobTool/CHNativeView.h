//
//  CHNativeView.h
//  MeiTuDemo
//
//  Created by 七啸网络 on 2018/5/23.
//  Copyright © 2018年 zhuofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHNativeView : UIView

/**统一原生模板广告和自定义模板广告*/
-(instancetype)initWithFrame:(CGRect)frame UnifiedNative:(BOOL)isUnified CustomTemplate:(BOOL)isCustom;
-(void)refreshAd:(UIButton *)Button;
@end
