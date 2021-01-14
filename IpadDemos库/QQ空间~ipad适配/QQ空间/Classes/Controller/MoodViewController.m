//
//  MoodViewController.m
//  QQ空间
//
//  Created by xiaomage on 15/8/9.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MoodViewController.h"

@interface MoodViewController ()

@end

@implementation MoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置背景颜色
    self.view.backgroundColor = [UIColor yellowColor];
    
    // 2.设置title
    self.title = @"发表心情";
    
    // 3.设置左右的barbuttonItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(exit)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:nil action:nil];
}

- (void)exit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
