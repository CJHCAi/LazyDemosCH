//
//  HKBuyerAfterSale.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBuyerAfterSale.h"
#import "HK_MyOrderCell.h"
#import "HK_BaseRequest.h"
#import "HK_BuySellResponse.h"
#import "HK_orderShopFooterView.h"
#import "HK_orderShopHeaderView.h"
#import "HKBuySaleDetailController.h"
//#import "HKHKMyAfterSaleViewController.h"
@interface HKBuyerAfterSale ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView * listTableView;
@property (nonatomic, strong)NSMutableArray * dataSources;
@property (nonatomic, assign)int page;

@end

@implementation HKBuyerAfterSale
#pragma mark 懒加载数据源
-(NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources =[[NSMutableArray alloc] init];
    }
    return _dataSources;
}
-(void)initNav {
    self.title =@"退换/售后";
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
    [AppUtils setPopHidenNavBarForFirstPageVc:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self.view addSubview:self.listTableView];
    self.page = 1;
    //获取列表信息
    [self loadOrderListInfo];
}
-(void)loadOrderListInfo {
    
    if (_page>1) {
        [self.listTableView.mj_footer setHidden:NO];
        //不移除数据
    }else {
        [self.listTableView.mj_footer setHidden:YES];
    }
    NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:@"loginUid"];
    [params setValue:@(self.page) forKey:@"pageNumber"];
    
    [HK_BaseRequest buildPostRequest:get_mediaShopMyAfterSale body:params success:^(id  _Nullable responseObject) {
        [self.listTableView.mj_header endRefreshing];
        
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
            NSString *mes =responseObject[@"msg"];
            if (mes.length) {
                [EasyShowTextView showText:mes];
            }
        }else {
            if (self.page==1) {
                if (self.dataSources.count) {
                    [self.dataSources removeAllObjects];
                }
                [self.listTableView.mj_footer setHidden:NO];
            }
            HK_BuySellResponse * bigModel =[HK_BuySellResponse mj_objectWithKeyValues:responseObject];
            if (bigModel.data.list.count) {
                [self.dataSources addObjectsFromArray:bigModel.data.list];
                [self.listTableView.mj_footer endRefreshing];
                [self.listTableView reloadData];
            }
            else
            {
                [self.listTableView.mj_footer setHidden:YES];
                [EasyShowTextView showText:@"全部加载完毕"];
            }
        }
    } failure:^(NSError * _Nullable error) {
        [self.listTableView.mj_header endRefreshing];
        [self.listTableView.mj_footer endRefreshing];
        [EasyShowTextView showText:@"无网络,稍后重试"];
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //获取每一组的 内容状态
    HK_SaleLIstData * listOrder =[self.dataSources objectAtIndex:section];
    HK_orderShopFooterView *orderView =[[HK_orderShopFooterView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,48)];
    orderView.section =section;
    [orderView ShowToolBarStatusWith:listOrder];
    return orderView;
}
#pragma mark 头部标题信息和状态值
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   HK_SaleLIstData * listOrder =[self.dataSources objectAtIndex:section];
    HK_orderShopHeaderView * headerView  =[[HK_orderShopHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,50)];
    [headerView saleHeaderWithSaleModel:listOrder];
    return  headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HK_SaleLIstData  * saleData =[self.dataSources objectAtIndex:section];
    return  saleData.subList.count;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return  self.dataSources.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_MyOrderCell * orderCell =[tableView dequeueReusableCellWithIdentifier:@"myOrderCell" forIndexPath:indexPath];
    HK_SaleLIstData * saleData =[self.dataSources objectAtIndex:indexPath.section];
    HK_SubListSaleData *listModel =[saleData.subList objectAtIndex:indexPath.row];
    orderCell.saleData =listModel;
    return orderCell;
}
-(UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight) style:UITableViewStyleGrouped];
        _listTableView.delegate  =self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView =[[UIView alloc] init];
        _listTableView.rowHeight = 102;
        _listTableView.showsVerticalScrollIndicator =NO;
        _listTableView.showsHorizontalScrollIndicator =NO;
        _listTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _listTableView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [_listTableView registerNib:[UINib nibWithNibName:@"HK_MyOrderCell" bundle:nil] forCellReuseIdentifier:@"myOrderCell"];
        //                //下拉刷新
                        _listTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        //    //上拉加载
        _listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_listTableView.mj_footer setHidden: YES];
        
    }
    return _listTableView;
}
#pragma mark 跳转详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_SaleLIstData * saleData =[self.dataSources objectAtIndex:indexPath.section];
    HK_SubListSaleData *listModel =[saleData.subList objectAtIndex:indexPath.row];
    HKBuySaleDetailController *de =[[HKBuySaleDetailController alloc] init];
    de.mdoel =listModel;
    de.cancelBlock = ^{
        [self loadNewData];
    };
    [self.navigationController pushViewController:de animated:YES];
}
-(void)loadNewData {
    self.page =1;
    [self loadOrderListInfo];
}
-(void)loadMoreData {
    self.page ++;
    [self loadOrderListInfo];
    
}
@end
