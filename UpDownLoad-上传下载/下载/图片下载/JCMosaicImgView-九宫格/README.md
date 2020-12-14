JCMosaicImgView
===============

一个显示多图微博的图片九宫格视图

------ 原因 ------

自从出了多图微博后，需要一个控件可以直接扔URL进去，自己显示图片九宫格。

------ 介绍 ------

1、使用了 RemoteImgListOperator 进行图片下载。 https://github.com/jimple/RemoteImgListOperator

所以，如果想使用自己的图片下载，需修改代码中的 - (void)getRemoteImgByURL:(NSString *)strURL ，以及对应的下载成功响应函数。

2、JCMosaicImgView ：继承自 UIView - 仅针对九宫格图片，最多九个图片。

------ 用法 ------

以Demo为例：

// 使用 JCRemoteImgListOperator 进行图片下载
// https://github.com/jimple/RemoteImgListOperator
_objImgListOper = [[RemoteImgListOperator alloc] init];

NSArray *arrImgURL = @[@"http://ww1.sinaimg.cn/square/6deee36fgw1eby2bh3bxlj20bh0hajsu.jpg",
                       @"http://ww1.sinaimg.cn/square/6deee36fgw1eby2bhj5t2j20bh0hb0u5.jpg",
                       @"http://ww1.sinaimg.cn/square/749e7418jw1e6tiy08m52j20dc0hsgne.jpg",
                       @"http://ww1.sinaimg.cn/square/749e7418jw1e6tiy3nso4j20dc0hs3zs.jpg",
                       @"http://ww1.sinaimg.cn/square/5fae6c19jw1e6h04js4xej218g0xcju2.jpg",
                       @"http://ww1.sinaimg.cn/square/5fae6c19jw1e6h04llbhjj218g0xcgp5.jpg",
                       @"http://ww1.sinaimg.cn/square/6e109605jw1ec442eaq9nj20qo0f0q6m.jpg",
                       @"http://ww1.sinaimg.cn/square/6deee36fgw1eby2bfug1uj20bh07mmy4.jpg",
                       @"http://ww1.sinaimg.cn/small/7116d554gw1ecd41d9s9oj205k05k3ym.jpg"];

CGFloat fImgHeight = [JCMosaicImgView imgHeightByImg:arrImgURL];
CGFloat fImgWidth = [JCMosaicImgView imgWidthByImg:arrImgURL];

// 1.创建对象   2.设置图片下载队列对象   3.输入图片URL数组。
_mosaicImgView = [[JCMosaicImgView alloc] initWithFrame:Rect(0.0f, 0.0f, fImgWidth, fImgHeight)];
[_mosaicImgView setImgListOper:_objImgListOper];
[_mosaicImgView showWithImgURLs:arrImgURL];

[self.view addSubview:_mosaicImgView];
