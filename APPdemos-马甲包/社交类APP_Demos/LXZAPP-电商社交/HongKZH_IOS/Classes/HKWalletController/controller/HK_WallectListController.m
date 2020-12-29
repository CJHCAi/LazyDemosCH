//
//  HK_WallectListController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_WallectListController.h"
#import "HK_walletListCell.h"
#import "HK_BaseRequest.h"
#import "HK_LogDetailController.h"
#import "HK_WalletTool.h"
#import "HK_LogHeaderView.h"
@interface HK_WallectListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * listTableView;
@property (nonatomic, strong)NSMutableArray * dataSources;
@property (nonatomic, strong)HK_LogHeaderView *header;
@property (nonatomic, assign)int page;

@end

@implementation HK_WallectListController
-(void)initNav {
    self.title =@"今日收益";
    [self setShowCustomerLeftItem:YES];
    
}
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self.view addSubview:self.listTableView];
    self.page = 1;
    [self  getUserWalletLog];
    
}
-(void)getUserWalletLog {
    [HK_WalletTool getUserTodayIncomeListWithPage:self.page successBlock:^(MyWalletLogModel *response) {
        [self.listTableView.mj_header endRefreshing];
        if (self.page ==1) {
            [self.dataSources removeAllObjects];
        }
        if (self.page == response.data.totalPage || response.data.totalPage == 0) {
            [self.listTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.listTableView.mj_footer endRefreshing];
            [self.listTableView.mj_footer resetNoMoreData];
        }
        [self.dataSources addObjectsFromArray:response.data.list];
        [self.listTableView reloadData];
    
    } fial:^(NSString *error) {
        [self.listTableView.mj_footer endRefreshing];
        [self.listTableView.mj_header endRefreshing];
        
    }];
}
-(NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources =[[NSMutableArray alloc] init];
    }
    return _dataSources;
}
-(HK_LogHeaderView *)header {
    if (!_header) {
        _header =[[HK_LogHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,133)];
    }
    return _header;
}
-(UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight) style:UITableViewStylePlain];
        _listTableView.delegate  =self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView =[[UIView alloc] init];
        _listTableView.rowHeight = 67;
        _listTableView.showsVerticalScrollIndicator =NO;
        _listTableView.showsHorizontalScrollIndicator =NO;
        _listTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _listTableView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [_listTableView registerClass:[HK_walletListCell class] forCellReuseIdentifier:@"listWallet"];
        _listTableView.tableHeaderView = self.header;
        
      //加上拉刷新下拉加载
        //下拉刷新
        _listTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        //    //上拉加载
      _listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_listTableView.mj_footer setHidden: YES];

    }
    return _listTableView;
}
////下拉刷新
-(void)loadNewData {
    self.page =1;
    [self getUserWalletLog];
}
////加载更多
-(void)loadMoreData {
    self.page++;
    [self getUserWalletLog];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  0.01f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
   
    return  nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * v =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,40)];
    v.backgroundColor =RGB(245,245,245);
    UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(15,16,300,14)];
    [AppUtils getConfigueLabel:label font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:RGB(153,153,153) text:@"今日收益明细"];
    [v addSubview:label];
    return v;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_walletListCell * listCell =[tableView dequeueReusableCellWithIdentifier:@"listWallet" forIndexPath:indexPath];
    WalletList *listData =[self.dataSources objectAtIndex:indexPath.row];
    [listCell setDataWithModel:listData];

    return listCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_LogDetailController *logVc =[[HK_LogDetailController alloc] init];
    WalletList *listData =[self.dataSources objectAtIndex:indexPath.row];
    logVc.logId = listData.logId;
    [self.navigationController pushViewController:logVc animated:YES];
}
@end
