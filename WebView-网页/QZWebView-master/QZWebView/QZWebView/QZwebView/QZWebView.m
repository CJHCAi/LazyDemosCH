//
//  QZWebView.m
//  QZWebView
//
//  Created by 曲终叶落 on 2017/7/13.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import "QZWebView.h"
#import <WebKit/WebKit.h>


/*-------------------- 系统版本 --------------------*/
/**
 iOS 7
 */
#define TARGET_iOS7 [[UIDevice currentDevice].systemVersion doubleValue] < 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] >= 7.0

/**
 iOS 8
 */
#define TARGET_iOS8 [[UIDevice currentDevice].systemVersion doubleValue] < 9.0 && [[UIDevice currentDevice].systemVersion doubleValue] >= 8.0

/**
 iOS 8及iOS 8以后的系统
 */
#define TARGET_iOS8Later [[UIDevice currentDevice].systemVersion doubleValue] >= 8.0

/**
 iOS 9及iOS9以后的系统
 */
#define TARGET_iOS9Later [[UIDevice currentDevice].systemVersion doubleValue] >= 9.0

// 加载模式
typedef enum{
    // 在线
    LoadRequest,
    // 本地HTML
    LoadHTML
    
}QZWebViewLoadType;

@interface QZWebView () <UIWebViewDelegate,UIActionSheetDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler,WKUIDelegate>

@property (nonatomic,strong) UIWebView *uiWebView;
@property (nonatomic,strong) WKWebView *wkWebView;
/**
 加载模式
 */
@property (nonatomic, assign) QZWebViewLoadType loadType;

/**
 URL：可能是本地链接、在线链接
 */
@property (nonatomic, copy ) NSURL *url;

@end

@implementation QZWebView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url{
    if (self = [super initWithFrame:frame]) {
        _url = [NSURL URLWithString:url];
        _loadType = LoadRequest;
        [self loadData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame filePath:(NSString *)filePath{
    if (self = [super initWithFrame:frame]) {
        _url = [NSURL fileURLWithPath:filePath];
        _loadType = LoadHTML;
        [self loadData];
    }
    return self;
}

/**
 开始加载在线数据或者加载本地html文件
 */
- (void)loadData{
    switch (_loadType) {
        case LoadRequest:{
            // 在线链接
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
            if (TARGET_iOS8Later) {
                [self.wkWebView loadRequest:request];
            }else{
                [self.uiWebView loadRequest:request];
            }
        }
            break;
            
        default:{
            // 加载本地文件 ()
            
            // 本地文件所在的文件夹位置
            // NSString *baseURL = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"web"];
            NSString *baseURL = @"";
            // 获取本地html的信息
            NSString *html = [NSString stringWithContentsOfURL:_url encoding:NSUTF8StringEncoding error:nil];
            
            if (TARGET_iOS7) {
                
                [self.uiWebView loadHTMLString:html baseURL:[NSURL fileURLWithPath:baseURL]];
                
            }else if (TARGET_iOS9Later){
                
                [self.wkWebView loadHTMLString:html baseURL:[NSURL fileURLWithPath:baseURL]];
                
            }else{
                /*
                 在iOS8系统中，WKWebView使用loadHTMLString会出现不加载CSS和JS的问题
                 应使用loadRequest加载
                 
                 另外WKWebView在iOS 8是不能加载NSBundle、NSHomeDirectory等位置的文件，只能加载NSTemporaryDirectory的文件，所以需要把本地文件复制到NSTemporaryDirectory里面
                 */
                // [self copyWebToTemp];
                // NSString *webpath = [NSTemporaryDirectory() stringByAppendingString:@"web"];
                NSString *webpath = @"";
                
                NSString *path = [NSString stringWithFormat:@"%@/%@",webpath,_url.lastPathComponent];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
                
                [self.wkWebView loadRequest:request];
            }
        }
            break;
    }
}

#pragma mark - 处理json数据

/**
 加载JSON数据(需要在webView加载完成后使用)
 
 @param json json数据
 */
- (void)loadingWithJSON:(NSString *)json{
    if (TARGET_iOS8Later) {
        [self.wkWebView evaluateJavaScript:json completionHandler:^(id item, NSError * _Nullable error) {
            // Block中处理是否通过了或者执行JS错误的代码
            NSLog(@"%@",item);
            NSLog(@"%@",error);
        }];
    }else{
        [self.uiWebView stringByEvaluatingJavaScriptFromString:json];
    }
}

#pragma mark - WKWebView代理

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigatio{
    if ([self.deleget respondsToSelector:@selector(didStartProvisional)]) {
        [self.deleget didStartProvisional];
    }
}

// 开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    if ([self.deleget respondsToSelector:@selector(didCommit)]) {
        [self.deleget didCommit];
    }
}

// 页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    if ([self.deleget respondsToSelector:@selector(didFinish)]) {
        [self.deleget didFinish];
    }
}

// 页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    if ([self.deleget respondsToSelector:@selector(didFailProvisional)]) {
        [self.deleget didFailProvisional];
    }
    
}

// 接收到服务器跳转请求之后调用 (服务器端redirect)，不一定调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

/*
 在收到服务器的响应头，根据response相关信息，决定是否跳转。
 decisionHandler必须调用，来决定是否跳转，
 WKNavigationResponsePolicyCancel取消跳转
 WKNavigationResponsePolicyAllow 允许跳转
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/*
 在发送请求之前，决定是否跳转
 decisionHandler必须调用，来决定是否跳转，
 WKNavigationActionPolicyCancel取消跳转
 WKNavigationActionPolicyAllow 允许跳转
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// web界面中有弹出警告框时调用
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{

    NSLog(@"%@",message);
}

-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
}

// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}


#pragma mark - UIWebView代理
// 开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView{
    if ([self.deleget respondsToSelector:@selector(didStartProvisional)]) {
        [self.deleget didStartProvisional];
    }
}

// 加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([self.deleget respondsToSelector:@selector(didFinish)]) {
        [self.deleget didFinish];
    }
    
    // 获取title
    if ([self.deleget respondsToSelector:@selector(webViewTitle:)]) {
        NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [self.deleget webViewTitle:title];
    }
    
}

// 加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if ([self.deleget respondsToSelector:@selector(didFailProvisional)]) {
        [self.deleget didFailProvisional];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    // 获取URL
    NSString *urlString = [[request URL] absoluteString];
    // 把URL转成UTF8编码
    NSString *UTF8URL = [NSString stringWithString:[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([UTF8URL rangeOfString:@"自定义"].length != 0) {
        
        // 被拦截，不允许跳转（进行自定义操作）
        
        return NO;
    }else{
        // 允许跳转
        return YES;
    }
    
}

#pragma mark - scrollView代理
/**
 *  解决iOS9系统bug
 *
 *  在iOS9系统中使用WKWebView时，滚动的时候缺少惯性，滚动幅度小，使用此方法可解决
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.deleget respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.deleget scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if ([self.deleget respondsToSelector:@selector(scrollViewWillEndDragging)]) {
        [self.deleget scrollViewWillEndDragging];
    }
}

#pragma mark - dealloc
- (void)dealloc{
    if (TARGET_iOS8Later) {
        // 不把wkWebView.scrollView.delegate 置为空在模拟器上会出现奔溃现象
        self.wkWebView.scrollView.delegate = nil;
        [self.wkWebView removeObserver:self forKeyPath:@"title"];
    }else{
        self.uiWebView.scrollView.delegate = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"webView已被释放");
}

#pragma mark - KVO

// 设置iOS 8及以上的标题
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.wkWebView) {
            // 此处可以获取到标题信息
            NSLog(@"%@",self.wkWebView.title);

            if ([self.deleget respondsToSelector:@selector(webViewTitle:)]) {
                [self.deleget webViewTitle:self.wkWebView.title];
            }
            
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - get and set
- (UIWebView *)uiWebView{
    if (!_uiWebView) {
        
        UIWebView *web = [[UIWebView alloc] initWithFrame:self.bounds];
        web.delegate = self;
        
        // YES 加载网页中的电话号码，单击可以拨打
        web.dataDetectorTypes = NO;
        // 适应屏幕
        web.scalesPageToFit = YES;
        
        web.backgroundColor = [UIColor whiteColor];
        web.multipleTouchEnabled = true;
        web.scrollView.delegate = self;
        web.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;

        [self addSubview:web];
        
        _uiWebView = web;
    }
    return _uiWebView;
}

- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:self.bounds];
        wkWebView.UIDelegate = self;
        wkWebView.navigationDelegate = self;
        wkWebView.backgroundColor = [UIColor whiteColor];
        /*! 解决iOS9.2以上黑边问题 */
        wkWebView.opaque = false;
        wkWebView.multipleTouchEnabled = true;
        wkWebView.scrollView.delegate = self;
        wkWebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;

        [wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        
        [self addSubview:wkWebView];
        _wkWebView = wkWebView;
        
    }
    return _wkWebView;
}



@end
