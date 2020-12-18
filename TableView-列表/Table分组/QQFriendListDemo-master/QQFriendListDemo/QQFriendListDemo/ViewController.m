//
//  ViewController.m
//  QQFriendListDemo
//
//  Created by 朱伟阁 on 2019/3/28.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import "ViewController.h"
#import "FriendListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"QQ好友列表" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 150, 50);
    btn.center = self.view.center;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(goQQ) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goQQ{
    FriendListViewController *friendlist = [[FriendListViewController alloc]init];
    [self presentViewController:friendlist animated:YES completion:nil];
}

@end
