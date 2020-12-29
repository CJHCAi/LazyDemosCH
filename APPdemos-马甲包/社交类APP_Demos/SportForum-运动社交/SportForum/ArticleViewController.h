//
//  ArticleViewController.h
//  SportForum
//
//  Created by zhengying on 6/12/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportForumAPI.h"
#import "BaseViewController.h"

/*
@interface ArticleDetailInfo

@property(nonatomic, copy) NSString* article_id;
@property(nonatomic, copy) NSString* parent_article_id;
@property(nonatomic, copy) NSString* author_id;
@property(nonatomic, copy) NSString* author_name;
@property(nonatomic, copy) NSString* author_profile_icon;
@property(nonatomic, copy) NSDate * dateTime;
@property(nonatomic, assign) NSInteger thumbCount;
@property(nonatomic, assign) NSInteger commentCount;
@property(nonatomic, strong) NSMutableArray* artcleSegments;
@end
 */

typedef void (^ThumbBlock)(void);
typedef void (^ShareBlock)(void);

@interface ArticleViewController : BaseViewController
@property(nonatomic, strong) ArticlesObject* articleObject;
@property(nonatomic, strong) ThumbBlock thumbBlock;
@property(nonatomic, strong) ShareBlock shareBlock;
@property(nonatomic, assign) BOOL bRewardAction;

- (UIImage*) renderScrollViewToImage;

@end
