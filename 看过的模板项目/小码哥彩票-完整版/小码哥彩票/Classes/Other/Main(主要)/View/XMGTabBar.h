//
//  XMGTabBar.h
//  小码哥彩票
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//  模仿下UITabBar
// UITabBar里面的按钮由UITabBarController的子控制器

#import <UIKit/UIKit.h>

@class XMGTabBar;
@protocol XMGTabBarDelegate <NSObject>

@optional
- (void)tabBar:(XMGTabBar *)tabBar didClickBtn:(NSInteger)index;

@end

@interface XMGTabBar : UIView

// 模型数组(UITabBarItem)
@property (nonatomic, strong) NSArray *items;


@property (nonatomic, weak) id<XMGTabBarDelegate> delegate;
 //@property (nonatomic, assign) int itemCount;

@end
