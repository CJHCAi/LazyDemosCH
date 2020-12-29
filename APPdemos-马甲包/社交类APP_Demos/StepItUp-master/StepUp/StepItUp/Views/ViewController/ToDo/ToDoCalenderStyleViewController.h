//
//  HomeViewController.h
//  changer
//
//  Created by syfll on 14-12-2.
//  Copyright (c) 2014年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JTCalendar.h"

@interface ToDoCalenderStyleViewController : UIViewController<JTCalendarDataSource,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *changeDateBtn;

// The duration of the expand/collapse animation
@property (nonatomic) float animationDuration;
// The spacing between menu buttons when expanded
@property (nonatomic) float buttonSpacing;
// The switch of addButton
@property (nonatomic, readonly) BOOL isCollapsed;

//旧的，已经用不到了
//@property (assign, nonatomic) BOOL is_hiden;

@property (strong, nonatomic) JTCalendar *calendar;

//-(void)HidenView;//隐藏左边的日历（修改日历的bug）
//-(void)ShowView;//显示左边的日历（修改日历的bug）

@end
