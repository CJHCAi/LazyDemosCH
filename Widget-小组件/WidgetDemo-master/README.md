#iOS Widget的简单实现 demo
>自iOS8之后，苹果支持了扩展（Extension）的开发，开发者可以通过系统提供给我们的扩展接入点 (Extension point) 来为系统特定的服务提供某些附加的功能。今年iOS10的推出，让Widget扩展应用渐渐的火了起来，地位得到重大的提升，从这也可以看出苹果对他的重视，今天我们就来一起学习下Widget，来实现一个简单的扩展程序。

![iOS Widget扩展程序](http://upload-images.jianshu.io/upload_images/1269906-dd0a3ebee434a9ec.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#程序效果

![程序效果图](http://upload-images.jianshu.io/upload_images/1269906-9a62de27618dd755.gif?imageMogr2/auto-orient/strip)


#创建Widget程序
- 创建工程，在工程中添加扩展程序

![](http://upload-images.jianshu.io/upload_images/1269906-2dc240dcd5d68f6c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![创建Widget程序](http://upload-images.jianshu.io/upload_images/1269906-d8f436829039615e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 创建成功后的目录

![创建成功](http://upload-images.jianshu.io/upload_images/1269906-498cca063da18794.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

顺便说一句，扩展程序虽然是程序的扩展，但是这两个应用其实是“独立”的。准确的来说，它们是两个独立的进程，默认情况下互相不应该知道对方的存在。扩展需要对宿主 app (host app，即调用该扩展的 app) 的请求做出响应，当然，通过进行配置和一些手段，我们可以在扩展中访问和共享一些容器 app 的资源，这个我们稍后再说。

#Widget布局方式
- 使用Interface Builder
工程默认的方式就是使用Interface Builder，如果实现简单的布局的话可以考虑这种方式。
- 使用代码进行布局
当涉及到比较复杂的UI布局的时候，可以考虑使用这种布局方式，按大家平时的习惯来。这里需要注意一下，如果需要使用代码布局的话需要修改一下plist文件。
首先将原有`NSExtensionMainStoryboard`字段删除，添加字段`NSExtensionPrincipalClass`，value是你所写的controller的名称，一般默认的都是`TodayViewController`

![修改plist文件](http://upload-images.jianshu.io/upload_images/1269906-3f01410146ae3185.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#实现相应的方法
**1. 设置Widget的size** 
iOS10之后，Widget支持展开及折叠两种展现方式，通过设置`widgetLargestAvailableDisplayMode`属性可以让Widget程序实现展开布局。如下：

```
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (isIOS10)
    {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }
    
    self.preferredContentSize = CGSizeMake(kWidgetWidth, 110);
}
```
**2. 重写切换展开及折叠布局时的方法（iOS10之后）**
```
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    NSLog(@"maxWidth %f maxHeight %f",maxSize.width,maxSize.height);
    
    if (activeDisplayMode == NCWidgetDisplayModeCompact)
    {
        self.preferredContentSize = CGSizeMake(maxSize.width, 110);
    }
    else
    {
        self.preferredContentSize = CGSizeMake(maxSize.width, 200);
    }
}
```
**3. iOS10之前，视图原点默认存在一个间距，可以实现以下方法来调整视图间距**
`注：`该方法在iOS10之后被遗弃，iOS10默认不存在间距。
```
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
```

#应用唤醒
本来想叫应用间跳转的，想想还是这个名字比较高大上些😏
如下，配置url scheme，这个定义的时候尽量不要和其他用用冲突，笔者定义的为`WidgetDemo`。这样，通过访问`WidgetDemo://`就可以实现应用唤醒了。代码如下：

![配置url scheme](http://upload-images.jianshu.io/upload_images/1269906-69f262be69293ae0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
- (void)redButtonPressed:(UIButton *)button
{
    NSLog(@"%s",__func__);
    
    NSURL *url = [NSURL URLWithString:@"WidgetDemo://red"];
    
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
        NSLog(@"isSuccessed %d",success);
    }];
}
```

相应的，在AppDelegate中实现以下方法，这里可以处理传过来的action，对于传过来不同的值可以进行不同的操作，这里我们打印了请求url的内容。
```
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url absoluteString] hasPrefix:@"WidgetDemo"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"你点击了%@按钮",[url host]] delegate:nil cancelButtonTitle:@"好的👌" otherButtonTitles:nil, nil];
        [alert show];
    }
    return  YES;
}
```
- 简易的应用快速启动器
既然说到了应用唤醒，这里再稍稍拓展以下，想必大家都有用过类似launcher这种的应用快速启动器。其实就是运用了应用间跳转的原理，每款应用都有自定义的url scheme，我们只要知道他们的url scheme就可以跳转至改款应用，例如进行微信的跳转：

```
- (void)wechatLoginButtonPressed
{
    NSLog(@"%s",__func__);
    
    NSURL *url = [NSURL URLWithString:@"wechat://"];
    
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
        NSLog(@"isSuccessed %d",success);
    }];
}
```
>以下是我们比较常用的软件的url scheme，有兴趣的同学们可以试一试：
`QQ mqq://
微信 weixin://
淘宝taobao://
微博 sinaweibo://
支付宝alipay://`

#数据共享
扩展程序一般都不是脱离宿主程序单独运行的，难免需要和宿主程序进行数据交互。而相对于一般的APP，数据可以用单例，NSUserDefault等等。但由于拓展与宿主应用是两个完全独立的App，并且iOS应用基于沙盒的形式限制，所以一般的共享数据方法都是实现不了数据共享，这里就需要使用App Groups。
- 在宿主程序和扩展程序中分别设置打开App Group，设置一个group的名称，这里要保证宿主APP和扩展APP的groupName要是相同的。

![设置App Group](http://upload-images.jianshu.io/upload_images/1269906-4fbc517b9a6fbf99.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##两种数据存储方式
- **使用NSUserDefault**
这里不能使用`[NSUserDefaults standardUserDefaults];`方法来初始化NSUserDefault对象，正像之前所说，由于沙盒机制，拓展应用是不允许访问宿主应用的沙盒路径的，因此上述用法是不对的，需要搭配app group完成实例化UserDefaults。正确的使用方式如下：
**写入数据**
```
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.japho.widgetDemo"];
    [userDefaults setObject:self.textField.text forKey:@"widget"];
    [userDefaults synchronize];
```
**读取数据**
```
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.japho.widgetDemo"];
    self.contentStr = [userDefaults objectForKey:@"widget"];
```
- **通过NSFileManager共享数据**
**写入数据**
```
-(BOOL)saveDataByNSFileManager
{
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.xxx"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/ widget"];
    NSString *value = @"asdfasdfasf";
    BOOL result = [value writeToURL:containerURL atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!result)
    {
        NSLog(@"%@",err);
    }
    else
    {
        NSLog(@"save value:%@ success.",value);
    }
    return result;
}
```
**读取数据**
```
-(NSString *)readDataByNSFileManager
{
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.xxx"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/ widget"];
    NSString *value = [NSString stringWithContentsOfURL:containerURL encoding: NSUTF8StringEncoding error:&err];
    return value;
}
```

#其他
补充：widget的上线也是需要单独申请APP ID的 需要配置证书和Provisioning Profiles文件
没有配置相关证书时：

![](http://upload-images.jianshu.io/upload_images/1269906-d2ab72c1517f4c2a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

配置证书及描述文件：（列举一些）

![](http://upload-images.jianshu.io/upload_images/1269906-db71f4b3cd38f241.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![](http://upload-images.jianshu.io/upload_images/1269906-37e9e089cda02fa4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

证书与描述文件配置好之后：

![](http://upload-images.jianshu.io/upload_images/1269906-2b51d98403d5d0ab.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


最后感谢一下文章的博主😏

[Widget的简单应用并适配iOS10](http://www.jianshu.com/p/42516ee26a45)

[ iOS开发------Widget(Today Extension)插件化开发  ](http://blog.csdn.net/runintolove/article/details/52595770)
