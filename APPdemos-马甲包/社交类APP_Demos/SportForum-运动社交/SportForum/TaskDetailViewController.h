//
//  TaskDetailViewController.h
//  SportForum
//
//  Created by liyuan on 7/10/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TaskDetailViewController : BaseViewController

@property(nonatomic, assign) NSUInteger taskId;
@property(nonatomic, assign) e_task_type eTaskType;
@property(assign, nonatomic) long long duration;

//UNIT 米
@property(assign, nonatomic) NSUInteger distance;

@end
