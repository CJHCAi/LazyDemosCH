# DesktopIcon
iOS开发 App内部功能在桌面生成快捷方式演示demo

> 参考文章:
> 1. [在桌面生成快捷方式（1)](https://www.jianshu.com/p/2ce3bd3ab6f9)
> 2. [在桌面生成快捷方式（2)](https://www.jianshu.com/p/84858da721ea) 

#### 1. 效果展示GIF图(图片有点大,可能加载有点慢)
![示例.gif](https://upload-images.jianshu.io/upload_images/3096223-1bd4bd3be5f0e718.gif?imageMogr2/auto-orient/strip)
#### 2. 前言
1. 因为一直用的是三方浏览器,基本没怎么用手机自带的Safari.所以一直不晓得系统还有这个功能呐 -_-!.
2. 在一次偶然使用支付宝小程序的时候,发现支付宝可以借助Safari让小程序在手机桌面生成快捷图标.下次想使用该小程序的时候,直接点桌面上的icon就可以直接进入支付宝并自动跳转到对应的小程序界面.真的是很方便有木有.
3. 一方面出于好奇,另一方面想给自己做点技术储备.决定抽空研究一下这个功能是怎么实现的.所以便有了这篇笔记.

#### 3. 实现流程
![流程图.png](https://upload-images.jianshu.io/upload_images/3096223-6a60cba4b4994510.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
从流程图来看,核心步骤就是step3 到 step4之间的实现.至于如何通过scheme来打开App不是本章重点.如果你不清楚的话,请自行充电.通过Safari添加到桌面功能其实就是把当前打开的站点生成快捷图标放到桌面上.所以关键点其实是这个站点网页的开发.客户端的原生代码量并没有多少.翻阅了一下网上的资料,了解到的实现方式有以下三种:
1. 编写一个网页,并存放在服务端.客户端请求网页地址.
2. 编写两个网页通过设置data url方式,一个内容展示网页放在客户端;一个过渡网页,放在服务端.
3. 在APP内嵌HTTPServer.这种方式所有的操作都在客户端.

##### 3.1 第一种实现方式
由于鄙人只是略懂前端代码,不是熟练.这里是从别人那里拷贝过来稍微修改了一下.刚好最近在自学java后端.所以我建了个本地服务器.将网页放在了服务端.
```
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <!--定义应用全屏展示的-->
        
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <!--设置状态栏的属性值，只有在定义了 apple-mobile-web-app-capable的前提下才有效。-->
        
        <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no" />
        <!--width用于指定宽度，initial-scale指定初始化的缩略比例，minimum-scale指定缩小的比例，而maximum-scale则是放大的比例，当然这些缩放都取决于user-scalable——决定用户是否能缩放页面。-->
       
        <link rel="apple-touch-icon" href="image/WechatIMG121.png">
        <!-- 快捷方式的图标，有两种属性值apple-touch-icon和apple-touch-icon-precomposed，区别就在于是否会应用iOS中自动给图标添加的那层高光。-->
        
        <title>小功能一</title>
        <!-- 这个title将会是桌面快捷方式的默认标题，在生成时可以手动修改 -->
    </head>
    <body>
        <!-- href后的链接是APP对外开放的scheme，只有scheme与APP中设置的一致，才能打开APP，
         而scheme后面的值可以作为打开APP后的特殊操作，如果仅仅是打开，后面随便写就行，APP中不进行处理即可 -->
        <a href="CWDesktop://desktopIconClick/open/jump?iconCode=1&title=小功能一" id="qbt" style="display:none"></a>
        <span id="msg">将要跳转到App...</span>
    </body>
    <script>
        if (window.navigator.standalone == true) 
        {
            var lnk = document.getElementById("qbt").click();
        } 
        else 
        {
            document.getElementById("msg").innerHTML='<center>添加到桌面快捷方式</center><center style="position:absolute;bottom:1px;left:1px;right:1px"><img style="width:320px" src="image/guide.png" /><center>';
        }
    </script>
</html>
```
因为demo中我模拟了三个功能模块.因为不太会前端,所以我为每一个功能模块分别写了一个文件.里面的内容其实都是一样的.只有红框的部分数据不一样.如图:
![图一.png](https://upload-images.jianshu.io/upload_images/3096223-9f63caa0183a8d67.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
到此服务器端就弄完了.接下来写iOS移动端代码.
```
/// 过度网页放在服务端
- (void)startServer1 {
    /*
     这种方式所有处理都在服务端网页上
     App基本不需要写多余的代码.直接跳转到指定的引导url地址就可以了.
     缺点就是这种方式添加的桌面快捷方式,在没网的情况下,用户点击桌面上的快捷图标是不能跳转到app里面来的
     */
    NSString *baseUrl = @"http://172.16.1.72:8080/iOS-Desktop/index";
    NSString *urlStrWithPort = [NSString stringWithFormat:@"%@%ld.jsp", baseUrl, self.model.code];
    [self openUrl:[NSURL URLWithString:urlStrWithPort]];
}

- (void)openUrl:(NSURL *)url {
    if (!url) { return; }
   
    if (@available(iOS 10.0, *))
    {
        [[UIApplication sharedApplication] openURL:url
                                           options:@{}
                                 completionHandler:nil];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}
```
* 移动端代码很简单,根据不同的功能模块open对应的url就好了.
* 按照上面的步骤来.添加桌面快捷方式就成功了.这是你会发现桌面多了一个快捷图标.点击的话就会跳到App中来.(前提是你的scheme设置了).
* 不过美中不足的是:当处于无网络状态时,点击快捷图标是不能跳转到App中来的.因为没网就访问不了网页.但是我发现支付宝生成的快捷图标却不受网络限制.他是如何实现的并不清楚.不过通过方式二可以解决没网这种情况.

##### 3.2 第二种实现方式
* 首先我们需要编写一个内容展示html放在移动端.里面的内容和方式一网页的内容是一样的.唯一的不同一些动态数据不能写死(比如:网页标题, 生成桌面快捷图标, 图标点击后传到App中的url字符串内容等).而是用我们自己定义的关键字来替代.
![图二.png](https://upload-images.jianshu.io/upload_images/3096223-451aea5de7cd9d7b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
图中的红框部分使用的就是自定义的关键字.这样到时候就能通过代码动态修改网页中的内容.为了保持读取的效率,所以把所有的注释也删掉了.
代码如下:
```
<!DOCTYPE html>
<html>
    <head>
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <meta content="text/html charset=UTF-8" http-equiv="Content-Type">
        <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
        <link rel="apple-touch-icon" href="IconImageString">
        <title>Title</title>
        </head>
    <body>
        <a href="Operation" id="qbt" style="display:none"></a>
        <span id="msg"></span>
    </body>
    <script>
        if (window.navigator.standalone == true) {
            document.getElementById("qbt").click();
        } else {
            document.getElementById("msg").innerHTML='<center>添加到桌面快捷方式</center><center style="position:absolute;bottom:1px;left:1px;right:1px"><img style="width:320px" src="ImageString" /></center>';
        }
    </script>
</html>
```
* 接下来就是写一个过渡网页放在服务端,代码如下:
```
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta content="text/html charset=UTF-8" http-equiv="Content-Type" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no" />
    <title></title>
</head>
<body>
</body>
<script>
<!-- 这里面是本页面最核心的，可以根据需要在此处设置图片、标题等，如果使用第二种方式，可以在此处调用数据解析的方法，然后进行页面替换 -->
    var url = location.search;
    url = url.replace("?dataurl=", "");
    window.location.replace(url)
</script>
</html>
```
* 这样网页相关部分我们就搞定了,接下来是写iOS移动端代码.这次移动端代码量就稍微多了些.
核心代码:
```
- (void)startServer2 {
    //1.将需要添加到桌面快捷的icon base64编码
    NSString *iconDataString = [self base64StringFromPNGImageName:@"demo.png"];
    NSString *iconString = [NSString stringWithFormat:@"data:image/png;base64,%@", iconDataString];
    
    // 2.引导图:放在服务端, 引导图地址
    NSString *imgUrlString = @"http://172.16.1.72:8080/iOS-Desktop/image/guide.png";
   
    // 3.读取本地网页html
    NSString *htmlContent = [self readLocalHtmlContent:@"index.html"];
    htmlContent = [self replaceKeywordFromHtmlContent:htmlContent iconString:iconString imgUrlString:imgUrlString];
    NSString *urlString = @"http://172.16.1.72:8080/iOS-Desktop/index.jsp?dataurl=";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", urlString, htmlContent]];
    
     // 4.打开
    [self openUrl:url];
}
```
下面来将上面代码分解一下:
1. 先加载桌面快捷图标,并base64编码:
```
NSString *iconDataString = [self base64StringFromPNGImageName:@"demo.png"];
NSString *iconString = [NSString stringWithFormat:@"data:image/png;base64,%@", iconDataString];

- (NSString *)base64StringFromPNGImageName:(NSString *)imgName {
    UIImage *image = [UIImage imageNamed:imgName];
    NSData *imgData = UIImagePNGRepresentation(image);
    return [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}
```
一定不要忘记在生成的base64 String前面拼接上"data:image/png;base64,"

2. 读取本地html内容,并将对应的内容替换之前说的自定义关键字
```
NSString *htmlContent = [self readLocalHtmlContent:@"index.html"];
htmlContent = [self replaceKeywordFromHtmlContent:htmlContent iconString:iconString imgUrlString:imgUrlString];

- (NSString *)readLocalHtmlContent:(NSString *)fileName {
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSString *htmlContent = [NSString stringWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:htmlPath] encoding:NSUTF8StringEncoding error:nil];
    return htmlContent;
}


- (NSString *)replaceKeywordFromHtmlContent:(NSString *)htmlContent iconString:(NSString *)iconString imgUrlString:(NSString *)imgUrlString {
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"IconImageString" withString:iconString];
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"Title" withString:self.model.title];
    NSString *operationString = [NSString stringWithFormat:@"CWDesktop://desktopIconClick/open/jump?iconCode=%ld&title=%@", self.model.code, self.model.title];
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"Operation" withString:operationString];
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"ImageString" withString:imgUrlString];
    htmlContent = [NSString stringWithFormat:@"data:text/html;charset=utf-8,%@", htmlContent];
    htmlContent = [htmlContent stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return htmlContent;
}
```
同理,读取html,并替换关键字后生成的string,记得在前面拼接上"data:text/html;charset=utf-8,"

3. 拼接url,并open(拼接格式: 服务端过渡网页地址?dataurl=处理后的读取的本地html内容字符串) 代码如下:
```
NSString *urlString = @"http://172.16.1.72:8080/iOS-Desktop/index.jsp?dataurl=";
NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", urlString, htmlContent]];
     // 4.打开
[self openUrl:url];
```
到此,代码就完成了.通过该种方式生成的桌面图标,在没网的情况下也能跳转到App内部来.

#### 4. 写在最后
* 第三种通过在APP内嵌HTTPServer来实现的方式我就不写了,我也没去研究,网上相关的资料也有不少.感兴趣的话可以自行了解.
* 你可能会有疑问网页代码是如何判断,是通过App内部代码调用Safari打开的,还是通过点击桌面快捷图标打开的呢.上文中的代码中有注释,如果你没有注意,可以再回过头去看一下.通过图标打开的网页,iOS系统是会全屏展示网页的.所以如果你的网页设置了全屏展示,便可以通过是否全屏来判断是否是通过桌面图标来打开的网页.
* 至于跳转到App内部后如何,实现跳转到对应的界面.这个每个项目都有不同的业务逻辑和层级结构.实现肯定是不同的.如果先要参考,可以下载我的demo看一下.我把跳转的逻辑封装了一下
```
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {    
    [[ControllerPushHelper sharedHelper] pushControllerWithopenURL:url];
    return YES;
}
```
* 因为我用的是本地服务器,所以demo里面写好的url是访问不了的.这个请自行解决.
