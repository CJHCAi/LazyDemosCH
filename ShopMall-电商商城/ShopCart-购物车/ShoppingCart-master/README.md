# ShoppingCart

> 这是一个模仿购物车的demo，实现了一个简单的购物车的界面和逻辑处理。


## 一、效果展示

![GitHub set up-w250](https://github.com/MorrisMeng/ShoppingCart/raw/master/images/unchoose.png) ![GitHub set up-w250](https://github.com/MorrisMeng/ShoppingCart/raw/master/images/choose_some.png)

## 二、主要功能

1、购物车界面显示；

2、商品选择；

3、计算价格；

4、删除商品（暂未实现）；

5、结算。
	
## 三、主要技术点

很简单额一个购物车，也没有什么特别技术，就是很简单的tableView的使用。

- tableView的规范化使用，数据源的处理；

- 自定义tableView的haerderSectionView，隐藏footer；

- 数据模型的抽象；

- cell的复用，sectionHeader的复用；

- 计算价格时，用NSDecimalNumber进行精度运算；

- MVC。
	

## 四、代码设计

1、整体采用MVC设计模式

![GitHub set up-w250](https://github.com/MorrisMeng/ShoppingCart/raw/master/images/mvc.png)

2、布局全代码frame布局，做了简单的适配；

3、数据回调采用代理；

4、图片加载用了SDWebImage，用Cocoapods集成；

5、使用了一些基本的宏。

## 五、数据处理

由于没有服务端所有数据由本地文件ShopCartList.plist提供数据，模拟访问HTTP请求，数据回调、处理数据等。

## 最后

功能和界面是实现了，但是还是不够完美，如果有更好的建议，欢迎随时骚扰：helloworldios@dingtalk.com。

谢谢！




