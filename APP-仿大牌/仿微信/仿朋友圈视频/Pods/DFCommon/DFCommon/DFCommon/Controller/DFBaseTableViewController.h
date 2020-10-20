//
//  HCBaseTableViewController.h
//  Heacha
//
//  Created by Allen Zhong on 15/1/12.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFBaseViewController.h"

#import "DFTableViewNativeRefreshControl.h"
#import "DFTableViewMJRefreshControl.h"
#import "DFTableViewEGORefreshControl.h"
#import "DFTableViewODRefreshControl.h"


typedef NS_ENUM(NSInteger,DFTableViewRefreshControlType)
{
    DFTableViewRefreshControlTypeNative,
    DFTableViewRefreshControlTypeMJ,
    DFTableViewRefreshControlTypeEGO,
    DFTableViewRefreshControlTypeOD,
    
};

@interface DFBaseTableViewController : DFBaseViewController<UITableViewDataSource,UITableViewDelegate,DFTableViewRefreshControlDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) UITableViewStyle style;

@property (nonatomic,assign) DFTableViewRefreshControlType refreshHeaderControlType;
@property (nonatomic,assign) DFTableViewRefreshControlType refreshFooterControlType;
@property (nonatomic,strong) DFTableViewRefreshControl *refreshHeaderControl;
@property (nonatomic,strong) DFTableViewRefreshControl *refreshFooterControl;

@property (nonatomic,strong) NSMutableDictionary *refreshControlDic;

@property (nonatomic,assign) BOOL bAddHeader;
@property (nonatomic,assign) BOOL bAddFooter;
@property (nonatomic,assign) BOOL bAutoRefresh;
@property (nonatomic,assign) BOOL bAutoLoadMore;
@property (nonatomic,strong) UIColor *tableBackgroudColor;

@property (nonatomic,assign) NSInteger topOffset;
@property (nonatomic,assign) NSInteger bottomOffset;





-(void) autoRefresh;

-(void) endRefresh;
-(void) endLoadMore;

-(void) loadOver;




@end
