//
//  TGNewVC.m
//  baisibudejie
//
//  Created by targetcloud on 2017/3/5.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

#import "TGNewVC.h"


@interface TGNewVC ()

@end

@implementation TGNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
}

- (void)setupNavBar{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(subTag)];
   // self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
     self.navigationItem.title = @"发现";
    
}

- (void)subTag{
   
}

@end
