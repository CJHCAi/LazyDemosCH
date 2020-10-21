# QZWebView
## WebView的简单封装 - 适用于原生App与h5交互

iOS 7使用UIWebView

iOS 8及以上系统使用WKWebView

使用方法：
导入QZWebView.m QZWebView.h

如果需要控制器还需导入QZWebViewViewController.m QZWebViewViewController.h

```
QZWebView *webView = [[QZWebView alloc] initWithFrame:self.view.bounds url:yoururl];
[self.view addSubview:webView];
```
或者
```
QZWebView *webView = [[QZWebView alloc] initWithFrame:self.view.bounds filePath:self.filePath];
[self.view addSubview:webView];
```

使用控制器例子：
```
QZWebViewViewController *vc = [[QZWebViewViewController alloc] initWithURL:@"https://www.baidu.com"];
[self.navigationController pushViewController:vc animated:true];
```
本地初始化就不写例子了，涉及到公司的项目的信息

如果iOS 9及以上系统访问失败，请检查是否开启了http访问的权限。

自定义需要修改的地方：
1、本地html文件所在的文件位置
  baseURL:本地html文件所在的文件夹

2、自定义的需要拦截的链接，进行与h5交互

WKWebView改：
```
/*
 在发送请求之前，决定是否跳转
 decisionHandler必须调用，来决定是否跳转，
 WKNavigationActionPolicyCancel取消跳转
 WKNavigationActionPolicyAllow 允许跳转
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    // 如果 targetFrame 的 mainFrame 属性为NO，表明这个 WKNavigationAction 将会新开一个页面。
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }

    // 对截获的URL进行自定义操作

    // 获取URL
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    // 把URL转成UTF8编码
    NSString *UTF8URL = [NSString stringWithString:[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    if ([UTF8URL rangeOfString:@"自定义"].length != 0) {

        // 被拦截，不允许跳转（进行自定义操作）

        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
```
UIWebView改：
```
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
```
