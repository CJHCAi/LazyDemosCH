//
//  HKMyFansViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyFansViewController.h"

@interface HKMyFansViewController ()

@end

@implementation HKMyFansViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的粉丝";
    self.type = FollowsFan_Fans;
    [self setNavItem];
}

@end
