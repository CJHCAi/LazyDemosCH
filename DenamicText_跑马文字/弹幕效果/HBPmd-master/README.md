# HBPmd

![设计图.jpg](http://7xnt2l.com1.z0.glb.clouddn.com/设计图2.gif)

##用法

```
{

  	HBdansView *_randomDansView;
  
}

 	_randomDansView = [[HBdansView alloc] initWithFrame:CGRectMake(0, 84, self.view.width, 320)]; //初始化
 
 	[self.view addSubview:_randomDansView];

	[_randomDansView addRandomText:@"需要展现的文字"];

```

##需求
* 上图中有两种方式去展示弹幕
* 广播式：每次只播放一条数据。
* 分布式：屏幕中最多显示3条数据

**实在想不出其他名字，暂用分布式来表述吧。**
##思路
分两部分

* 背景
* 文字

##实现
首先的话，文字是用一个`UILable`添加到背景`UIView`上面。但是`分布式`怎么办？由此设计一个对外属性`countInScreen`来确定，同时可以在屏幕显示多少个弹幕的内容。

```
- (void)setCountInScreen:(NSInteger)countInScreen
{
    _countInScreen = countInScreen;
    
    if (self.randomSet.count) [self.randomSet removeAllObjects];
    //    随机
    if (_countInScreen > 10) _countInScreen = 10;
    CGFloat margin = (self.height - _countInScreen * defaultH) / (_countInScreen + 1);
    for (NSInteger i = 0; i < _countInScreen; i++) {
        HBdansLable *randomLable = [HBdansLable dansLableFrame:[self randomFrame]];
        randomLable.y = i * (margin + defaultH) + margin;
        randomLable.delegate = self;
        randomLable.layer.masksToBounds = YES;
        
        [self.randomSet addObject:randomLable];
        
    }
    
}

```
在代码中，会创建等数目`HBdansLable`自定义`Lable`，算出自己的`frame`。当然，间距是等分的。

而`randomSet`是一个可变的集合。是这样的

```
- (NSMutableSet *)randomSet
{
    if (!_randomSet) {
        
        _randomSet = [NSMutableSet set];
        
    }
    return _randomSet;
}
```
 **搞这个集合的目的是：一开始所有新创建的对象都放这里面去，你可以把这个想象成一个缓存池。用的时候从里面取出`HBdansLable`对象，展示出来;弹幕滚出父试图，就把此对象回收，重新加到`randomSet`集合中。**
 
 **这样你所需的所有`HBdansLable`对象，在一开始的时候就已经创建好了。后面用的时候，不需要重复创建。**
 
 ```
 #pragma mark - HBdansLableDelegate
- (void)dansLable:(HBdansLable *)dansLable isOutScreen:(BOOL)isOutScreen
{
    if (isOutScreen) {
        
        dansLable.x = CGRectGetMaxX(self.frame);//更新x值
        
        [dansLable removeFromSuperview];//从父试图中移除
        
        [self.randomSet addObject:dansLable];//添加到集合中国
        
        if (self.randomMutableArray.count){
            
            [self dequeRandomLable:[self.randomMutableArray firstObject]];
            [self.randomMutableArray removeObjectAtIndex:0];
            
        }
    }
}
 ```
 完成回收`HBdansLableDelegate`通知；
 
 每个`HBdansLable`都需要自己去移动，更新`frame`；
 
 ```
 - (void)setText:(NSString *)text
{
    [super setText:text];
    //1.更具文字内容算出宽高
    CGRect contextFrame = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}
                                             context:nil];
    NSString *str = [NSString stringWithFormat:@"%.f",contextFrame.size.width + 10];
    self.width = [str floatValue];
    self.height = contextFrame.size.height + 6;
    //2.开始弹幕
    [self starDans];
}
 ```
 重写`HBdansLable` `setter`方法,启动弹幕；
 
 ```
 - (void)starDans
{
    
    self.displayLink.paused = NO;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.isStar = YES;
    
}
- (void)puseDans
{
    if (self.displayLink.isPaused) return;
    self.displayLink.paused = YES;
    self.isStar = NO;
    [self.displayLink invalidate];
    self.displayLink = nil;
    
}
 
 ```
 **一定要加入`RunLoop`循环中，否则触摸屏幕或者他操作会影响弹幕不再移动。销毁神马的，你们都懂的。**
##结束总结
就两个注意

* `HBdansLable`自己控制移动，算出`宽高`；
* 父试图控制`回收HBdansLable`（不需要重复创建）;

 >如果这个文章帮到了你，一定给我`Star`哦！

 >[我的简书](http://www.jianshu.com/users/4d868865a987/latest_articles) 欢迎围观！！

 
 
## Tip
* 本项目仅支持`文字弹幕`，后续会持续更新。
* 实现思路仅来源项目需求，所以不是完全适用所有需求场景。