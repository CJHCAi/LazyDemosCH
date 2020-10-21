# CYTabBar
[![](https://img.shields.io/travis/rust-lang/rust.svg?style=flat)](https://github.com/zhangchunyu2016/CYTabbar)
[![](https://img.shields.io/badge/language-Object--C-1eafeb.svg?style=flat)](https://developer.apple.com/Objective-C)
[![](https://img.shields.io/badge/license-MIT-353535.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![](https://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)](https://github.com/zhangchunyu2016/CYTabbar)
[![](https://img.shields.io/badge/Pod-1.6.6-blue.svg?style=flat)](https://cocoapods.org/?q=cytabbar)
[![](https://img.shields.io/badge/QQ-707214577-red.svg)](http://wpa.qq.com/msgrd?v=3&uin=707214577&site=qq&menu=yes)


</br>
<p>也许这不是一个很完善的底部控制器,但很好用，已经跟我经历了2个项目，做为基础的组件，希望帮助到你。</p></br>
<img src="http://upload-images.jianshu.io/upload_images/2028853-deab948167f6ddb3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"></br>

!! 很抱歉，换了新工作，最近很忙，很久才更新。 随着用的小伙伴越来越多，遇到很多以前没有的问题，故我准备在春节期间带来重构2.0版本，不再继承系统的tabBar，并加入新功能，更加动态，更加稳定。
目前的版本不需要再额外的设置控制器的 HidesBottomBarWhenPushed 了，用runtime已经帮你做了。


## 一.  功能简介 - Introduction

- [x] 中间按钮可凸出  					--->  bulge设为YES 否则不突出
- [x] 中按钮可设置控制器 或 普通按钮		--->  Controller传入nil为普通按钮
- [x] 设置push时，tabBar存在的方式	    --->  [CYTabBarConfig shared].HidesBottomBarWhenPushedOption = HidesBottomBarWhenPushedTransform;	 
- [x] 小红点提醒角标  					--->  当前控制器.tabBarItem.badgeValue = @"remind";
- [x] 数字提醒角标 					--->  当前控制器.tabBarItem.badgeValue = @"100";
- [x] 切换控制器  					--->  当前tabBarController.selectedIndex = x(索引为添加控制器时的顺序);
- [x] 改变数字提醒背景颜色 				--->  当前控制器.tabBarItem.badgeColor = [UIColor xxxColor];
- [x] 方便的定制UI 					--->  [CYTabBarConfig shared].xxx = xxx;
等...

## 二.  安装 - Installation

##### 方式1:CocoaPods安装
```
pod 'CYTabBar', '~> 1.6.6’
或者
pod 'CYTabBar',:git=>'https://github.com/zhangchunyu2016/CYTabbar.git'
```


##### 方式2:手动导入
```
直接将项目中的“CYTabBar”文件夹的源文件 拖入项目中
```

##### 你可以这样来设置你的tabbar
```
需要导入头文件 "CYTabBarController.h" 
然后在AppDelegate.m中初始化

详情见Demo
```


## 三.  要求 - Requirements

- ARC环境. - Requires ARC


## 四.  更新历史 - Update History

- 2017.03.12  修复tabbar销毁的时候观察者移除问题
- 2017.03.31  修复子控制器未添加时tabbar懒加载带来的问题
- 2017.04.05  修复更新提醒角标UI更新不及时问题
- 2017.04.10  修复设置导航栏为不透明后，坐标偏移问题
- 2017.04.18  增加Hiddentabbar的控制器方法，并将tabbar中间按钮点击方法委托出去
- 2017.05.05  修复部分小问题，增加统一配置UI的单例。 增加默认选择控制器的属性，增加代理通知切换控制器方法
- 2017.05.22  修复中间按钮选择图片的问题
- 2017.07.26  可定义中间按钮位置
- 2017.07.27  修复第0个控制器，无选中状态的bug 
- 2017.07.27  修复badgeColor在iOS10下无此api调用崩溃的问题,item底部无文字图片居中
- 2017.09.07  修复 屏幕监听转向的观察者移除时name不一致
- 2017.10.16  适配iPhone X, 增加安全区域
- 2017.10.30  适配安全区域
- 2017.11.18  修复多个问题
- 2017.11.19  增加push时，tabBar存在的方式	选项, 可以在CYTabBarConfig中设置
- 2018.01.07  修复二级页面可以点击tabbar的问题，修复设置self.title引起页面错乱的问题，修复设置中间按钮高度，其他标题跟着下沉的问题

## 五.  更多 - More

- 如果你发现任何Bug 或者 有趣的需求请issue我.

- 大家一起讨论一起学习进步.</br>
<p>如果issue不能及时响应你，着急的情况下！你可以通过微信(WeChat)及时联系到我👇。</p></br>
<img src="http://upload-images.jianshu.io/upload_images/2028853-d6cc84ab3ce4caf0.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/310">
  
