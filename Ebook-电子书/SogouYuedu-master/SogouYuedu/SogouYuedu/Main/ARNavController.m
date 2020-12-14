//
//  ARNavController.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/27.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARNavController.h"

@interface ARNavController ()

@end

@implementation ARNavController

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
