//
//  ViewController.m
//  TextView
//
//  Created by 初程程 on 2017/7/6.
//  Copyright © 2017年 初程程. All rights reserved.
//

#import "ViewController.h"
#import "UITextView+Placeholder.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textFiled = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, 300, 100)];
    textFiled.layer.borderWidth = 0.5;
    textFiled.layer.borderColor = [UIColor grayColor].CGColor;
    textFiled.placeholder = @"请输入您的意见反馈";
    textFiled.placeholderAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1]};
    textFiled.maxInputLength = 30;
    [self.view addSubview:textFiled];
    NSLog(@"%@",textFiled.placeholder);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
