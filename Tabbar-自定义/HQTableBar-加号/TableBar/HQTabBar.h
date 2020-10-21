//
//  HQTabBar.h
//  TableBar
//
//  Created by HanQi on 16/8/9.
//  Copyright © 2016年 HanQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQTabBar;
@protocol HQTabBarDelegate <UITabBarDelegate>

- (void)hQTabBar:(HQTabBar *)tabBar btnDidClick:(UIButton *)button;

@end

@interface HQTabBar : UITabBar

- (instancetype)initWithFrame:(CGRect)frame tabBarSize:(int)size;

@property (nonatomic, weak) id <HQTabBarDelegate> delegate;

@end
