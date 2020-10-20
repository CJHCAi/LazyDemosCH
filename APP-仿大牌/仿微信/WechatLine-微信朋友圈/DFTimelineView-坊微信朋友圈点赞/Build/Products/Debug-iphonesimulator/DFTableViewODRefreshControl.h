//
//  DFTableViewODRefreshControl.h
//  Heacha
//
//  Created by Allen Zhong on 15/2/13.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import "DFTableViewRefreshControl.h"
#import "ODRefreshControl.h"

@interface DFTableViewODRefreshControl : DFTableViewRefreshControl

@property (strong,nonatomic) ODRefreshControl *refreshControl;
@property (assign,nonatomic) CGFloat topOffset;


- (instancetype)initWithTarget:(id)delegate tableView:(UITableView *) tableView topOffset:(CGFloat)topOffset;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com