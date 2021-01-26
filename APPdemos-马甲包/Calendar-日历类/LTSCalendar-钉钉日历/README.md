# LTSCalendar
仿钉钉 管理日历

![image](https://github.com/BossLee1220/LTSCalendar/blob/master/gif.gif)
##使用方法
###新建一个类(遵守协议 LTSCalendarEventSource,UITableViewDataSource,UITableViewDataSource 才有相应代码提示)   继承LTSCalendarBaseViewController 重写方法 
 
    
    - (void)lts_InitUI{
    [super lts_InitUI];
    self.calendarView.frame = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height-200);
    //添加一下自定义视图
    }
      
##基础样式（具体样式见类 LTSCalendarAppearance.h）
设置完样式之后注意  calendarView.calendar reloadAppearance 刷新

##分别实现代理方法    
 
    //该日期是否有事件
    - (BOOL)calendarHaveEvent:(LTSCalendarManager *)calendar date:(NSDate *)date;
    // 日期后的执行的操作
    - (void)calendarDidDateSelected:(LTSCalendarManager *)calendar date:(NSDate *)date;
    //翻页完成后的操作
    - (void)calendarDidLoadPage:(LTSCalendarManager *)calendar;
