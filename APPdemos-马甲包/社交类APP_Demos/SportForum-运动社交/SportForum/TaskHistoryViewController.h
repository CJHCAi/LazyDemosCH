//
//  TaskHistoryViewController.h
//  SportForum
//
//  Created by liyuan on 14-10-11.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TaskHistoryViewController : BaseViewController

@property(nonatomic, assign) NSUInteger taskId;
@property(nonatomic, assign) e_task_type eTaskType;

@end
