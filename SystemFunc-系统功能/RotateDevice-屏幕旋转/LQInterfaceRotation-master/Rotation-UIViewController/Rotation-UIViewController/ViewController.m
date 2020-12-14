//
//  ViewController.m
//  Rotation-UIViewController
//
//  Created by Artron_LQQ on 2016/12/6.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "ViewController.h"
#import "NewViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 300, 200)];
    label.backgroundColor = [UIColor greenColor];
    label.numberOfLines = 0;
    label.text = @"这个demo演示的是, 当项目的跟视图是UIVIewController的情况, 只需要在跟视图重写方法:- (BOOL)shouldAutorotate 和 - (UIInterfaceOrientationMask)supportedInterfaceOrientations即可, 在这里返回是否需要旋转, 以及支持的朝向; 这里设置的是可以自动旋转, 以及支持所有的朝向";
    [self.view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 300, 100, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"弹出视图" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)btnClick:(UIButton *)button {
    
    NewViewController *new = [[NewViewController alloc]init];
    
    [self presentViewController:new animated:YES completion:nil];
}
- (BOOL)shouldAutorotate{
    
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
