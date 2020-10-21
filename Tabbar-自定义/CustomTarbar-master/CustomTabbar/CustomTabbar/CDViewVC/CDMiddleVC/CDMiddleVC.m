//
//  CDMiddleVC.m
//  CustomTabbar
//
//  Created by Dong Chen on 2017/9/1.
//  Copyright © 2017年 Dong Chen. All rights reserved.
//

#import "CDMiddleVC.h"

@interface CDMiddleVC ()

@end

@implementation CDMiddleVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.frame = CGRectMake(0, 0, 12, 21);
    leftButton.adjustsImageWhenHighlighted = NO;
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"ev_nav_back"] forState:UIControlStateNormal];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = btn;
}

- (void)backAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
