//
//  LJMultiViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/29.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJMultiViewController.h"

@interface LJMultiViewController () {
    NSArray *_subTitles;        //子视图标题
    NSArray *_controllers;      //子视图控制器
}

@end

@implementation LJMultiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBase];
    [self setupUI];
}

- (void)setupBase{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"综合";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithColor:[UIColor whiteColor] highColor:[UIColor redColor] target:self action:@selector(cancel) title:@"取消"];
    [self.navigationController.navigationBar layoutIfNeeded];
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)setupUI {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [self.view addSubview:lineView];
    self.titleBarView = [[LJTitleBarView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44) addTitles:_subTitles];
    self.titleBarView.backgroundColor = [UIColor whiteColor];
    self.titleBarView.showsVerticalScrollIndicator = NO;
    self.titleBarView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.titleBarView];
    
    self.honrizontalVC = [[LJHonrizontalViewController alloc] initWithControllers:_controllers];
    self.honrizontalVC.view.frame = CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height - 104);
    [self addChildViewController:self.honrizontalVC];
    [self.view addSubview:self.honrizontalVC.view];
    
    //实现视图联动
    __weak typeof(self) weakSelf = self;
    self.titleBarView.block = ^(NSInteger index){
        [weakSelf.honrizontalVC scrollViewIndex:index];
    };
    self.honrizontalVC.block = ^(NSInteger index) {
        [weakSelf.titleBarView scrollViewIndex:index];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithSubTitles:(NSArray *)titles addControllers:(NSArray *)controllers {
    if (self = [super init]) {
        _subTitles = titles;
        _controllers = controllers;
    }
    return self;
}



@end
