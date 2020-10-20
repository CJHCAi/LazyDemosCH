//
//  ViewController.m
//  CFDynamicLabel
//
//  Created by 于 传峰 on 15/8/26.
//  Copyright (c) 2015年 于 传峰. All rights reserved.
//

#import "ViewController.h"
#import "CFDynamicLabel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CFDynamicLabel *testLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
   // CFDynamicLabel* testLabel = [[CFDynamicLabel alloc] initWithFrame:CGRectMake(100, 300, 180, 21)];
    
    self.testLabel.speed = 0.6;
    [self.view addSubview:self.testLabel];
    
    self.testLabel.text = @"我不想说再见,不说再见,越长大越孤单";
    self.testLabel.textColor = [UIColor yellowColor];
    self.testLabel.font = [UIFont systemFontOfSize:23];
    self.testLabel.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
