//
//  FourViewController.m
//  Rotation-UITabBarController
//
//  Created by Artron_LQQ on 2016/12/6.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "FourViewController.h"

@interface FourViewController ()

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 300, 200)];
    label.backgroundColor = [UIColor greenColor];
    label.numberOfLines = 0;
    label.text = @"这个demo演示的是, 当项目的跟视图是UITabBarController的情况, 需要在跟视图重写方法:- (BOOL)shouldAutorotate 和 - (UIInterfaceOrientationMask)supportedInterfaceOrientations, 在这里返回是否需要旋转, 以及支持的朝向; 这里是以通知的形式来告诉跟视图, 是否需要自动旋转! ";
    [self.view addSubview:label];
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
