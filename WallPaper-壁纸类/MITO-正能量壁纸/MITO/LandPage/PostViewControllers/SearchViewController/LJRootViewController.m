//
//  LJRootViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/25.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJRootViewController.h"

@interface LJRootViewController ()

@end

@implementation LJRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor colorWithRed:45.0/255.0 green:170.0/255.0 blue:65.0/255.0 alpha:1];
    label.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = label;
}

- (void)setNavigationItemName:(NSString *)name addBackgroundImage:(NSString *)imageName addIsLeft:(BOOL)isLeft {

}

- (void)setNavigationBarTintColor:(UIColor *)color {
    [self.navigationController.navigationBar setTintColor:color];
}

@end
