#MVVM
 ![image](https://travis-ci.org/shenAlexy/MVVM.svg?branch=master) ![image](https://camo.githubusercontent.com/72a3664b1de5fe08005f3a09a86b1fd77bc86633/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f706c6174666f726d2d694f53253230382e302532422d6666363962342e737667) <a href="https://twitter.com/shenguanhua11"><img src="https://img.shields.io/badge/twitter-@shenguanhua11-blue.svg?style=flat"></a> [![Join the chat at https://gitter.im/shenAlexy/MVVM](https://badges.gitter.im/shenAlexy/MVVM.svg)](https://gitter.im/shenAlexy/MVVM?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

##Requirements：
- iOS 8.0+ / Mac OS X 10.9+
- Xcode 7.2+

##前言：
一个iOS头条APP，使用MVVM架构实现，代码中有注释，封装了AFN网络请求，解媾代码，使用起来非常方便。用最经典的TableView展示，后续不断更新，喜欢就star或fork一下，有问题或者建议意见就issues！

本例基于AFN封装了网络请求系列库，以满足自己需求，后期易于扩展；使用JSONModel解析json数据；每个VC都有自己的ViewModel类用来处理网络请求和其他逻辑处理；使用经典的UITableView展示MVVM架构，适合初学MVVM的coder参考。
    
##简介：
![image](https://github.com/shenAlexy/MVVM/blob/master/MVVM.jpg)

MVVM的出现主要是为了解决在开发过程中Controller越来越庞大的问题，变得难以维护，所以MVVM把数据加工的任务从Controller中解放了出来，使得Controller只需要专注于数据调配的工作，ViewModel则去负责数据加工并通过通知机制让View响应ViewModel的改变。

MVVM是基于胖Model的架构思路建立的，然后在胖Model中拆出两部分：Model和ViewModel。ViewModel本质上算是Model层（因为是胖Model里面分出来的一部分），所以View并不适合直接持有ViewModel，因为ViewModel有可能并不是只服务于特定的一个View，使用更加松散的绑定关系能够降低ViewModel和View之间的耦合度。

在一个典型的 MVC 应用中，controller 由于承载了过多的逻辑，往往会变得臃肿不堪，所以 MVC 也经常被人调侃成 Massive View Controller。(Massive译:大量的、巨大的、臃肿不堪的)

因此，一种可以很好地解决 Massive View Controller 问题的办法就是将 controller 中的展示逻辑抽取出来，放置到一个专门的地方，而这个地方就是 viewModel 。其实，我们只要在上图中的 M-VC 之间放入 VM ，就可以得到 MVVM 模式的结构图：

##源码解析：
1、首先是model层的代码，基于JSONModel封装了BaseModel类(基类: 以后的Model都可继承此类)，继承自BaseModel，实现HomeModel类。

![image](https://github.com/shenAlexy/MVVM/blob/master/1.png)

2、然后是View层的代码，View层控件全部用懒加载方式，尽可能减少内存消耗；不喜欢用XIB，所以习惯纯代码编写。

![image](https://github.com/shenAlexy/MVVM/blob/master/2.png)

3、接下来看ViewModel层，对封装好的NetWork进行处理，request网络数据存储在HomeModel里，最后将数据用Block带出去，方便在VC中使用数据，reloadData。

![image](https://github.com/shenAlexy/MVVM/blob/master/3.png)

4、最终，HomeViewController 将会变得非常轻量级：

![image](https://github.com/shenAlexy/MVVM/blob/master/4.png)
    
 MVVM并没有想像中的那么难，而且更重要的是它也没有破坏 MVC 的现有结构，只不过是移动了一些代码，仅此而已。总结下 MVVM 相比 MVC 到底有哪些好处呢？

我想，主要可以归纳为以下三点：

    1、由于展示逻辑被抽取到了 viewModel 中，所以 view 中的代码将会变得非常轻量级；
    2、由于 viewModel 中的代码是与 UI 无关的，所以它具有良好的可测试性；
    3、对于一个封装了大量业务逻辑的 model 来说，改变它可能会比较困难，并且存在一定的风险。在这种场景下，viewModel 可以作为 model 的适配器使用，从而避免对 model 进行较大的改动。

通过前面的示例，我们对第一点已经有了一定的感触；至于第三点，可能对于一个复杂的大型应用来说，才会比较明显。

##小结：
综上所述，我们只要将 MVC 中的 controller 中的展示逻辑抽取出来，放置到 viewModel 中，然后通过一定的技术手段，来同步 view 和 viewModel ，就完成了 MVC 到 MVVM 的转变。

# 效果图
![image](https://github.com/shenAlexy/MVVM/blob/master/MVVM-demo/MVVM-demo/效果图.png)
 
#联系我
微信公众号：iOSDevTeam

Email: shenAlexy@gmail.com
  
  
