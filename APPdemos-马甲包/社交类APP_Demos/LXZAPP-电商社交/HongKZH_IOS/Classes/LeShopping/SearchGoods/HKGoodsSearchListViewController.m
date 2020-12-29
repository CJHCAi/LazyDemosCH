//
//  HKGoodsSearchListViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKGoodsSearchListViewController.h"
#import "CommodityDetailsViewModel.h"
#import "CategoryProductListRespone.h"
#import "HKCommodityClassListCell.h"
#import "HKDetailsPageViewController.h"
#import "HKNavSearchView.h"
@interface HKGoodsSearchListViewController ()<UITableViewDelegate,UITableViewDataSource,HKNavSearchViewDelegate>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic,assign) int pageNumber;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKNavSearchView *navView;
@end

@implementation HKGoodsSearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)loadNewData{
    self.pageNumber = 1;
    [self.dataArray removeAllObjects];
    [self loadData];
}
-(void)loadNextData{
    self.pageNumber++;
    [self loadData];
}
-(void)loadData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [CommodityDetailsViewModel searchProductList:@{@"loginUid":HKUSERLOGINID,@"title":self.titleStr,@"pageNumber":@(self.pageNumber)} success:^(CategoryProductListRespone *responde) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (responde.responeSuc) {
            if (responde.data.lastPage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = YES;
            }
            [self.dataArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
        }else{
            if (self.pageNumber>1) {
                self.pageNumber --;
            }
        }
    }];
}
-(void)setUI{
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
    }];
}
-(void)closeSearch{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCommodityClassListCell*cell = [HKCommodityClassListCell baseCellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKDetailsPageViewController*vc = [[HKDetailsPageViewController alloc]init];
    vc.productId = [self.dataArray[indexPath.row] productId];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(HKNavSearchView *)navView{
    if (!_navView) {
        _navView = [[HKNavSearchView alloc]init];
        _navView.delegate = self;
    }
    return _navView;
}
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.navView.textField.text = titleStr;
    [self loadNewData];
}
@end
