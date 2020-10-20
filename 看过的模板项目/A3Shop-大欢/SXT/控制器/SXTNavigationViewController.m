//
//  SXTNavigationViewController.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/17.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTNavigationViewController.h"

@interface SXTNavigationViewController ()

@end

@implementation SXTNavigationViewController

+ (void)initialize{
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav_backImage"] forBarMetrics:(UIBarMetricsDefault)];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count) {
        UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"详情界面返回按钮"] forState:(UIControlStateNormal)];
        [backBtn addTarget:self action:@selector(returnViewController) forControlEvents:(UIControlEventTouchUpInside)];
        backBtn.frame = CGRectMake(0, 0, 30, 30);
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        viewController.navigationItem.leftBarButtonItem = item;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)returnViewController{
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
