//
//  ArticlePagesViewController.h
//  SportForum
//
//  Created by liyuan on 3/26/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ArticlePagesViewController : BaseViewController

@property(nonatomic, strong) NSMutableArray* arrayArticleInfos;
@property(nonatomic, assign) NSUInteger currentIndex;

@end
