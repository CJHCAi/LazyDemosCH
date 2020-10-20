//
//  HCBaseTableViewController.m
//  Heacha
//
//  Created by Allen Zhong on 15/1/12.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import "DFBaseTableViewController.h"


@implementation DFBaseTableViewController

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.style = UITableViewStylePlain;
        self.refreshHeaderControlType = DFTableViewRefreshControlTypeNative;
        self.refreshFooterControlType = DFTableViewRefreshControlTypeEGO;
        self.bAddHeader = NO;
        self.bAddFooter = NO;
        
        self.topOffset=0;
        self.bottomOffset=0;
        
        _refreshControlDic = [NSMutableDictionary dictionary];
        [_refreshControlDic setObject:[DFTableViewNativeRefreshControl class] forKey:[NSNumber numberWithInteger:DFTableViewRefreshControlTypeNative]];
        [_refreshControlDic setObject:[DFTableViewEGORefreshControl class] forKey:[NSNumber numberWithInteger:DFTableViewRefreshControlTypeEGO]];
        [_refreshControlDic setObject:[DFTableViewMJRefreshControl class] forKey:[NSNumber numberWithInteger:DFTableViewRefreshControlTypeMJ]];
        [_refreshControlDic setObject:[DFTableViewODRefreshControl class] forKey:[NSNumber numberWithInteger:DFTableViewRefreshControlTypeOD]];
    }
    return self;
}


-(void)dealloc
{
    
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initTableView];
    
}


-(void) initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:_style];
    if (_tableBackgroudColor) {
        _tableView.backgroundColor = _tableBackgroudColor;
    }
    
    _tableView.contentInset = UIEdgeInsetsMake(_topOffset, 0.0, _bottomOffset, 0.0);
    _tableView.scrollIndicatorInsets=UIEdgeInsetsMake(_topOffset, 0.0, _bottomOffset, 0.0);
    
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //顶部刷新 底部加载更多
    [self initRefreshControl];
}


-(void) initRefreshControl
{
    
    _refreshHeaderControl = [self getRefreshControl: self.refreshHeaderControlType];
    
    if (self.refreshHeaderControlType != self.refreshFooterControlType) {
        _refreshFooterControl = [self getRefreshControl: self.refreshFooterControlType];
    }else{
        _refreshFooterControl = _refreshHeaderControl;
    }
    
    
    if (_bAddHeader) {
        
        [_refreshHeaderControl addHeader];
        
    }
    
    if (_bAddFooter) {
        [_refreshFooterControl addFooter];
    }
    
}


-(DFTableViewRefreshControl *) getRefreshControl:(DFTableViewRefreshControlType) type
{
    Class clazz = [_refreshControlDic objectForKey:[NSNumber numberWithInteger:type]];
    
    DFTableViewRefreshControl  *control = (DFTableViewRefreshControl *)[[clazz alloc] init];
    
    if (type == DFTableViewRefreshControlTypeOD) {
        ((DFTableViewODRefreshControl *)control).topOffset = self.topOffset+64;
    }
    control.tableView = _tableView;
    control.delegate = self;
    return control;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_bAutoRefresh) {
        [self autoRefresh];
    }
    
    if (_bAutoLoadMore) {
    }
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
    
}

#pragma mark - Method

-(void) autoRefresh
{
    [_refreshHeaderControl autoRefresh];
    
}

-(void) startRefresh
{
    
}


-(void) startLoadMore
{
    
}

-(void) endRefresh
{
    [_refreshHeaderControl endRefresh];
}
-(void) endLoadMore
{
    [_refreshFooterControl endLoadMore];
}


-(void) loadOver
{
    [_refreshFooterControl loadOver];
    
}




#pragma - mark DFDataServiceDelegate


-(void)onRequestError:(NSError *)error
{
    [super onRequestError:error];
    
    BOOL reload = self.refreshFooterControlType == DFTableViewRefreshControlTypeEGO?YES:NO;
    [self onEnd:reload];
}

-(void)onStatusError:(DFBaseResponse *)response
{
    [super onStatusError:response];
    
    BOOL reload = self.refreshFooterControlType == DFTableViewRefreshControlTypeEGO?YES:NO;
    [self onEnd:reload];
}

- (void)onStatusOk:(DFBaseResponse *)response classType:(Class)classType
{
    [super onStatusOk:response classType:classType];
    
    [self onEnd:YES];
    
}


-(void) onEnd:(BOOL)reload
{
    if (_bAddHeader) {
        [self endRefresh];
    }
    
    if (_bAddFooter) {
        [self endLoadMore];
    }
    
    if (reload) {
        [self.tableView reloadData];
    }
}



@end
