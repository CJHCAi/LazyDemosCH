//
//  ViewController.m
//  ProductDetailPage
//
//  Created by 方绍晟 on 2018/8/13.
//  Copyright © 2018年 fss_someThing. All rights reserved.
//

#import "ViewController.h"
#import "ZHBGoodDetailViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (IBAction)btnClick:(id)sender {
 
    ZHBGoodDetailViewController *vc = [[ZHBGoodDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
