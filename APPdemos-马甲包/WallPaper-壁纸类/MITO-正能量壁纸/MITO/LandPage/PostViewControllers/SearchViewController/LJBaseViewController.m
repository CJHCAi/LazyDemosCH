//
//  LJBaseViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/25.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJBaseViewController.h"
#import <RESideMenu.h>

@interface LJBaseViewController ()

@end

@implementation LJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationItemName:(NSString *)name addBackgroundImage:(NSString *)imageName addIsLeft:(BOOL)isLeft {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(siderButtonClicked:)];
}

- (void)siderButtonClicked:(UINavigationItem *)sender {
    [self presentLeftMenuViewController:nil];
}


@end
