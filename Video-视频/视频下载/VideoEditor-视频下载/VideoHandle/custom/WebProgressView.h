//
//  WebProgressView.h
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/12.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebProgressView : UIView

//进度条颜色
@property (nonatomic,strong) UIColor *lineColor;

//开始加载
-(void)startLoadingAnimation;

//结束加载
-(void)endLoadingAnimation;

@end
