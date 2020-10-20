//
//  DeviceViewController.m
//  多语言切换demo
//
//  Created by 黄坚 on 2018/3/19.
//  Copyright © 2018年 黄坚. All rights reserved.
//

#import "DeviceViewController.h"

@interface DeviceViewController ()

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title= LanguageStr2(@"title_device", @"Home");
    
}



@end
