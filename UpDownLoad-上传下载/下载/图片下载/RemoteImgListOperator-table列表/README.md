RemoteImgListOperator
=====================

图片下载队列控制器

------ 原因 ------

1、对于需显示图片的TableView，为了避免快速滑动时同时下载太多图片，需可控制同时下载的数量。

2、经常都有多个页面需要这样的功能，所以做了一个统一控制图片下载数量的类方便重用。

------ 介绍 ------

1、RemoteImgOperator：利用AFNetWorking进行网络图片下载。

- 提供启动下载、取消下载和返回下载进度。
- 通过delegate返回最终下载结果。
2、RemoteImgListOperator：网络下载队列。

- 可设置队列长度。
- 将URL扔给队列，由队列启动RemoteImgOperator进行图片下载，然后通过Notification通知监听者下载结果。
- 每个下载队列对象的NotificationName都不同。

------ 用法 ------

以Demo为例：

1、在TableView所在的ViewController中创建队列对象，并这是队列大小。

// 创建一个队列对象，以便在当前页面内统一控制下载数量。

// 页面不需响应图片下载完成的通知，将队列对象扔给具体需显示图片的TableViewCell，由Cell响应通知并显示图片。

_objImgListOper = [[RemoteImgListOperator alloc] init];

[_objImgListOper resetListSize:20];

2、在显示内容时，将队列对象扔给Cell，由Cell内部响应Notification。

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(remoteImgSucc:)
                                                     name:_objRemoteImgListOper.m_strSuccNotificationName
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(remoteImgFailed:)
                                                     name:_objRemoteImgListOper.m_strFailedNotificationName
                                                   object:nil];
3、当Cell需要的图片被下载完成时，Cell显示该图片。


## 还是 SDWebImage 好用

