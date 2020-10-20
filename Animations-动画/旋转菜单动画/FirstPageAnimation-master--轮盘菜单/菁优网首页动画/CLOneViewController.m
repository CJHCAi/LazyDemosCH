//
//  BaseViewController.m
//  菁优网首页动画
//
//  Created by JackChen on 2016/12/13.
//  Copyright © 2016年 chenlin. All rights reserved.
//

#import "CLOneViewController.h"

@interface CLOneViewController ()

@end

@implementation CLOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏的文字颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithWhite:1.0 alpha:1.0]}];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.hidesBarsOnSwipe = YES;
  
     // 当导航栏的子控制器数量大于1的时候<已经push到另一个控制器>才设置导航栏左侧返回按钮
    if (self.navigationController.viewControllers.count > 1) {
        UIImage *image = [UIImage imageNamed:@"bar_back"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *imageItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
        self.navigationItem.leftBarButtonItem = imageItem;
    }
    
    // 导航栏的背景颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:111.0/ 255.0 green:182/ 255.0 blue:18/ 255.0 alpha:1.0]];
    
}

- (void)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 在测试的时候没有显示导航栏的时候可以使用这个方法使控制器返回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
 self.navigationController.navigationBar.hidden = NO;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
