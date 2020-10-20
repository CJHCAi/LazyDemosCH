//
//  ViewController.m
//  YJYYCircleMenu
//
//  Created by 遇见远洋 on 17/1/2.
//  Copyright © 2017年 遇见远洋. All rights reserved.
//

#import "ViewController.h"
#import "YJYYCycleMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YJYYCycleMenu * menu = [YJYYCycleMenu cycleMenuWithTitles:@[@"导航",@"订咖啡",@"查资讯",@"萌萌哒"] menuWidth:60 center:self.view.center radius:100];
    [self.view addSubview:menu];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
