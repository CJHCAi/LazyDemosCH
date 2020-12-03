//
//  ViewController.m
//  EasyCalendarDemo
//
//  Created by YangTianCi on 2018/4/4.
//  Copyright © 2018年 www.YangTianCi.com. All rights reserved.
//

#import "ViewController.h"

#import "QBXCalenderFormHeaderView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    QBXCalenderFormHeaderView *header = [[QBXCalenderFormHeaderView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, 400)];
    [self.view addSubview:header];
    
}




@end
