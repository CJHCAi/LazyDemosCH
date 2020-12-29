//
//  TGPostWordVC.m
//  baisibudejie
//
//  Created by targetcloud on 2017/5/21.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

#import "TGPostWordVC.h"


@interface TGPostWordVC ()
@end

@implementation TGPostWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBase];
   
}

- (void)setupBase{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"搜索";
   
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithColor:[UIColor whiteColor] highColor:[UIColor redColor] target:self action:@selector(cancel) title:@"取消"];
    [self.navigationController.navigationBar layoutIfNeeded];
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationItem.rightBarButtonItem.enabled = NO;
   
}

@end
