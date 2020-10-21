//
//  HomePageViewController.m
//  WaterMarker
//
//  Created by JSB - Leidong on 16/10/20.
//  Copyright © 2016年 JSB - leidong. All rights reserved.
//

#import "HomePageViewController.h"
#import "VideoHandleViewController.h"

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createBtn];
}
//
-(void)createBtn{

    UIButton *wmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    wmBtn.backgroundColor = [UIColor orangeColor];
    [wmBtn setTitle:@"视频处理" forState:UIControlStateNormal];
    [wmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [wmBtn addTarget:self action:@selector(watermarkAction:) forControlEvents:UIControlEventTouchUpInside];
    wmBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:wmBtn];
    [wmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 56));
    }];
}
//
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    //状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
//
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    //状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - 各种事件
#pragma mark -
//
- (void)watermarkAction:(UIButton *)sender {
    
    VideoHandleViewController *ctl = [VideoHandleViewController new];
    
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
