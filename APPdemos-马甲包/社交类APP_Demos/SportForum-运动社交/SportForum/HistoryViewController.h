//
//  HistoryViewController.h
//  SportForum
//
//  Created by zyshi on 14-9-17.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

enum
{
    HISTORY_TYPE_SPORT = 0,
    HISTORY_TYPE_GAME,
    HISTORY_TYPE_ALL
};

@interface HistoryViewController : BaseViewController

@property(nonatomic, strong) UserInfo * userInfo;

- (void)setHistoryType:(int)ntype;

@end
