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
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com