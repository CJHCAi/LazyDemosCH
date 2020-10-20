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
