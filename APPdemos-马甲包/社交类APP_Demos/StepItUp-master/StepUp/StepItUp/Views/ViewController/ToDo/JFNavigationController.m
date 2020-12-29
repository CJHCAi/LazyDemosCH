//
//  JFNavigationController.m
//  StepUp
//
//  Created by syfll on 15/6/14.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import "JFNavigationController.h"

@interface JFNavigationController ()

@end

@implementation JFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航栏背景

    
    [self.navigationBar setBackgroundColor:[UIColor blackColor]];
    //[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"multiply_banner_01"] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"multiply_banner_01"] forBarMetrics:UIBarMetricsCompact];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
