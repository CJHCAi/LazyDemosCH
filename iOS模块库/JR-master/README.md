### 介绍

如果你还不知道Lottie是什么, 那你真的out了.

如果把iOS动画分为两类: 交互式动画, 播放式动画, 那么其中的播放动画完全可以使用Lottie来完成, 例如: 

![](http://osnabh9h1.bkt.clouddn.com/17-9-18/78890536.jpg)

作为收藏按钮, 是不是很活泼?

![](http://osnabh9h1.bkt.clouddn.com/17-9-18/76115417.jpg)

返回与菜单之间的切换, 生动有趣!

![](http://osnabh9h1.bkt.clouddn.com/17-9-18/19387182.jpg)

还有各种形变动画.

这里先放上Lottie的地址: https://github.com/airbnb/lottie-ios

更棒的是, Lottie有各种不同的版本, 安卓, iOS, 前端都可以使用, 理论上动画做一套就可以共用, 大大的减少了工作量.

### 使用方法

1. 集成环境: 移动端同学集成Lottie框架, UI/UE同学集成AE的bodymovin插件
2. 制作动画, 导出文件, 拖进工程
3. 创建LOTAnimationView, 并播放

非常简单, 下面看两个实际例子

### 实战

先看第一个例子: 

![](http://osnabh9h1.bkt.clouddn.com/17-9-18/26735833.jpg)

典型的形变动画加上几个普通动画融合在一起, 如果由程序员来写, 确实还要花一番心思, 使用Lottie就非常容易了.

viewDidLoad时加载动画, 在视图显示出来时播放, 播放完了移除. 就是这么简单.
```
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (_launchMask && _launchAnimation) {
        WeakObj(self);
        [_launchAnimation playWithCompletion:^(BOOL animationFinished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                selfWeak.launchMask.alpha = 0;
            } completion:^(BOOL finished) {
                [selfWeak.launchAnimation removeFromSuperview];
                selfWeak.launchAnimation = nil;
                [selfWeak.launchMask removeFromSuperview];
                selfWeak.launchMask = nil;
            }];
        }];
    }
}


- (void)setupLaunchMask{
    _launchMask = [[UIView alloc] initWithFrame:self.view.bounds];
    
    [JRKeyWindow addSubview:_launchMask];
    
    _launchAnimation = [LOTAnimationView animationNamed:@"data"];
    _launchAnimation.cacheEnable = NO;
    _launchAnimation.frame = self.view.bounds;
    _launchAnimation.contentMode = UIViewContentModeScaleToFill;
    _launchAnimation.animationSpeed = 1.2;
    
    [_launchMask addSubview:_launchAnimation];
}
```

![](http://osnabh9h1.bkt.clouddn.com/17-9-18/55932153.jpg)

甚至可以用在引导页中, 代码都很简单, 就不重复贴了. 值得注意的是, 像这样多次使用到Lottie时一定要注意素材的名字不能一样, 否则动画就是错乱的, 简单讲一讲怎么改.

![](http://osnabh9h1.bkt.clouddn.com/17-9-18/70580977.jpg)

这是一个动画资源的文件结构, 如果修改了img_0.png及其文件夹, 则需要在Json文件中修改对应的内容

![](http://osnabh9h1.bkt.clouddn.com/17-9-18/75913874.jpg)

这就是Json文件中的内容, 最上面一部分包含了素材路径, 素材名称, 注意修改好就ok.

第二个例子:

![](http://osnabh9h1.bkt.clouddn.com/17-9-18/60398099.jpg)

动画有小鱼的尾巴摇动, 眼睛眨, 鱼鳍煽动, 背后的小泡泡时隐时现, 随机运动, 这让程序员来一个个写, 效率必然很低. 使用Lottie则简单很多, 我们公司的高级UI写完这个简直不要太轻松.

让UI同学导出动画时将第一帧截取出来作为启动页静态图, 在第一个视图加载的地方设置动态动画.

```
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (_launchMask && _launchAnimation) {
        WeakObj(self);
        [_launchAnimation playWithCompletion:^(BOOL animationFinished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                selfWeak.launchMask.alpha = 0;
            } completion:^(BOOL finished) {
                [selfWeak.launchAnimation removeFromSuperview];
                selfWeak.launchAnimation = nil;
                [selfWeak.launchMask removeFromSuperview];
                selfWeak.launchMask = nil;
            }];
        }];
    }
}


- (void)setupLaunchMask{
    _launchMask = [UIImageView imageViewWithFrame:self.view.bounds image:[UIImage imageNamed:@"launchAnimationBg"]];
    
    [self.view addSubview:_launchMask];
    
    _launchAnimation = [LOTAnimationView animationNamed:@"launchAnimation"];
    _launchAnimation.cacheEnable = NO;
    _launchAnimation.frame = self.view.bounds;
    _launchAnimation.contentMode = UIViewContentModeScaleToFill;
    _launchAnimation.animationSpeed = 1.2;
    
    [_launchMask addSubview:_launchAnimation];
}
```
几点值得注意的是:

1. 我这创建一个UIImageView作为背景, 是拆分了动画, 将不动的部分作为背景, 避免内存中加载的图片过多, 后面会细说这个问题.

2. LOTAnimationView这个类就是动画本身了, 也可以设置contentMode, 所以为了适配, 这个属性应该与启动页图片一致(建议启动页用Storyboard + UIImageView).

3. 在视图加载完成之后调用_launchAnimation的play方法, 完成之后渐变色隐藏并置空.

很容易的, 一个精美的启动动画就完成了.


### 总结

看完了本篇文章, 你会发现动画竟然如此简单, 那我们以后动画全用Lottie来实现? 其实Lottie也有一定的限制

Lottie是基于CALayer的动画, 所有的路径预先在AE中计算好, 转换为Json文件, 然后自动转换为Layer的动画, 所以性能理论上是非常不错的, 在实际使用中, 确实很不错, 但是有几点需要注意的:

* 如果使用了素材, 那么素材图片的每个像素都会直接加载进内存, 并且是不能释放掉的(实测, 在框架中有个管理cache的类, 并没有启动到作用, 若大家找到方法请告诉我), 所以, 如果是一些小图片, 加载进去也还好, 但是如果是整页的启动动画, 如上面的启动页动画, 不拆分一下素材, 可能一个启动页所需要的内存就是50MB以上. 如果不使用素材, 而是在AE中直接绘制则没有这个问题.

* 如果使用的PS中绘制的素材, 在AE中做动画, 可能在动画导出的素材中出现黑边, 我的解决办法是将素材拖入PS去掉黑边, 同名替换.

* 拆分素材的办法是将一个动画中静态的部分直接切出来加载, 动的部分单独做动画

* 如果一个项目中使用了多个Lottie的动画, 需要注意Json文件中的路径及素材名称不能重复, 否则会错乱

* 不支持渐变色

* 不支持AE中的mask属性

* Lottie先天就支持播放式动画, 对于交互式动画有个animationProgress的属性(待核实)

基于以上的问题, 建议使用Lottie的场合为复杂的播放式形变动画, 因为形变动画由程序员一点点的写路径确实不直观且效率低. 但即便如此, Lottie也是我们在CoreAnimation之后一个很好的补充.

以上健呗的Demo地址: https://github.com/syik/JR

直播伴侣地址: https://github.com/syik/BulletAnalyzer

这是一个已经上架的App, 大家可以直接在App Store中找到使用.  上一篇文章为此App中CoreAnimation与CoreGraphics可交互式图表实战.
若大家觉得写得有用, 不吝啬打赏一个Star~, 谢谢~
