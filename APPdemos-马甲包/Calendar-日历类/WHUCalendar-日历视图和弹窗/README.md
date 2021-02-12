![image](https://github.com/tiger8888/WHUCalendar/blob/master/WHUCalendarDemo1.gif)

####日历组件,支持农历显示,操作流畅
---
1. 支持IOS7+
2. 支持xib
3. 支持农历

####用法:
---
1. 直接在xib中设置UIView的类为WHUCalendarView

2. 代码使用WHUCalendarView:
```objc
    WHUCalendarView* cview=[[WHUCalendarView alloc] init];
    CGSize s=[cview sizeThatFits:CGSizeMake(300, FLT_MAX)];
    cview.frame=CGRectMake(0, 0, s.width, s.height);
    cview.onDateSelectBlk=^(NSDate* date){
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy年MM月dd"];
        NSString *dateString = [format stringFromDate:date];
        NSLog(@"%@",dateString);
   };
```

3.提供了类WHUCalendarPopView用于弹出选择:
```objc
@interface ViewController ()
{
    WHUCalendarPopView* _pop;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pop=[[WHUCalendarPopView alloc] init];
    _pop.onDateSelectBlk=^(NSDate* date){
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy年MM月dd"];
        NSString *dateString = [format stringFromDate:date];
        NSLog(@"%@",dateString);
   };
}
- (IBAction)onBtnClick:(id)sender {
    [_pop show];
}
```

4.设置为每个日期设置tag string
```objc
    //calMonth存放的当前日历的年,月, itemDate存放单个日期的年,月,日
    _calview.tagStringOfDate=^NSString*(NSArray* calm,NSArray* itemDateArray){
        NSLog(@"%@",calm);
        //如果当前日期中的天数,可以被5整除,显示 预约
        if([itemDateArray[2] integerValue]%5==0){
          return @"预约";
        }
        else{
            return nil;
        }
    };
```

5.感谢 魂如烟 同学的深度测试.

