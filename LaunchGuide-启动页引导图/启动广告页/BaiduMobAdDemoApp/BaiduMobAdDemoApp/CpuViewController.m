//
//  CpuViewController.m
//  BaiduMobAdWebSdkSample
//
//  Created by JK.PENG on 16/5/4.
//
//

#import "CpuViewController.h"
#import "BaiduMobAdSDK/BaiduMobCpuInfoManager.h"

@interface CpuViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView   *webView;

@end

@implementation CpuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"内容联盟测试";
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;

    NSString *urlStr = [[BaiduMobCpuInfoManager shared] getCpuInfoUrlWithChannelId:@"1001" appId:@"d77e414"];
    if (urlStr) {
        NSURL  *url = [NSURL URLWithString:urlStr];
        [self.webView loadRequest:[NSMutableURLRequest requestWithURL:url]];
    }

}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

#pragma mark - getter
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
        if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)dealloc {
    _webView.delegate = nil;
    [_webView release];
    _webView = nil;
    [super dealloc];
}

@end
