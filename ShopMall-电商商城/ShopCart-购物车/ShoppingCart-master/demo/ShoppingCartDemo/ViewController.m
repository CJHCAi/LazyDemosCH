//
//  ViewController.m
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/3.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import "ViewController.h"
#import "ShoppingCartViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(kScreenWidth*0.5-40, kScreenHeight*0.5-20, 80, 40);
    [button setTitle:@"购物车" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goShoppintCart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)goShoppintCart:(UIButton *)sender {
    ShoppingCartViewController *shoppingCartVC = [[ShoppingCartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
