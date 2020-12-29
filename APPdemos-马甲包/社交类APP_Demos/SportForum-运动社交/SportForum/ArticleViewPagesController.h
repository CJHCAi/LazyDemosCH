//
//  ArticleViewPagesController.h
//  SportForum
//
//  Created by zhengying on 6/12/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ArticleViewPagesController : BaseViewController
@property(nonatomic, strong) NSMutableArray* arrayArticleInfos;
@property(nonatomic, assign) NSUInteger currentIndex;
@property(nonatomic, assign) BOOL bOwnArticles;

@end
