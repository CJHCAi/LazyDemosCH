//
//  DFTableViewEGORefreshControl.h
//  Heacha
//
//  Created by Allen Zhong on 15/2/13.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import "DFTableViewRefreshControl.h"

#import "EGORefreshTableHeaderView.h"
#import "PullMoreFooterView.h"

@interface DFTableViewEGORefreshControl : DFTableViewRefreshControl<EGORefreshTableHeaderDelegate, PullMoreFooterDelegate>

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshTableHeaderView;
@property (nonatomic, strong) PullMoreFooterView *pullMoreFooterView;
@property (nonatomic, assign) BOOL bIsLoading;

@end
