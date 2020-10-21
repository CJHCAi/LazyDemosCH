//
//  ViewController.m
//  YEXIGeTools
//
//  Created by Apple on 2019/4/2.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "ViewController.h"
#import "BGPayViewController.h"

//=======================================================================
//=======================================================================
//==========*** 求stars ***=============
//  https://github.com/muyang00
//=======================================================================
//=======================================================================


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *contentArr;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


//不足额，默认零钱+微信，  零钱+支付宝， 或者   微信、支付宝可选 二选一，  但是微信和支付宝不能同时选
//足额，零钱、微信、支付宝都可选    三选一

- (IBAction)payAction:(UIButton *)sender {
    
    BGPayViewController *payVC = [[BGPayViewController alloc]init];
    payVC.isEnoughPay = NO;
    [self.navigationController pushViewController:payVC animated:YES];
}


@end
