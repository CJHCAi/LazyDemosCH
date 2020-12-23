//
//  ViewController.m
//  caculView_demo
//
//  Created by Liao PanPan on 2017/5/19.
//  Copyright © 2017年 Liao PanPan. All rights reserved.
//

#import "ViewController.h"
#import "PPCalculView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    PPCalculView *calView=[[PPCalculView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:calView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
