//
//  RefreshTableView.h
//  SportForum
//
//  Created by zhengying on 6/9/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
@interface RefreshTableView : UITableView

// tableview pull refresh
-(void)enablePullRefreshHeaderViewTarget:(id)target DidTriggerRefreshAction:(SEL)action;
-(void)completePullHeaderRefresh;

//footer loading refresh
-(void)enablePullRefreshFooterViewTarget:(id)target DidTriggerRefreshAction:(SEL)action;
-(void)completePullFooterRefresh;

@property(nonatomic, strong) EGORefreshTableHeaderView* refreshHeaderView;
@property(nonatomic, strong) UIActivityIndicatorView* tableFooterActivityIndicator;

@end
