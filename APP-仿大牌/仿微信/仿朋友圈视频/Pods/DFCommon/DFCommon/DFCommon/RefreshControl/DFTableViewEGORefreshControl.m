//
//  DFTableViewEGORefreshControl.m
//  Heacha
//
//  Created by Allen Zhong on 15/2/13.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import "DFTableViewEGORefreshControl.h"

@implementation DFTableViewEGORefreshControl


-(void) addHeader
{
    [self addRefreshTableHeaderView];
}


-(void) addFooter
{
    [self addLoadMoreTableFooterView];
}


-(void) autoRefresh
{
}


-(void) endRefresh
{
    [self.refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

-(void) endLoadMore
{
    [self.pullMoreFooterView setState:PullMoreNormal];
}


-(void) loadOver
{
    [self.pullMoreFooterView setState:PullMoreHide];
}



#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.refreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    [self.refreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
//}



#pragma mark - EGORefreshTableHeaderDelegate

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return NO;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date]; // should return date data source was last changed
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    if(!self.bIsLoading)
    {
        self.bIsLoading = YES;
        [self performSelector:@selector(startRefresh) withObject:nil afterDelay:0.0];
    }
}


#pragma mark - PullMoreFooterDelegate

- (void)pullMoreFooterViewShouldRefresh:(PullMoreFooterView*)view
{
    [self startLoadMore];
}




#pragma mark - Method

- (void)addRefreshTableHeaderView
{
    self.bIsLoading = NO;
    
    if (self.refreshTableHeaderView == nil)
    {
        _refreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.tableView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        self.refreshTableHeaderView.delegate = self;
        self.refreshTableHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        //self.refreshTableHeaderView.backgroundColor = [UIColor redColor];
        //self.refreshTableHeaderView.bIsTransparent = YES;
        
    }
    [self.tableView addSubview:self.refreshTableHeaderView];
}

- (void)addLoadMoreTableFooterView
{
    if(self.pullMoreFooterView == nil)
    {
        _pullMoreFooterView = [[PullMoreFooterView alloc] initWithScrollView:self.tableView];
        self.pullMoreFooterView.delegate = self;
        self.pullMoreFooterView.backgroundColor = [UIColor clearColor];
    }
    [self.tableView addSubview:self.pullMoreFooterView];
    [self.pullMoreFooterView setState:PullMoreNormal];
}


@end
