//
//  ViewController.m
//  TreeLoadingDemo
//
//  Created by SongLan on 2017/2/21.
//  Copyright © 2017年 Asong. All rights reserved.
//

#import "ViewController.h"
#import "WSTreeLoadingView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"蚂蚁森林的loading效果";
    self.view.backgroundColor = [UIColor colorWithRed:57/255.0 green:190/255.0 blue:114/255.0 alpha:1];
    
    WSTreeLoadingView * myView = [[WSTreeLoadingView alloc]initWithFrame:CGRectMake(20, 100, 100, 120)];
    myView.center = self.view.center;
    [self.view addSubview:myView];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
