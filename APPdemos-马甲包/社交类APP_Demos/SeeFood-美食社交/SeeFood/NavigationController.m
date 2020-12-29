//
//  NavigationController.m
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/26.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "NavigationController.h"
#import "PrefixHeader.pch"

@interface NavigationController ()
@property (nonatomic, strong) UILabel *myLable;
@property (nonatomic, strong) UIButton *myBackButton;
@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:0.937 green:0.290 blue:0.243 alpha:1.000]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}

// 因为所有的页面都会通过push出来 我们直接在这个方法里面创建我们的返回 按钮 这样 每个页面都会附带一个
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    // 创建返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"Safari Back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:button];
    // viewController就是每一个push出来的Controller
    viewController.navigationItem.leftBarButtonItem = back;
    
    // super一定要写 不然就失去push的功能了
    [super pushViewController:viewController animated:animated];
}

// 返回方法
- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
