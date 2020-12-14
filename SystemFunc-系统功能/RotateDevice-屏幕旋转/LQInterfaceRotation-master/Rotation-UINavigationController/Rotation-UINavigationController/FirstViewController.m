//
//  FirstViewController.m
//  Rotation-Navigation
//
//  Created by Artron_LQQ on 16/4/6.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 300, 200)];
    label.backgroundColor = [UIColor greenColor];
    label.numberOfLines = 0;
    label.text = @"这个demo演示的是, 当项目的跟视图是UINavigationController的第一种情况, 需要在想要改变的视图重写方法:- (BOOL)shouldAutorotate 和 - (UIInterfaceOrientationMask)supportedInterfaceOrientations, 在这里返回是否需要旋转, 以及支持的朝向; 这里设置的是不能自动旋转";
    [self.view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 300, 100, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"弹出视图" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)btnClick:(UIButton *)button {
    
    SecondViewController *vc = [[SecondViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
