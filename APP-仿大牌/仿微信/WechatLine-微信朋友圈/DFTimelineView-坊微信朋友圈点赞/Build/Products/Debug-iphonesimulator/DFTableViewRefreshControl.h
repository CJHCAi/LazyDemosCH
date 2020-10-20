//
//  DFTableViewRefreshPerformer.h
//  Heacha
//
//  Created by Allen Zhong on 15/2/13.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DFTableViewRefreshControlDelegate <NSObject>

-(void) startRefresh;
-(void) startLoadMore;

@end


@interface DFTableViewRefreshControl : NSObject

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) id<DFTableViewRefreshControlDelegate> delegate;


-(void) addHeader;
-(void) addFooter;


-(void) startRefresh;
-(void) startLoadMore;

-(void) autoRefresh;

-(void) endRefresh;
-(void) endLoadMore;

-(void) loadOver;


- (instancetype)initWithTarget:(id)delegate tableView:(UITableView *) tableView;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com