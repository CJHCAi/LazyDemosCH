//
//  ViewController.m
//  JGProgressDemo
//
//  Created by 郭军 on 2017/9/1.
//  Copyright © 2017年 ZJBL. All rights reserved.
//

#import "ViewController.h"
#import "JGProgressView.h"

//尺寸
#define kDeviceHight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *Lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 80, 30)];
    Lbl.text = @"车位数436";
    Lbl.font = [UIFont systemFontOfSize:13];
    Lbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:Lbl];
    
    
    JGProgressView *PV = [[JGProgressView alloc] initWithFrame:CGRectMake(100, 200, kDeviceWidth - 130, 30)];
    PV.progress = 0.8;
    
    [self.view addSubview:PV];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
