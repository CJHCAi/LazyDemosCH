# MYZWebHybrid
网页与 iOS 原生混合开发实例

<br>
网页与 iOS 原生相互通信、传值，实现的功能： <br>   
1、打开、关闭 WebView  <br>
2、通过系统相机、相册获取图片传递给网页  <br>
3、保存、获取本地数据   <br>
4、网页调用原生打电话  <br>

<br>
<br>

![home_page](https://github.com/MA806P/MYZWebHybrid/blob/master/Screenshot/WebView.png)


JS 相关代码：
```
function CallApp(name, params, callback) {
        if (params == null) {
            params = {}
        }
        let data = {
            name: name,
            params: params,
            callback: null
        };
        if (callback != null) {
            var callback_name = 'C' + Math.random().toString(36).substr(2);
            window[callback_name] = function(obj) {
                callback(obj);
                delete window[callback_name]
            };
            data.callback = callback_name
        }
        //Android.call(JSON.stringify(data));
        //alert(JSON.stringify(data))
        window.webkit.messageHandlers.call.postMessage(JSON.stringify(data));
    };
```
<br>
OC 相关代码：

```
WKUserContentController *userCC = self.webView.configuration.userContentController;
[userCC addScriptMessageHandler:self name:@"call"];
```

<br>

```
#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@",message.body);
    
    if ([message.name isEqualToString:@"call"]) {
        NSString *messageJson = [NSString stringWithFormat:@"%@", message.body];
        
    }
}

-(void)removeAllScriptMsgHandle{
    WKUserContentController *controller = self.webView.configuration.userContentController;
    [controller removeScriptMessageHandlerForName:@"call"];
}
```
