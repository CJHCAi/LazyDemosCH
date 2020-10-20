//
//  HomeViewController.m
//  仿抖音
//
//  Created by 七啸网络 on 2018/3/27.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    UIButton * pushButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [pushButton setTitle:@"push" forState:UIControlStateNormal];
    [pushButton setBackgroundColor:[UIColor redColor]];
    [pushButton addTarget:self action:@selector(pushToDouyinView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushButton];
    [pushButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(50);
    }];
    
}
-(void)pushToDouyinView{
    
    ViewController * douyinVC=[[ViewController alloc]init];

//    [self presentViewController:douyinVC animated:YES completion:nil];
    [self.navigationController pushViewController:douyinVC animated:YES];
}

@end
