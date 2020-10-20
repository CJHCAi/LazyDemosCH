//
//  YJYYCycleMenu.h
//  YJYYCircleMenu
//
//  Created by 遇见远洋 on 17/1/2.
//  Copyright © 2017年 遇见远洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJYYCycleMenu : UIView


/**
 快速实例化菜单

 @param titles 文本数组 数组个数多少就是多少个menu
 @param menuWidth 菜单item的高度 最好宽高相等
 @param center 中心点 围绕那个点抓圈
 @param radius 半径 选装半径
 */
+ (instancetype)cycleMenuWithTitles:(NSArray<NSString *> *)titles menuWidth:(CGFloat)menuWidth center:(CGPoint)center radius:(CGFloat)radius;

@end
