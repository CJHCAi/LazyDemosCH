//
//  RefreshTableView.m
//  SportForum
//
//  Created by zhengying on 6/9/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "RefreshTableView.h"


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface RefreshTableView() <EGORefreshTableHeaderDelegate>
@end

@implementation RefreshTableView {
    BOOL _bUpHandleLoading;
    __weak id _headerRefrshActionTarget;
    SEL _didTriggerHeaderRefreshAction;
    
    __weak id _footerRefrshActionTarget;
    SEL _didTriggerFooterRefreshAction;
    BOOL _blDownHandleLoading;
    UIActivityIndicatorView *_tableFooterActivityIndicator;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)completePullHeaderRefresh {
    _bUpHandleLoading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

-(void)completePullFooterRefresh {
    [self tableBootomShow:NO];
    _blDownHandleLoading = NO;
}

-(void)enablePullRefreshHeaderViewTarget:(id)target DidTriggerRefreshAction:(SEL)action {
    _didTriggerHeaderRefreshAction = action;
    _headerRefrshActionTarget = target;
    [self creaetPullRefreshHeaderView];
}

-(void)enablePullRefreshFooterViewTarget:(id)target DidTriggerRefreshAction:(SEL)action {
    _didTriggerFooterRefreshAction = action;
    _footerRefrshActionTarget = target;
    [self creaetPullRefreshFooterView];
}

-(void)creaetPullRefreshHeaderView {
    //Create RefreshHeaderView
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                         0.0f - self.frame.size.height,
                                                                                         self.frame.size.width,
                                                                                         self.frame.size.height)];
        _refreshHeaderView.delegate = self;
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        [self addSubview:_refreshHeaderView];
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
}


-(void)creaetPullRefreshFooterView {
    self.tableFooterView = nil;
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 40.0f)];
    self.tableFooterView.backgroundColor = [UIColor clearColor];
    _tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [_tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    
    
    _tableFooterActivityIndicator.frame = CGRectOffset(_tableFooterActivityIndicator.frame,
                                                       self.tableFooterView.frame.size.width/2 - _tableFooterActivityIndicator.frame.size.width/2,
                                                       self.tableFooterView.frame.size.height/2 - _tableFooterActivityIndicator.frame.size.height/2);
    
    [self.tableFooterView addSubview:_tableFooterActivityIndicator];
    
    [self tableBootomShow:NO];
}

-(void)tableBootomShow:(BOOL)blShow {
    if (blShow) {
        [_tableFooterActivityIndicator startAnimating];
    }
    else {
        [_tableFooterActivityIndicator stopAnimating];
    }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    _bUpHandleLoading = YES;
    [_headerRefrshActionTarget performSelector:_didTriggerHeaderRefreshAction withObject:nil afterDelay:0.2];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    return _bUpHandleLoading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat y = offset.y + bounds.size.height - inset.bottom;
    CGFloat h = size.height;
    
    NSLog(@"%.2f %.2f %d", y, h, _blDownHandleLoading);
    
    if((y > (h + 50) && h > bounds.size.height) && _blDownHandleLoading == NO) {
        if ([_footerRefrshActionTarget respondsToSelector:_didTriggerFooterRefreshAction]) {
            [self tableBootomShow:YES];
            _blDownHandleLoading = YES;
            SuppressPerformSelectorLeakWarning(
                                               [_footerRefrshActionTarget performSelector:_didTriggerFooterRefreshAction];
                                               );
        }
    }
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
