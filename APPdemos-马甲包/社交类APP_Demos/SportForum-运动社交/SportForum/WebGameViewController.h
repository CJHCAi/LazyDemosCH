//
//  WebGameViewController.h
//  SportForum
//
//  Created by liyuan on 12/23/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WebGameViewController : BaseViewController

@property(nonatomic, assign) e_game_type eGameType;
@property(nonatomic, copy) NSString *gameTitle;
@property(nonatomic, copy) NSString *gameDir;
@property(nonatomic, strong) TasksInfo *taskInfo;

@end
