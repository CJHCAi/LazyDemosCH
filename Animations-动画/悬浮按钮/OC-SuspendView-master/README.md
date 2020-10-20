# OC-SuspendView
悬浮视图:按钮/图片/轮播图/gif图/音频/视频/自定义view




悬浮按钮:
![image](https://github.com/LuochuanAD/OC-SuspendView/blob/master/SuspendView/suspendButton.gif)

悬浮图片:
![image](https://github.com/LuochuanAD/OC-SuspendView/blob/master/SuspendView/suspendImageView.gif)

悬浮Gif图
![image](https://github.com/LuochuanAD/OC-SuspendView/blob/master/SuspendView/suspendWebView.gif)

悬浮滚动图
![image](https://github.com/LuochuanAD/OC-SuspendView/blob/master/SuspendView/suspendScrollView.gif)

悬浮视频
![image](https://github.com/LuochuanAD/OC-SuspendView/blob/master/SuspendView/suspendVideo.gif)



使用:在所有页面都能出现悬浮窗口,即使有弹框,也能显示.


/**悬浮视图的类型

 BUTTON    =0,//按钮
 
 
 IMAGEVIEW =1,//图片
 
 
 GIF       =2,//gif图
 
 
 MUSIC     =3,//音乐界面
 
 
 VIDEO     =4,//视频界面
 
 
 SCROLLVIEW =5,//滚动多图
 
 
 OTHERVIEW =6//自定义view
 
 
 */
 
 
 
在viewDidLoad方法中加载以下4行代码

    
    
    LCSuspendCustomBaseViewController *suspendVC=[[LCSuspendCustomBaseViewController alloc]init];
    
    
    
    suspendVC.suspendType=SCROLLVIEW;
    
    
    
    [self addChildViewController:suspendVC];
    
    
    
    [self.view addSubview:suspendVC.view];
    
    
    




自定制:


如果项目中有导航栏或标签栏  修改#define NavigationBarHeight 64和 #define TabBarHeight 49的值可以限定悬浮窗口的活动范围.


遵守协议SuspendCustomViewDelegate  实现代理方法:可以判断是否点击和滑动到屏幕的哪个方向:

- (void)suspendCustomViewClicked:(id)sender;//悬浮窗口点击方法



- (void)dragToTheLeft;//滑动悬浮窗口到了左边



- (void)dragToTheRight;//滑动悬浮窗口到了右边



- (void)dragToTheTop;//滑动悬浮窗口到了顶部



- (void)dragToTheBottom;//滑动悬浮窗口到了底部


警告⚠️:如果你希望悬浮窗口不是一个单一的button/image/webView/scrollView  那么你需要将自定义控件的userInteractionEnabled重新设置为YES. 同时需要创建该控件的子类,并重写touchesBegan/touchesMoved/touchesEnded三个方法,添加代码:[[self nextResponder]touchesBegan:touches withEvent:event]... 这是为了不阻塞项目中其他控件响应链的传递.


Bug❗️:该悬浮窗口有个问题:如果项目中有截屏的功能,就会不可用.  该问题未解决.




博文地址:http://blog.csdn.net/luochuanad/article/details/71522241







