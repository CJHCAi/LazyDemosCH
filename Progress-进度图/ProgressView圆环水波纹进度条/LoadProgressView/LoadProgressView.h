//
//  LoadProgressView.h
//  ProgressView
//
//  Created by zhao on 16/9/18.
//  Copyright © 2016年 zhaoName. All rights reserved.
//  加载进度条

#import <UIKit/UIKit.h>

@interface LoadProgressView : UIView

@property (nonatomic, assign) CGFloat animationDuration; /**<动画持续时长*/
@property (nonatomic, assign) CGFloat progressWidth; /**< 进度条宽度*/
@property (nonatomic, strong) NSArray *progressColors; /**< 进度条颜色*/

/**
 *  添加通知 当程序重新进入前台或活跃状态，动画仍然会执行
 */
- (void)addNotificationObserver;

@end
