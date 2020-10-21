# XLZoomHeader


### 说明

适用于UIScrollView、UITableView、UICollectionView、UIWebView（即UIScrollV及其子类）的页面头部视图。

### Tips

- [x] 使用时，建议新建一个XLZoomHeader的子类，在子类中添加自定义的功能和布局。


### 显示效果

| 正常显示 | 设置背景图缩进 |
| ---- | ---- |
|![image](https://github.com/mengxianliang/XLZoomHeader/blob/master/GIF/2.gif)| ![image](https://github.com/mengxianliang/XLZoomHeader/blob/master/GIF/1.gif)| 

### 使用方法

新建一个XLZoomHeader的子类，TestZoomHeader，实例化后赋值给xl_zoomHeader属性，然后在XLZoomHeader内部设置**背景图**和**背景图缩进**属性

```objc
TestZoomHeader *header = [[TestZoomHeader alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width, 150)];
scrollView.xl_zoomHeader = header;
```
### 参数说明：

**image** ：设置背景图图片
<br>
**imageInset**：背景图缩进

### 个人开发过的UI工具集合 [XLUIKit](https://github.com/mengxianliang/XLUIKit)
