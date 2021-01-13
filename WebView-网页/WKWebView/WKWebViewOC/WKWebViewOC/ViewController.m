//
//  ViewController.m
//  WKWebViewOC
//
//  Created by XiaoFeng on 2017/1/5.
//  Copyright © 2017年 XiaoFeng. All rights reserved.
//  QQ群: 384089763 欢迎加入
//  github链接: https://github.com/XFIOSXiaoFeng/WKWebView

#import "ViewController.h"
#import "WKWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}




- (IBAction)loadingAction:(UIButton *)sender {
    WKWebViewController *web = [[WKWebViewController alloc] init];
//    [web loadWebURLSring:@"https://www.baidu.com"];
    [web loadWebURLSring:@"http://detail.qulu.net.cn/#/?url=taobao&isShare=1&goodsId=620948184145&token=JWT 442bb7ec-1c8b-40b6-95e0-f90a07932e89"];
    [self.navigationController pushViewController:web animated:YES];
}

@end
