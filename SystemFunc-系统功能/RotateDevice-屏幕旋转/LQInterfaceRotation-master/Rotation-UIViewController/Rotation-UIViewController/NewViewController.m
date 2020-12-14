//
//  NewViewController.m
//  Rotation-UIViewController
//
//  Created by Artron_LQQ on 2016/12/6.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "NewViewController.h"

@interface NewViewController ()

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 300, 200)];
    label.backgroundColor = [UIColor greenColor];
    label.numberOfLines = 0;
    label.text = @"这个demo演示的是, 当项目的跟视图是UIVIewController的情况, 只需要在跟视图重写方法:- (BOOL)shouldAutorotate 和 - (UIInterfaceOrientationMask)supportedInterfaceOrientations即可, 在这里返回是否需要旋转, 以及支持的朝向; 这里设置的是不能自动旋转";
    [self.view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 300, 100, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick:(UIButton *)button {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 设置为不可自动选择
- (BOOL)shouldAutorotate {
    
    return NO;
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
