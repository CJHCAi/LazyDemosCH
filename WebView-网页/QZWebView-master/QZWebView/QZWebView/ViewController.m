//
//  ViewController.m
//  QZWebView
//
//  Created by 曲终叶落 on 2017/7/13.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import "ViewController.h"
#import "QZWebViewViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushAction:(UIButton *)sender {
    
    QZWebViewViewController *vc = [[QZWebViewViewController alloc] initWithURL:@"https://www.baidu.com"];
    [self.navigationController pushViewController:vc animated:true];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
