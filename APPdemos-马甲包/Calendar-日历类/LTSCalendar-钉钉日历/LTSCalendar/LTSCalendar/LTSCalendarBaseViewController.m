//
//  LTSCalendarBaseViewController.m
//  LTSCalendar
//
//  Created by 李棠松 on 2016/12/28.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import "LTSCalendarBaseViewController.h"

@interface LTSCalendarBaseViewController ()<UITableViewDataSource,UITableViewDelegate,LTSCalendarEventSource>

@end

@implementation LTSCalendarBaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self lts_InitUI];
}
- (void)lts_InitUI{
    self.calendarView = [[LTSCalendarView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.calendarView];
    self.calendarView.tableView.delegate = self;
    self.calendarView.tableView.dataSource = self;
    self.calendarView.calendar.eventSource = self;
   
    self.calendarView.calendar.calendarAppearance.weekDayHeight = 40;
    self.calendarView.calendar.calendarAppearance.weekDayTextFont = [UIFont systemFontOfSize:14];
    self.calendarView.calendar.currentDateSelected = [NSDate date];
    [self.calendarView.calendar reloadAppearance];
    
    
}





#pragma mark -- LTSCalendarEventSource --
- (void)calendarDidLoadPage:(LTSCalendarManager *)calendar{
    
}
// 该日期是否有事件
- (BOOL)calendarHaveEvent:(LTSCalendarManager *)calendar date:(NSDate *)date
{
    return NO;
}
//当前 选中的日期  执行的方法
- (void)calendarDidDateSelected:(LTSCalendarManager *)calendar date:(NSDate *)date
{
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[UITableViewCell new];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
    
}










//当tableView 滚动完后  判断位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat startSingleOriginY = self.calendarView.calendar.calendarAppearance.weekDayHeight*5;
    
    self.calendarView.dragEndOffectY  = scrollView.contentOffset.y;
    //<0方向向上 >0 方向向下
    
    //用于判断滑动方向
    CGFloat distance = self.calendarView.dragStartOffectY - self.calendarView.dragEndOffectY;
    
    
    if (self.calendarView.tableView.contentOffset.y > CriticalHeight ) {
        if (self.calendarView.tableView.contentOffset.y < startSingleOriginY) {
            if (self.calendarView.tableView.contentOffset.y > startSingleOriginY-CriticalHeight) {
                [self.calendarView showSingleWeekView:YES];
                return;
            }
            //向下滑动
            if (distance < 0) {
                [self.calendarView showSingleWeekView:YES];
            }
            
            else [self.calendarView showAllView:YES];
        }
        
        
    }
    else if (self.calendarView.tableView.contentOffset.y > 0)
        [self.calendarView showAllView:YES];
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.calendarView.containerView.backgroundColor = self.calendarView.calendar.calendarAppearance.backgroundColor;
    
    CGFloat startSingleOriginY = self.calendarView.calendar.calendarAppearance.weekDayHeight*5;
    
    self.calendarView.dragEndOffectY  = scrollView.contentOffset.y;
    //<0方向向上 >0 方向向下
    CGFloat distance = self.calendarView.dragStartOffectY - self.calendarView.dragEndOffectY;
    
    
    if (self.calendarView.tableView.contentOffset.y>CriticalHeight ) {
        if (self.calendarView.tableView.contentOffset.y<startSingleOriginY) {
            if (self.calendarView.tableView.contentOffset.y>startSingleOriginY - CriticalHeight) {
                [self.calendarView showSingleWeekView:YES];
                return;
            }
            if (distance<0) {
                [self.calendarView showSingleWeekView:YES];
            }
            else [self.calendarView showAllView:YES];
        }
        
        
    }
    else if (self.calendarView.tableView.contentOffset.y > 0)
        [self.calendarView showAllView:YES];
    
    
    
    
}

//当手指 触摸 滚动 就 设置 上一次选择的 跟当前选择的 周 的index 相等
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.calendarView.dragStartOffectY  = scrollView.contentOffset.y;
    
    self.calendarView.calendar.lastSelectedWeekOfMonth = self.calendarView.calendar.currentSelectedWeekOfMonth;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    
    CGFloat offectY = scrollView.contentOffset.y;
    
    CGRect contentFrame = self.calendarView.calendar.contentView.frame;
    
    
    //  当 offectY 大于 滚动到要悬浮的位置
    if ( offectY>self.calendarView.calendar.startFrontViewOriginY) {
        
        self.calendarView.containerView.backgroundColor = [UIColor whiteColor];
        contentFrame.origin.y = -self.calendarView.calendar.startFrontViewOriginY;
        
        self.calendarView.calendar.contentView.frame = contentFrame;
        
        
        //把 selectedView 插入到 containerView 的最上面
        [self.calendarView.containerView insertSubview:self.calendarView.calendar.selectedWeekView atIndex:999];
        // 把tableView 里的 日历视图 插入到 表底部
        [self.calendarView.containerView insertSubview:self.calendarView.calendar.contentView atIndex:0];
        [self.calendarView.calendar setWeekViewHidden:YES toIndex:self.calendarView.calendar.currentSelectedWeekOfMonth-1];
        
    }else{
        self.calendarView.containerView.backgroundColor = self.calendarView.calendar.calendarAppearance.backgroundColor;
        contentFrame.origin.y = 0;
        self.calendarView.calendar.contentView.frame = contentFrame;
        [self.calendarView.calendar setWeekViewHidden:NO toIndex:self.calendarView.calendar.currentSelectedWeekOfMonth-1];
        [self.calendarView.headerView insertSubview:self.calendarView.calendar.selectedWeekView atIndex:1];
        [self.calendarView.headerView insertSubview:self.calendarView.calendar.contentView atIndex:0];
        
    }
    
    
    
}



- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    
    return dateFormatter;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
