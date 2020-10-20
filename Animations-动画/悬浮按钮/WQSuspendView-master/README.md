# WQSuspendView
一句demo 显示、点击. 支持自定义
先上图
![suspend.gif](https://upload-images.jianshu.io/upload_images/2835602-a7290db1e68a38a4.gif?imageMogr2/auto-orient/strip)

1、刚刚开始做是用来给测试人员用,不需要一直打包,然后就用一个固定的UIButton来代替.
2、后面有一个分享有礼功能一直悬浮,离开这个页面时移除.然后才考虑写悬浮按钮.
3、因为我们产品需求当前页面能手动点击移除,所以用UIView 来写,高度自定义.

#####悬浮有2种方式能实现
(1)手势 UIPanGestureRecognizer
UIGestureRecognizerStateBegan
UIGestureRecognizerStateChanged
UIGestureRecognizerStateEnded

(2)点击屏幕的几个方法
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event

手势和点击屏幕事件的区别唯一就是获取当前位置不一样
```
//点击屏幕事件获取当前位置
UITouch *touch = [touches anyObject];
CGPoint currentPosition = [touch locationInView:self];

// 手势获取当前位置
CGPoint currentPosition = [pan locationInView:self];
```

下面用手势来一一讲解
```
- (void)configurationUI{
self.backgroundColor = [UIColor redColor];
//自定义图片~文字等...

//点击手势
UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
[self addGestureRecognizer:tap];
//滑动手势
UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
[self addGestureRecognizer:pan];
}
//点击事件
- (void)tap:(UITapGestureRecognizer *)tap{
if (self.tapBlock) {
self.tapBlock();
}
}

//滑动事件
- (void)pan:(UIPanGestureRecognizer *)pan{
//获取当前位置
CGPoint currentPosition = [pan locationInView:self];
if (pan.state == UIGestureRecognizerStateBegan) {
_originalPoint = currentPosition;
}else if(pan.state == UIGestureRecognizerStateChanged){
//偏移量(当前坐标 - 起始坐标 = 偏移量)
CGFloat offsetX = currentPosition.x - _originalPoint.x;
CGFloat offsetY = currentPosition.y - _originalPoint.y;

//移动后的按钮中心坐标
CGFloat centerX = self.center.x + offsetX;
CGFloat centerY = self.center.y + offsetY;
self.center = CGPointMake(centerX, centerY);

//父试图的宽高
CGFloat superViewWidth = self.superview.frame.size.width;
CGFloat superViewHeight = self.superview.frame.size.height;
CGFloat btnX = self.frame.origin.x;
CGFloat btnY = self.frame.origin.y;
CGFloat btnW = self.frame.size.width;
CGFloat btnH = self.frame.size.height;

//x轴左右极限坐标
if (btnX > superViewWidth){
//按钮右侧越界
CGFloat centerX = superViewWidth - btnW/2;
self.center = CGPointMake(centerX, centerY);
}else if (btnX < 0){
//按钮左侧越界
CGFloat centerX = btnW * 0.5;
self.center = CGPointMake(centerX, centerY);
}

//默认都是有导航条的，有导航条的，父试图高度就要被导航条占据，固高度不够
CGFloat defaultNaviHeight = 64;
CGFloat judgeSuperViewHeight = superViewHeight - defaultNaviHeight;

//y轴上下极限坐标
if (btnY <= 0){
//按钮顶部越界
centerY = btnH * 0.7;
self.center = CGPointMake(centerX, centerY);
}
else if (btnY > judgeSuperViewHeight){
//按钮底部越界
CGFloat y = superViewHeight - btnH * 0.5;
self.center = CGPointMake(btnX, y);
}
}else if (pan.state == UIGestureRecognizerStateEnded){
CGFloat btnWidth = self.frame.size.width;
CGFloat btnHeight = self.frame.size.height;
CGFloat btnY = self.frame.origin.y;
//        CGFloat btnX = self.frame.origin.x;
//按钮靠近右侧
switch (_type) {

case WQSuspendViewTypeNone:{
//自动识别贴边
if (self.center.x >= self.superview.frame.size.width/2) {

[UIView animateWithDuration:0.5 animations:^{
//按钮靠右自动吸边
CGFloat btnX = self.superview.frame.size.width - btnWidth;
self.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
}];
}else{

[UIView animateWithDuration:0.5 animations:^{
//按钮靠左吸边
CGFloat btnX = 0;
self.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
}];
}
break;
}
case WQSuspendViewTypeLeft:{
[UIView animateWithDuration:0.5 animations:^{
//按钮靠左吸边
CGFloat btnX = 0;
self.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
}];
break;
}
case WQSuspendViewTypeRight:{
[UIView animateWithDuration:0.5 animations:^{
//按钮靠右自动吸边
CGFloat btnX = self.superview.frame.size.width - btnWidth;
self.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
}];
}
}
}

}

```

```

NS_ASSUME_NONNULL_BEGIN


@property (nonatomic, copy) void (^tapBlock)(void);

/** 显示 默认为 WQSuspendViewTypeNone*/
+ (void)show;
/** 显示 + 显示的位置*/
+ (void)showWithType:(WQSuspendViewType)type;
/** 显示 + 位置 + 点击的事件 */
+ (void)showWithType:(WQSuspendViewType)type tapBlock:(void (^)(void))tapBlock;
/** 移除 */
+ (void)remove;


NS_ASSUME_NONNULL_END
```
详细请看demo
附上demo [WQSuspendView](https://github.com/liwq87112/WQSuspendView)
