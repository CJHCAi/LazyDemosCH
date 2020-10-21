# DPWebViewController

iOS 8以后，苹果推出了新框架Wekkit，提供了替换UIWebView的组件WKWebView。使用WKWebView，速度会更快，占用内存少。

WKWebView的特性：
在性能、稳定性、功能方面有很大提升，直观体现是内存占用变少；</br>
允许JavaScript的Nitro库加载并使用（UIWebView中限制）；</br>
支持了更多的HTML5特性；</br>
高达60fps的滚动刷新率以及内置手势；</br>
将UIWebViewDelegate与UIWebView重构成了14类与3个协议</br>


为了响应苹果的号召，我也做了一些改变不过是在适配iOS 8的基础上做的，以iOS 8为基准，8以前的继续用UIWebView，8以后用WKWebView节省内存。</br>

#用法

把自适配webView和wkwebView文件拖入项目中，导入DPWkWebViewController.h</br>
DPWkWebViewController *nextVC = [[DPWkWebViewController alloc] init];</br>
[nextVC loadWebURLSring:@"http://www.baidu.com"];</br>
[self.navigationController pushViewController:nextVC animated:YES];</br>
