//
//  YTNavController.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/2.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTNavController.h"

@interface YTNavController ()

@end

@implementation YTNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavAndTabBar];
}

- (void)setNavAndTabBar{
    //navBar
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"topline"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *titleAttr = @{
                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                };
    [self.navigationBar setTitleTextAttributes:titleAttr];
    //tabbar
    UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = image;
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} forState:UIControlStateSelected];
    
}

@end
