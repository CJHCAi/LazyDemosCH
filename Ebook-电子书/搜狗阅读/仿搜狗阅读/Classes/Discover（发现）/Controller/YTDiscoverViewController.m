//
//  YTDiscoverViewController.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/2.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTDiscoverViewController.h"
#import "AppDelegate.h"
#import "YTSearchViewController.h"
@interface YTDiscoverViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *failImgView;
@property (weak, nonatomic) IBOutlet UILabel *failLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
- (IBAction)refreshBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *discoverWebView;
- (IBAction)searchBtnClick:(id)sender;
- (IBAction)iconBtnClick:(id)sender;

@end

@implementation YTDiscoverViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.failImgView.hidden = YES;
    self.failLabel.hidden = YES;
    self.refreshBtn.hidden = YES;
    
    self.discoverWebView.scrollView.bounces = NO;
    self.discoverWebView.delegate = self;
    [self discoverWebViewRequest];
}

- (void)discoverWebViewRequest{
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://k.sogou.com/abs/ios/v3/find"]];
    [self.discoverWebView loadRequest:request];
}

- (IBAction)searchBtnClick:(id)sender {
    [YTNavAnimation NavPushAnimation:self.navigationController.view];
    YTSearchViewController *searchVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"searchVC"];
    [[self navigationController]pushViewController:searchVC animated:NO];
}

- (IBAction)iconBtnClick:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}


- (IBAction)refreshBtnClick:(id)sender {
    [self discoverWebViewRequest];
}

#pragma mark - webview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = [NSString stringWithFormat:@"%@",request.URL];
    //如果点击书本详细信息，那么请求的url会比较长，判断长度来决定是否跳转到新界面
    if (urlStr.length > 40 ) {
        NSLog(@"NEW");
    }
    
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    [LBProgressHUD showHUDto:self.view animated:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.refreshBtn.hidden = YES;
    self.failImgView.hidden = YES;
    self.failLabel.hidden = YES;
    [LBProgressHUD hideAllHUDsForView:self.view animated:NO];

    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [LBProgressHUD hideAllHUDsForView:self.view animated:NO];
    self.failImgView.hidden = NO;
    self.failLabel.hidden = NO;
    self.refreshBtn.hidden = NO;
}
@end
