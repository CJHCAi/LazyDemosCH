//
//  DTMoreFooterView.h
//  DuiTang
//
//  Created by guanghai wen on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	PullMoreReady = 0,
	PullMoreNormal,
	PullMoreLoading,
	PullMoreHide,   //默认情况不起用
} PullMoreState;

@protocol PullMoreFooterDelegate;
@interface PullMoreFooterView : UIView {
    PullMoreState _state;
    
	UILabel *_statusLabel;
	UIActivityIndicatorView *_activityView;
    UIScrollView *scrollView;
}

- (id)initWithScrollView:(UIScrollView *)scroll;

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) PullMoreState state;
@property (nonatomic, assign) BOOL bHasBottom;

- (void)setState:(PullMoreState)aState;

- (void)finishedLoading;

@end

@protocol PullMoreFooterDelegate
- (void)pullMoreFooterViewShouldRefresh:(PullMoreFooterView*)view;
@end