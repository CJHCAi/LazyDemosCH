//
//  DFBaseTimeLineViewController.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import <MLLabel+Size.h>

#import <DFBaseViewController.h>


@interface DFBaseTimeLineViewController : DFBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSUInteger coverWidth;
@property (nonatomic, assign) NSUInteger coverHeight;
@property (nonatomic, assign) NSUInteger userAvatarSize;


-(void) endLoadMore;

-(void) endRefresh;

-(void) onClickHeaderUserAvatar;


-(void) setCover:(NSString *) url;
-(void) setUserAvatar:(NSString *) url;
-(void) setUserNick:(NSString *)nick;
-(void) setUserSign:(NSString *)sign;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com