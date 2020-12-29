//
//  ArticlePublicViewController.h
//  SportForum
//
//  Created by liyuan on 14-9-11.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ArticlePublicViewController : BaseViewController

@property(nonatomic, copy) NSString* articleParent;
@property(nonatomic, strong) TasksInfo *taskInfo;
@property(nonatomic, strong) NSString *strTitle;

@end
