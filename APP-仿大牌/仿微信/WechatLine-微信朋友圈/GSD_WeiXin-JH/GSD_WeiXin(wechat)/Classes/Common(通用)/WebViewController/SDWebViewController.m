//
//  SDWebViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/16.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDWebViewController.h"

@interface SDWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation SDWebViewController

+ (instancetype)webViewControllerWithUrlString:(NSString *)urlString
{
    SDWebViewController *vc = [SDWebViewController new];
    vc.urlString = urlString;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [UIWebView new];
    self.webView.frame = self.view.bounds;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}


@end
