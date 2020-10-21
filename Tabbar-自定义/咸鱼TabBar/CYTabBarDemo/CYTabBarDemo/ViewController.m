//
//  ViewController.m
//  CYTabBarDemo
//
//  Created by 张春雨 on 2017/3/12.
//  Copyright © 2017年 张春雨. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "CYTabBarController.h"
#import "AppDelegate.h"

@interface ViewController ()<UITableViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigation];
    [self initButtons];
    
    self.tabBarItem.badgeValue = @"1";
}

#pragma mark - 跳转页面
- (void)btnClick{
    ViewController *vc = [ViewController new];
    vc.view.backgroundColor = [UIColor grayColor];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 设置导航
- (void)initNavigation{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = self.tabBarItem.title;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 设置功能按钮
- (void)initButtons{
    UIButton *btn  = [[UIButton alloc]initWithFrame:CGRectMake(0 ,0 ,150 ,30)];
    btn.center = self.view.center;
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


@end
