//
//  GameBoardViewController.h
//  SportForum
//
//  Created by liyuan on 2/3/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface GameBoardViewController : BaseViewController

@property (nonatomic, assign) board_query_type eQueryType;
@property (nonatomic, assign) e_game_type eGameType;
@property (nonatomic, assign) BOOL isTask;
@property (nonatomic, assign) NSUInteger nCurScore;

@end
