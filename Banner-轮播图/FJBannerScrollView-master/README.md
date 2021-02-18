# FJBannerScrollView

>
>简介：仿腾讯视频，爱奇艺轮播，拥有轮播动画效果，可以自定义
>

![效果图](https://github.com/nuanqing/FJBannerScrollView/blob/master/1gif.gif)

基本使用，在控制器中添加以下代码:
```
//添加数据源
[_bannerView setCarouseWithArray:@[@{@"image":@"http://a.hiphotos.baidu.com/image/pic/item/b7fd5266d01609240bcda2d1dd0735fae7cd340b.jpg"},@{@"image":@"http://h.hiphotos.baidu.com/image/pic/item/728da9773912b31b57a6e01f8c18367adab4e13a.jpg"},@{@"image":@"http://h.hiphotos.baidu.com/image/pic/item/0d338744ebf81a4c5e4fed03de2a6059242da6fe.jpg"}]];
```
初始化设置（imgEdgePadding 与imgMargnPadding设置为0时为普通轮播图）:
```
_bannerView = [[FJBannerScrollView alloc]init];
_bannerView.frame = CGRectMake(0, 0, fj_screenWidth, 180);
//图片宽度
_bannerView.imgWidth = fj_screenWidth-40;
//边距
_bannerView.imgEdgePadding = 30;
//两个图片间距
_bannerView.imgMargnPadding = 10;
//默认图
_bannerView.defaultImg = @"moren";
//圆角（0的时候没有圆角）
_bannerView.imgCornerRadius = 5;

_bannerView.bannerScrolldelegate = self;
```
代理处理点击事件：
```
- (void)selectedIndex:(NSInteger)index {
NSLog(@"%ld",(long)index);
}
```
注意：
------
使用时需要添加SDWebImage依赖
