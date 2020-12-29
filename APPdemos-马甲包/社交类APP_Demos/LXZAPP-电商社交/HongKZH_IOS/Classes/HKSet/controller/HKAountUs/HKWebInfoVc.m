//
//  HKWebInfoVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKWebInfoVc.h"

@interface HKWebInfoVc ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView  *webView;

@end

@implementation HKWebInfoVc

-(UIWebView *)webView {
    if (!_webView) {
        _webView =[[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.backgroundColor =[UIColor whiteColor];
        _webView.delegate = self;
        NSString *resoure ;
        switch (self.webTitleIndex) {
            case  0:
                resoure =@"乐小转用户协议";
                break;
            case 1:
                resoure =@"乐小转隐私声明";
                break;
            case 2:
                resoure =@"乐小转商户合作协议";
                break;
            default:
                break;
        }
       NSString *path =[[NSBundle mainBundle] pathForResource:resoure ofType:@"docx"];
        _webView.scalesPageToFit =YES;
        NSURL *url = [NSURL fileURLWithPath:path];
      [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * navTitles;
    switch (self.webTitleIndex) {
        case  0:
            navTitles =@"用户协议";
            break;
        case 1:
            navTitles =@"隐私协议";
            break;
        case 2:
            navTitles =@"商户合作协议";
            break;
        default:
            break;
    }
    self.title = navTitles;
    self.showCustomerLeftItem = YES;
    [self.view addSubview:self.webView];
}
-(void)webViewDidStartLoad:(UIWebView *)webView {
    [Toast loading];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [Toast loaded];
}
@end
