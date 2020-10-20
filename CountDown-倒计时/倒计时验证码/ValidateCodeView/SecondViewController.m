//
//  SecondViewController.m
//  ValidateCodeView
//
//  Created by zhuming on 16/3/11.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    // 延时 3S 后返回
    [self performSelector:@selector(back) withObject:nil afterDelay:3];
    
    // Do any additional setup after loading the view.
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
