//
//  HK_playOrderRefundVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//
//申请退款
#import "HK_playOrderRefundVc.h"

@interface HK_playOrderRefundVc ()

@end

@implementation HK_playOrderRefundVc

-(void)initNav {
    self.title =@"申请退款";
    [self setShowCustomerLeftItem:YES];

}

#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    
    
    
    
    
}



@end
