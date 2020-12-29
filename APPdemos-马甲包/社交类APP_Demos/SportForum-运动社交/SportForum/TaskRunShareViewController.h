//
//  TaskRunShareViewController.h
//  SportForum
//
//  Created by liyuan on 7/10/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void(^FinishBlock)(void);

@interface TaskRunShareViewController : BaseViewController

@property (nonatomic, assign) NSUInteger nTaskId;
@property (nonatomic, assign) NSString* strUserId;
@property(nonatomic, strong) FinishBlock finishBlock;

@end
