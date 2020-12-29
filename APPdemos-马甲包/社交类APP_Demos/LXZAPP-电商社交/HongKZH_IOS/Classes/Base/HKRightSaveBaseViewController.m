//
//  HKRightSaveBaseViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRightSaveBaseViewController.h"

@interface HKRightSaveBaseViewController ()

@end

@implementation HKRightSaveBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBtn];
}
-(void)setRightBtn{
    UIButton*btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [btn setTitle:@"保存" forState:0];
    [btn setTitleColor:[UIColor colorWithRed:64.0/255.0 green:144.0/255.0 blue:247.0/255.0 alpha:1] forState:0];
    [btn addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
-(void)saveData{}

@end
