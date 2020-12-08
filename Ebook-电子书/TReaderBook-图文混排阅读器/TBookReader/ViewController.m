//
//  ViewController.m
//  TBookReader
//
//  Created by tanyang on 16/1/21.
//  Copyright © 2016年 Tany. All rights reserved.
//

#import "ViewController.h"
#import "TReaderViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = YES;
}

- (IBAction)openBook:(UIButton *)sender {
    TReaderViewController *VC = [[TReaderViewController alloc]init];
    VC.style = sender.tag;
    [self.navigationController pushViewController:VC animated:YES];
}


@end
