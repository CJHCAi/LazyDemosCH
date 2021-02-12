//
//  ViewController.m
//  SYOC_HTML
//
//  Created by 666gps on 2017/7/17.
//  Copyright © 2017年 666gps. All rights reserved.
//

#import "ViewController.h"
//#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>{
    
}
@property (nonatomic,strong) WKWebView * wkWebView;
@property (nonatomic,strong) UIProgressView * progressView;/**<进度条*/
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatBaseUI];
}
#pragma mark - 创建基础控件
-(void)creatBaseUI{
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    configuration.userContentController = [WKUserContentController new];
    WKUserContentController * userContent = configuration.userContentController;
    //注册js要调用的方法名
    [userContent addScriptMessageHandler:self name:@"JS_OCAction"];
    [userContent addScriptMessageHandler:self name:@"JS_OCActionAndMessage"];
    
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height) configuration:configuration];
    _wkWebView.UIDelegate = self;
    _wkWebView.navigationDelegate = self;
    
    //显示本地html文件
    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"OC_THML" ofType:@"html"];
    NSURL * baseUrl = [[NSBundle mainBundle]bundleURL];
    [_wkWebView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:baseUrl];
    [self.view addSubview:_wkWebView];
    
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 2)];
    _progressView.trackTintColor = UIColorFromRGB(0xdddddd);
    _progressView.progressTintColor = UIColorFromRGB(0x17A846);
    [self.view addSubview:_progressView];
    
    //kvo 方式添加监听，显示进度条
    [_progressView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark - 在该方法里面进行与js的交互
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"JS_OCAction"]) {
        NSLog(@"收到js端端信息，但是没有带任何信息");
        
        //在这里返回给h5信息，也可以把下面代码单独提出来，放在一个事件中，这样手机端可以主动向h5发送信息
        [_wkWebView evaluateJavaScript:@"transferJSAction()" completionHandler:nil];
    }
    if ([message.name isEqualToString:@"JS_OCActionAndMessage"]) {
        NSLog(@"收到js端发送端信息。%@",message.body);
        
        //在这里返回给h5信息，也可以把下面代码单独提出来，放在一个事件中，这样手机端可以主动向h5发送信息
        //信息的格式可以是任何形式的，这里用字符串
        NSString * str = @"OC传递给h5的内容";
        NSString * sendMessage = [NSString stringWithFormat:@"transferJSActionAndMessage('%@')",str];
        [_wkWebView evaluateJavaScript:sendMessage completionHandler:nil];
    }
    
}
#pragma mark - kvo监听的方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        _progressView.progress = _wkWebView.estimatedProgress;
    }
    if (object == _wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (progress == 1) {
            _progressView.hidden = YES;
            [_progressView removeObserver:self forKeyPath:@"estimatedProgress"];
        }else{
            _progressView.hidden = NO;
            [_progressView setProgress:progress animated:YES];
        }
    }
}
#pragma mark - wkwebView delegate
//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"webview 开始加载");
}
//加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"webview 加载完成");
}
//加载失败
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"webview 加载失败");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
