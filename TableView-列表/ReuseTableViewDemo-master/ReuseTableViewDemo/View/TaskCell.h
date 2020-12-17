//
//  TaskCell.h
//  ReuseTableViewDemo
//
//  Created by 萧奇 on 2017/10/1.
//  Copyright © 2017年 萧奇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol TaskCellClickDelegate <NSObject>

// 增加任务
- (void)addTaskToRecord:(Task *)task;
// 删除任务
- (void)deleteTaskToRecord:(Task *)task;

@end

@interface TaskCell : UITableViewCell

@property (nonatomic, weak)id<TaskCellClickDelegate> relateDelegate;

@property (nonatomic, strong)Task *task;

@property (nonatomic, strong)UIButton *imageButton;

@end
