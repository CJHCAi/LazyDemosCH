# CCPCalendar
A simple calendar
step:
1、#import "CCPCalendarManager.h"
2、[CCPCalendarManager show_signal_past:^(NSArray *stArr) {
        
    }];
Support 4 styles calendar,                        
single,single_past(show past date),mutil,mutil_past                        
3、The block 'complete' give an array for you.                       
Each element of the array is a CCPCalendarModel.
4、Use '[obj valueForKey:@"key"]' to get what you want.
5、The project with an demo.

/*---------------------------------------------------------------------------------------------------*/
1、在需要用的类里面 #import"CCPCalendarManager.h"
2、使用
CCPCalendarManager show_signal_past:^(NSArray *stArr) {
        
    }];
    调出日历
3、提供四种日历
单选，单选显示过去，多选，多选显示过去
4、回调block里面包含一个数组，数组的元素是一个model，model里面有你选择的日期的各类信息
5、使用key-value方式获取你想要的值，具体见工程注释。
