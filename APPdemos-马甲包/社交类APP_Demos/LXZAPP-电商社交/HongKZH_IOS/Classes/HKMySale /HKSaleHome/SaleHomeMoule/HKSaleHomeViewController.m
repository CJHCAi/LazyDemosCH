//
//  HKSaleHomeViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSaleHomeViewController.h"
#import "HKMySaleTableHeadViw.h"
#import "HKMySaleViewModel.h"
#import "HKMyGoodsViewController.h"
#import "HKOrderFormMangerViewController.h"
#import "HKMyGoodsTableViewCell.h"
#import "HKMyGoodsViewModel.h"
@interface HKSaleHomeViewController ()<UITableViewDelegate,UITableViewDataSource,HKMySaleTableHeadViwDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)HKMySaleTableHeadViw *headView;
@property (nonatomic, strong)HKMySaleRespone *headRespone;
@property (nonatomic,assign) int pageNum;
@end

@implementation HKSaleHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadNewData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
    // Do any additional setup after loading the view.
}
-(void)loadNewData{
    self.pageNum = 1;
    [self loadData];
    [self loadHeadData];
}
-(void)loadNextData{
    self.pageNum ++;
    [self loadData];
}
-(void)loadData{
    NSDictionary*dict = @{@"loginUid":HKUSERLOGINID,@"order":@"1",@"pageNumber":[NSString stringWithFormat:@"%d",self.pageNum]};
    [HKMyGoodsViewModel loadMyUpperProduct:dict andType:0  success:^(HKMyGoodsRespone *respone) {
        if (respone.code == 0) {
            [self.dataArray addObjectsFromArray:respone.data.list];
            [self.tableView reloadData];
        }else{
            if (self.pageNum > 1) {
                self.pageNum = self.pageNum - 1;
            }
        }
        if (respone.data.lastPage) {
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.mj_footer.hidden = NO;
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)loadHeadData{
    [HKMySaleViewModel loadMySale:@{@"loginUid":HKUSERLOGINID} success:^(HKMySaleRespone *responde) {
        self.headRespone = responde;
        self.headView.model = responde.data;
        [self.tableView reloadData];
    }];
}
-(void)setUI{
    self.title = @"我的售卖";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableHeaderView = self.headView;
    }
    return _tableView;
}

-(void)myGoods{
    HKMyGoodsViewController *vc = [[HKMyGoodsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)gotoMyOrderFrom{
    HKOrderFormMangerViewController*orderVc = [[HKOrderFormMangerViewController alloc]init];
    orderVc.title = @"订单管理";
    [self.navigationController pushViewController:orderVc animated:YES];
}
#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyGoodsTableViewCell*cell = [HKMyGoodsTableViewCell myGoodsTableViewCellWithTableView:tableView];
    cell.goodsM = self.dataArray[indexPath.row];
    cell.indexPath = indexPath;
    cell.showType = 1;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
- (NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [ NSMutableArray array];
    }
    return _dataArray;
}
- (HKMySaleTableHeadViw *)headView
{
    if(_headView == nil)
    {
        _headView = [[ HKMySaleTableHeadViw alloc]init];
        _headView.delegate = self;
    }
    return _headView;
}
@end
