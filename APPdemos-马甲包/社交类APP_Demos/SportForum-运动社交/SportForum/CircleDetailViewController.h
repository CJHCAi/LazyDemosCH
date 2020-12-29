//
//  CircleDetailViewController.h
//  SportForum
//
//  Created by liyuan on 14-9-12.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CircleDetailViewController : BaseViewController

@property(nonatomic, copy) NSString* strCircleType;
@property(nonatomic, assign) e_article_tag_type eArticleTagType;

@end
