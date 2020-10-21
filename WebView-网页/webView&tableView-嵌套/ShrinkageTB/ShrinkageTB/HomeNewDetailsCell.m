//
//  HomeNewDetailsCell.m
//  BasicFW
//
//  Created by xxlc on 2019/6/13.
//  Copyright © 2019 zyy. All rights reserved.
//

#import "HomeNewDetailsCell.h"


@interface HomeNewDetailsCell ()<UIWebViewDelegate ,WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate>
@property (nonatomic, copy) NSString *wkUrlStr;
/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) NSUInteger loadCount;



@end

@implementation HomeNewDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor blueColor];
        [self createView];
    }
    return self;
}

- (void)setUrlStr:(NSString *)urlStr{
    
    _wkUrlStr = urlStr;
    [self loadWebView];//加载链接
}

- (void)createView{
    self.progressView.hidden = NO;
    
    [self addSubview:self.progressView];
    [self addSubview:self.wkWebView];
    
}
#pragma mark -wkWebView
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.bounds];
        _wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _wkWebView.backgroundColor = [UIColor clearColor];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        _wkWebView.scrollView.delegate = self;
        _wkWebView.scrollView.scrollEnabled= NO;
    }
    return _wkWebView;
}
/**
 加载链接
 */
- (void)loadWebView {
    
    //! 解决iOS9.2以上黑边问题
    _wkWebView.opaque = NO;
    /*! 关闭多点触控 */
    _wkWebView.multipleTouchEnabled = YES;
    
    //添加进度条
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    NSString *encodeStr = [self.wkUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodeStr]];
    [_wkWebView loadRequest:request];
    
}
#pragma mark - 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        NSLog(@"%f",newprogress);
        if (newprogress < 1.0) {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }else{
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }
    }
}
#pragma mark - WKNavigationDelegate 【该代理提供的方法，可以用来追踪加载过程（页面开始加载、加载完成、加载失败）、决定是否执行跳转。】
#pragma mark 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    // 类似UIWebView的 -webViewDidStartLoad:
    NSLog(@"didStartProvisionalNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
#pragma mark 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    // 类似 UIWebView 的 －webViewDidFinishLoad:
    NSLog(@"didFinishNavigation");
//    self.navigationItem.title = webView.title;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //获取网页的高度
    Weakify(weakSelf);
    [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
//        _wkHeight = [result floatValue];
        weakSelf.gotoNextBtnBlock([result floatValue]);
        NSLog(@"html 的高度：%f", [result floatValue]);
    }];

    
}
#pragma mark 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    // 类似 UIWebView 的- webView:didFailLoadWithError:
    NSLog(@"didFailProvisionalNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark 在发送请求之前，决定是否跳转，如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"====%@",webView.URL.absoluteString);
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme containsString:@"app"]) {
        [self handleCustomAction:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);

}
#pragma mark - private method
- (void)handleCustomAction:(NSURL *)URL{
    NSLog(@"%@",URL);
}

#pragma mark - ***** UIWebViewDelegate
#pragma mark 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount
{
    _loadCount = loadCount;
    if (loadCount == 0)
    {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }
    else
    {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95)
        {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}
//禁止webivew放大缩小
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}
#pragma mark - 懒加载  Lazy Load
- (UIProgressView *)progressView{
    if (!_progressView) {
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        progressView.tintColor = RGBA(80, 140, 237, 1);
        progressView.trackTintColor = [UIColor clearColor];
        [self addSubview:progressView];
        self.progressView = progressView;
    }
    return _progressView;
}

#pragma mark - ***** dealloc 取消监听
- (void)dealloc{
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
