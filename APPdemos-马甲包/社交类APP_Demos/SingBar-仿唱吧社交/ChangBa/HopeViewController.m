//
//  HopeViewController.m
//  ChangBa
//
//  Created by V.Valentino on 16/10/1.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "HopeViewController.h"
#import <MBProgressHUD.h>

@interface HopeViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation HopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多功能敬请期待！";
    //    代码创建webView
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"http://www.1ting.com/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //开始加载请求会执行此方法 返回值来决定是否允许访问
    NSString *path = [request.URL description];
    NSLog(@"%@",path);
    //    if ([path containsString:@"baidu"]) {
    //        return YES;
    //    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    //菊花开始
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.label.text = @"正在加载界面";
//    self.hud = hud;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //菊花结束
//    [self.hud hideAnimated:YES];
}
@end
