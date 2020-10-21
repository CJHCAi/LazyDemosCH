# ZPScrollerScaleView

[![CI Status](https://img.shields.io/travis/张朋朋/ZPScrollerScaleView.svg?style=flat)](https://travis-ci.org/张朋朋/ZPScrollerScaleView)
[![Version](https://img.shields.io/cocoapods/v/ZPScrollerScaleView.svg?style=flat)](https://cocoapods.org/pods/ZPScrollerScaleView)
[![License](https://img.shields.io/cocoapods/l/ZPScrollerScaleView.svg?style=flat)](https://cocoapods.org/pods/ZPScrollerScaleView)
[![Platform](https://img.shields.io/cocoapods/p/ZPScrollerScaleView.svg?style=flat)](https://cocoapods.org/pods/ZPScrollerScaleView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## How to use ZPScrollerScaleView
```
    /**初始化配置项*/
        ZPScrollerScaleViewConfig * config = [[ZPScrollerScaleViewConfig alloc]init];
        config.scaleMin = 0.9;
        config.scaleMax = 1;
        config.pageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, 400);
        config.ItemMaingin = 5;
       
        
        /**初始化滚动缩放视图*/
        ZPScrollerScaleView * tempView = [[ZPScrollerScaleView alloc] initWithConfig:config];
        
        /**设置默认展示*/
        tempView.defalutIndex = 1;
        
        /**添加子视图view到items数组中用于展示*/
        tempView.items =@[view1,view2,view3,....];
        
```

## 如何获取当前下标值

```
NSInteger currentIndex = tempView.currentIndex;

```

## Installation

ZPScrollerScaleView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZPScrollerScaleView'
```

## Author

张朋朋, 944160330@qq.com

## License

ZPScrollerScaleView is available under the MIT license. See the LICENSE file for more info.

##Dome实现案例：
![gif5新文件.gif](https://upload-images.jianshu.io/upload_images/11285123-15764dd75f068532.gif?imageMogr2/auto-orient/strip)

## 简书链接
[https://www.jianshu.com/p/61c6640919e6](https://www.jianshu.com/p/61c6640919e6)
