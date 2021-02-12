# YQCalendarView
#### 微博：畸形滴小男孩
### iOS端 日历控件-可自定义外观
-直接拖到工程中使用

 ![image](https://github.com/976431yang/YQCalendarView/blob/master/DEMO/ScreenShot/screenshot.gif)

### Example Code:
##### 初始化：
```objective-c
	YQCalendarView *view = [[YQCalendarView alloc]initWithFrame:CGRectMake(20,
                                                                           100,
                                                                           self.view.frame.size.width-40,
                                                                           300)];
    [self.view addSubview:view];
```
##### 设置选中的日期，格式 yyyy-MM-dd (数组)
```objective-c
    view.selectedArray = @[@"2016-08-23",
                           @"2016-08-21",
                           @"2016-08-20",
                           @"2016-08-15",
                           @"2016-08-12",
                           @"2016-08-05",
                           @"2016-07-26",
                           @"2016-07-29",
                           @"2016-09-14",
                           @"2016-09-20",
                           @"2016-09-23",
                           ];
```
##### 单独添加选中个某一天
```objective-c
    [view AddToChooseOneDay:@"2016-08-10"];
```

#### 自定义外观
```objective-c
	//整体背景色
    view.backgroundColor   = [UIColor blueColor];

    //选中的日期的背景颜色
    view.selectedBackColor = [UIColor lightGrayColor];

    //选中的日期下方的图标
    view.selectedIcon      = [UIImage imageNamed:@""];

    //下一页按钮的图标
    view.nextBTNIcon       = [UIImage imageNamed:@""];

    //前一页按钮的图标
    view.preBTNIcon        = [UIImage imageNamed:@""];

    //上方日期标题的字体
    view.titleFont         = [UIFont systemFontOfSize:17];

    //上方日期标题的颜色
    view.titleColor        = [UIColor blackColor];

    //下方日历的每一天的字体
    view.dayFont           = [UIFont systemFontOfSize:17];

    //下方日历的每一天的字体颜色
    view.dayColor          = [UIColor blackColor];


```
#### 监听点击事件(可选)
```objective-c
    //遵循代理<YQCalendarViewDelegate>
    view.delegate = self;

    //接收点击的代理方法
    //使用String格式，是为了避免因时区可能会导致的不必要的麻烦
    -(void)YQCalendarViewTouchedOneDay:(NSString *)dateString{
      NSLog(@"点击了：%@",dateString);
    }


```



