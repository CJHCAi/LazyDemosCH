//
//  UIView+ZJExtension.h
//  WeiboDemo
//
//  Created by Zj on 16/9/17.
//  Copyright © 2016年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZJExtension)
/**
 *  重写set/get方法,快速获取/变更frame
 */
@property (nonatomic ,assign) CGFloat x;
@property (nonatomic ,assign) CGFloat y;
@property (nonatomic ,assign) CGFloat width;
@property (nonatomic ,assign) CGFloat height;
@property (nonatomic ,assign) CGFloat centerX;
@property (nonatomic ,assign) CGFloat centerY;
@property (nonatomic ,assign) CGSize size;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;

@end
