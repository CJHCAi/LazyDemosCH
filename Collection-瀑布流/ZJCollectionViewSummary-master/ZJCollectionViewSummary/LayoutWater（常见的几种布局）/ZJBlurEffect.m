//
//  ZJBlurEffect.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/11.
//  Copyright © 2018年 James. All rights reserved.
//

#import "ZJBlurEffect.h"

@implementation ZJBlurEffect

//设置毛玻璃效果
+ (void)blurEffect:(UIView *)view{
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectVIew = [[UIVisualEffectView alloc]initWithEffect:effect];
    effectVIew.frame = view.bounds;
    [view addSubview:effectVIew];
    
}

@end
