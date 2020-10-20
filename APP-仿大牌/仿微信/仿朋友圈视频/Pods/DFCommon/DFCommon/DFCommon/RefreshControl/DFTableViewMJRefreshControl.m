//
//  DFTableViewMJRefreshControl.m
//  Heacha
//
//  Created by Allen Zhong on 15/2/13.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import "DFTableViewMJRefreshControl.h"

@implementation DFTableViewMJRefreshControl

-(void) addHeader
{
    //[self.tableView addHeaderWithTarget:self action:@selector(startRefresh)];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(startRefresh)];

}


-(void) addFooter
{
    //[self.tableView addFooterWithTarget:self action:@selector(startLoadMore)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(startLoadMore)];
}

-(void) autoRefresh
{
    //[self.tableView headerBeginRefreshing];
    [self.tableView.header beginRefreshing];
}


-(void) endRefresh
{
    //[self.tableView headerEndRefreshing];
    [self.tableView.header endRefreshing];
}
-(void) endLoadMore
{
    //[self.tableView footerEndRefreshing];
    [self.tableView.footer endRefreshing];
    
}


-(void) loadOver
{
    [self.tableView.footer noticeNoMoreData];
    
}

@end
