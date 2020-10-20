//
//  DFTableViewNativeRefreshPerformer.m
//  Heacha
//
//  Created by Allen Zhong on 15/2/13.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import "DFTableViewNativeRefreshControl.h"

@implementation DFTableViewNativeRefreshControl


-(void) addHeader
{
    if (_refreshControl == nil) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    }
    [self.tableView addSubview:_refreshControl];
}


-(void) addFooter
{
    
}

-(void) autoRefresh
{
    
    if (self.refreshControl.refreshing) {
        //TODO: 已经在刷新数据了
    } else {
        
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^(void){
                             self.tableView.contentOffset = CGPointMake(0, -130);
                         } completion:^(BOOL finished){
                             [self.refreshControl beginRefreshing];
                             [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
                         }];
    }

}


-(void) endRefresh
{
    if (_refreshControl != nil) {
        [_refreshControl endRefreshing];
    }
}
-(void) endLoadMore
{
}


-(void) loadOver
{
    
}



@end
