//
//  DFTableViewODRefreshControl.m
//  Heacha
//
//  Created by Allen Zhong on 15/2/13.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import "DFTableViewODRefreshControl.h"

@implementation DFTableViewODRefreshControl


- (instancetype)initWithTarget:(id)delegate tableView:(UITableView *) tableView topOffset:(CGFloat)topOffset
{
    self = [super initWithTarget:delegate tableView:tableView];
    if (self) {
        self.topOffset =topOffset;
        
    }
    return self;
}


-(void) addHeader
{
    if (_refreshControl == nil) {
       // _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView topOffset:self.topOffset];
        
        
        
        _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
        
        [_refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    }
}


-(void) addFooter
{
    
}


-(void) autoRefresh
{
    [_refreshControl beginRefreshing];
}


-(void) endRefresh
{
    [_refreshControl endRefreshing];
}

-(void) endLoadMore
{
}


-(void) loadOver
{
    
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    [self startRefresh];
}

@end
