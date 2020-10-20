//
//  qqCenterViewController.m
//  QQ空间
//
//  Created by 妖精的尾巴 on 15-8-23.
//  Copyright (c) 2015年 妖精的尾巴. All rights reserved.
//

#import "qqCenterViewController.h"

@interface qqCenterViewController ()

- (IBAction)dismiss;

@end

@implementation qqCenterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)dealloc
{
    NSLog(@"用户销毁了模态视图控制器，返回应用中心了");
}
@end
