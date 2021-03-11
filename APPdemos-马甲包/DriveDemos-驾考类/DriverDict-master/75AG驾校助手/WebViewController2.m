//
//  WebViewController2.m
//  助驾宝典
//
//  Created by again on 16/5/13.
//  Copyright © 2016年 again. All rights reserved.
//

#import "WebViewController2.h"

@interface WebViewController2 ()
//@property (strong,nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong,nonatomic) UIBarButtonItem *backButton;
@property (strong,nonatomic) UIBarButtonItem *forWardButton;
@end

@implementation WebViewController2

//- (UIWebView *)webView{
//    if (self.webView ==nil) {
//        self.webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    }
//    return self.webView;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
//    webView.backgroundColor = [UIColor greenColor];
//    self.view.backgroundColor = [UIColor redColor];
    NSURL *url = [NSURL URLWithString:@"https://www.apple.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
