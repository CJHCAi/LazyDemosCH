//
//  hemicycleLoadProgressView.h
//  ProgressView
//
//  Created by zhao on 16/10/24.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HemicycleLoadProgressView : UIView


@property (nonatomic, assign) CGFloat animationDuration; /**<动画持续时长*/
@property (nonatomic, assign) CGFloat progressWidth; /**< 进度条宽度 默认3*/
@property (nonatomic, strong) UIColor *progressColor; /**< 进度条颜色 默认红色*/
@property (nonatomic, strong) UIColor *progressBackgroundColor; /**< 进度条背景色 默认灰色*/
@property (nonatomic, assign) BOOL clockwise; /**< 0顺时针 1逆时针*/


/**
 *  添加通知 当程序重新进入前台或活跃状态，动画仍然会执行
 */
- (void)addNotificationObserver;

@end
