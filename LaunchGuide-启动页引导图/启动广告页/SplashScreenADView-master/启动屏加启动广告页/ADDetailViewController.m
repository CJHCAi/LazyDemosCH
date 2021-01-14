//
//  ADDetailViewController.m
//  启动屏加启动广告页
//
//  Created by WOSHIPM on 16/8/29.
//  Copyright © 2016年 WOSHIPM. All rights reserved.
//

#import "ADDetailViewController.h"

@interface ADDetailViewController ()<UIWebViewDelegate>
@property(nonatomic, strong)UIWebView *webView;
@end

@implementation ADDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"广告详情页";
    self.navigationController.navigationBar.translucent = NO;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    [_webView setScalesPageToFit:NO];
    [self.view addSubview:_webView];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSURL *url = [NSURL URLWithString:_URLString];
        
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
        });
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
