//
//  HKMySubCoinVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMySubCoinVc.h"
#import "HK_walletListCell.h"
#import "HK_WalletTool.h"
@interface HKMySubCoinVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * listTableView;
@property (nonatomic, strong)NSMutableArray * dataSources;
@property (nonatomic, assign)NSInteger page;
@end

@implementation HKMySubCoinVc
-(NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources =[[NSMutableArray alloc] init];
    }
    return _dataSources;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.listTableView];
    self.page = 1;
    [self getCoinsRequest];
}
-(void)getCoinsRequest {
    [HK_WalletTool getUserCoinsByType:self.type andPages:self.page successBlock:^(MyWalletLogModel *response) {
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
-(UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-178-46) style:UITableViewStylePlain];
        _listTableView.delegate  =self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView =[[UIView alloc] init];
        _listTableView.rowHeight = 67;
        _listTableView.showsVerticalScrollIndicator =NO;
        _listTableView.showsHorizontalScrollIndicator =NO;
        _listTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _listTableView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [_listTableView registerClass:[HK_walletListCell class] forCellReuseIdentifier:@"listWallet"];
        _listTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        UIView *head =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
        head.backgroundColor = MainColor;
        _listTableView.tableHeaderView =head;
    }
    return _listTableView;
}
-(void)loadNewData {
    self.page =1;
    [self getCoinsRequest];
}
-(void)loadMoreData {
    self.page++;
    [self getCoinsRequest];
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
@end
