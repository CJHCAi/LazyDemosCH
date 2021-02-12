//
//  ViewController.m
//  YQCalendarViewDemo
//
//  Created by problemchild on 16/8/23.
//  Copyright © 2016年 ProblenChild. All rights reserved.
//

#import "ViewController.h"

#import "YQCalendarView.h"

@interface ViewController ()<YQCalendarViewDelegate>
@property (nonatomic,strong) YQCalendarView *calendarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    YQCalendarView *view = [[YQCalendarView alloc]initWithFrame:CGRectMake(20,
                                                                           100,
                                                                           self.view.frame.size.width-40,
                                                                           300)];
    [self.view addSubview:view];
    
    //设置选中的日期，格式 yyyy-MM-dd (数组)
    view.selectedArray = @[@"2021-01-23",
                           @"2021-01-21",
                           @"2017-01-20",
                           @"2021-01-15",
                           @"2017-01-12",
                           @"2017-02-05",
                           @"2017-02-26",
                           @"2017-02-29",
                           @"2017-03-14",
                           @"2017-03-20",
                           @"2017-03-23",
                           ];
    
    //单独添加选中个某一天
    [view AddToChooseOneDay:@"2021-02-10"];
    self.calendarView = view;
    //--------------------------------------------------自定义显示
    
    /*
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
    view.dayColor          = [UIColor redColor];
    */
    
    //--------------------------------------------------如果需要接收点击后的代理
    view.delegate = self;
}

//接收点击的代理方法
//使用String格式，是为了避免因时区可能会导致的不必要的麻烦
-(void)YQCalendarViewTouchedOneDay:(NSString *)dateString{
    NSLog(@"点击了：%@",dateString);
    [self.calendarView AddToChooseOneDay:dateString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
