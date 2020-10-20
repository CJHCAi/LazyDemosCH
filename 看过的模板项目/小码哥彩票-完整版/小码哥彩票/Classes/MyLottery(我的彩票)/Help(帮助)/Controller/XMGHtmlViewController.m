//
//  XMGHtmlViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGHtmlViewController.h"

@interface XMGHtmlViewController ()<UIWebViewDelegate>

@end

@implementation XMGHtmlViewController

- (void)loadView
{
    // 自定义控制器的view
    self.view = [[UIWebView alloc] initWithFrame:XMGScreenBounds];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 取出webView加载网页
    UIWebView *webView = (UIWebView *)self.view;
    NSURL *url = [[NSBundle mainBundle] URLForResource:_htmlItem.html withExtension:nil];
    
    // 如果文件路径中有中文，转换成URL会失败，
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.delegate = self;
}
// webView加载完成的时候调用
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    NSString *javaStr = [NSString stringWithFormat:@"window.location.href = '#%@';",_htmlItem.ID];
    [webView stringByEvaluatingJavaScriptFromString:javaStr];
}
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
