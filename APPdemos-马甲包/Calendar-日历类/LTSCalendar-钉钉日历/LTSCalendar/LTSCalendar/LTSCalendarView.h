//
//  ViewController.h
//  scrollTest
//
//  Created by leetangsong_macbk on 16/5/19.
//  Copyright © 2016年 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCalendarManager.h"



#define kTopBarWithStatusHeight 64
#define CriticalHeight 30  //滚动的 临界高度

@interface LTSCalendarView : UIView
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,strong) LTSCalendarManager *calendar;


@property (nonatomic,strong)LTSCalendarContentView *contentView;

@property (nonatomic,strong) UIView *headerView;
// 手指触摸 开始滚动 tableView 的offectY
@property (nonatomic,assign)CGFloat dragStartOffectY;
// 手指离开 屏幕 tableView 的offectY
@property (nonatomic,assign)CGFloat dragEndOffectY;

///回到今天
- (void)backToToday;

//回到全部显示初始位置
- (void)showAllView:(BOOL)animate;
//滚回到 只显示 一周 的 位置
- (void)showSingleWeekView:(BOOL)animate;

@end

