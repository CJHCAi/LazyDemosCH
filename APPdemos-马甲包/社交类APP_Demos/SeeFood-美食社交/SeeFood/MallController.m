//
//  MallController.m
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/30.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "MallController.h"
#import "PrefixHeader.pch"

@interface MallController () <UIWebViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation MallController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"SeeMall"];
    // Do any additional setup after loading the view.
    
    // 创建菊花
    self.activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(KScreenWidth - 30, KScreenHeight / 2, 30, 30)];
    self.activityView.hidesWhenStopped = YES;
    [self.activityView startAnimating];
    [self.view addSubview:_activityView];
    
    // 1.webView
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.xiachufang.com/page/ec-tab/?version=12"]];
    [_webView loadRequest:request];
    
}
- (IBAction)backAction:(id)sender {
    [_webView goBack];
}
- (IBAction)homeAction:(id)sender {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.xiachufang.com/page/ec-tab/?version=12"]];
    [_webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityView stopAnimating];
}

@end
