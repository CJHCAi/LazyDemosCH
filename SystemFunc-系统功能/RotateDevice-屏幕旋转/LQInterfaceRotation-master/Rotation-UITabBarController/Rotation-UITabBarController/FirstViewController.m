//
//  FirstViewController.m
//  Rotation-UITabBarController
//
//  Created by Artron_LQQ on 2016/12/6.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "FirstViewController.h"
#import "ThirdViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 300, 200)];
    label.backgroundColor = [UIColor greenColor];
    label.numberOfLines = 0;
    label.text =@"这个demo演示的是, 当项目的跟视图是UITabBarController的情况, 需要在跟视图重写方法:- (BOOL)shouldAutorotate 和 - (UIInterfaceOrientationMask)supportedInterfaceOrientations, 在这里返回是否需要旋转, 以及支持的朝向; 这里是以通知的形式来告诉跟视图, 是否需要自动旋转! ";
    [self.view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 300, 100, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"弹出视图" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)btnClick:(UIButton *)button {
    
    ThirdViewController *vc = [[ThirdViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 如果不是竖屏, 强制转为竖屏
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortrait) {
        [self orientationToPortrait:UIInterfaceOrientationPortrait];
    }
    
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        [self orientationToPortrait:UIInterfaceOrientationPortrait];
//    }
}
#pragma mark 强制转屏
// 当回到原来的视图时, 如果希望这个视图还是竖屏, 可强制旋转一下
//强制旋转屏幕
- (void)orientationToPortrait:(UIInterfaceOrientation)orientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];//前两个参数已被target和selector占用
    [invocation invoke];
    
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
