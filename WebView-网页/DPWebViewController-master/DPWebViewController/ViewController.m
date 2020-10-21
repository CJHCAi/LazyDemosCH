//
//  ViewController.m
//  DPWebViewController
//
//  Created by dp on 17/5/24.
//  Copyright © 2017年 dp. All rights reserved.
//

#import "ViewController.h"
#import "DPWkWebViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [btn setTitle:@"点我" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)btnDidClick{
    DPWkWebViewController *nextVC = [[DPWkWebViewController alloc] init];

    [nextVC loadWebURLSring:@"http://www.baidu.com"];
    
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
