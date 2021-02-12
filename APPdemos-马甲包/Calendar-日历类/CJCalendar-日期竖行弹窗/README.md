# CJCalendar

## 这是一个可以显示农历和公历的日历控制器

![image](https://github.com/chjsun/readmeImage/blob/master/CJCalendar/modal.gif)

![image](https://github.com/chjsun/readmeImage/blob/master/CJCalendar/selecttitle.gif)

![image](https://github.com/chjsun/readmeImage/blob/master/CJCalendar/chuanzhi.gif)

使用这个日历灰常简单
只要把calendar拖到你的项目中，就可以直接用了

### 步骤：
#### 一 初始化

初始化控制器，代理监听，设置大小
```
  CJCalendarViewController *calendarController = [[CJCalendarViewController alloc] init];
  calendarController.view.frame = self.view.frame;// 显示底层controller
  calendarController.delegate = self;

```
#### 二 添加控制器
```
  [self presentViewController:calendarController animated:YES completion:nil];
```

#### 三 实现代理方法

可选代理方法，用来接受返回的年月日
```
-(void)CalendarViewController:(CJCalendarViewController *)controller didSelectActionYear:(NSString *)year month:(NSString *)month day:(NSString *)day;
```

### 可选的方法/属性
#### 一 指定初始时间
默认不指定就是当前时间

```
/** 直接指定时间 */
@property (nonatomic, strong) NSDate *Date;
/** 传入年、月、日 ，设置时间 */
-(void) setYear:(NSString *)year month:(NSString *)month day:(NSString *)day;

```
#### 二 指定颜色

```
//以下属性均有默认值
/** HeaderColor default white 上部显示区域标题的颜色*/
@property (nonatomic, copy) UIColor *headerColor;
/** HeaderBackgroundColor default rgb (60, 45, 140) 上部显示区域标题栏背景颜色 */
@property (nonatomic, copy) UIColor *headerBackgroundColor;
/** contentColor default white 上部显示区域内容文本颜色*/
@property (nonatomic, copy) UIColor *contentColor;
/** contentBackgroundColor default rgb (71, 55, 169) 上部显示区域内容背景颜色*/
@property (nonatomic, copy) UIColor *contentBackgroundColor;

```
例如
```
    calendarController.headerBackgroundColor = [UIColor purpleColor];
    calendarController.headerColor = [UIColor whiteColor];
    calendarController.contentColor = [UIColor whiteColor];
    calendarController.contentBackgroundColor = [UIColor purpleColor];
```
#### 三 制定背景色和透明度
默认透明度0.8 黑色 (ios8+)
```
-(void) setBgAlpha:(CGFloat)alpha color:(UIColor *)bgColor;
```

-------------------
-------------------
-------------------


