//
//  HKShopCateoryListViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShopCateoryListViewController.h"
#import "HKShopCateoryParameter.h"
#import "CommodityDetailsViewModel.h"
#import "CategoryProductListRespone.h"
#import "HKCommodityClassListCell.h"
#import "HKDetailsPageViewController.h"
#import "HKRecruitScreenView.h"
#import "HKGoodsSearchViewController.h"
#import "HKGoodsListFootView.h"
@interface HKShopCateoryListViewController ()<UITableViewDelegate,UITableViewDataSource,HKRecruitScreenViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKShopCateoryParameter *parameter;
@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)HKRecruitScreenView *recruit;

@property (nonatomic, strong)HKGoodsListFootView *footView;
@end

@implementation HKShopCateoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)loadNewData{
    self.parameter.pageNumber = 1;
    [self.dataArray removeAllObjects];
    [self loadData];
}
-(void)loadNextData{
    self.parameter.pageNumber++;
    [self loadData];
}
-(void)loadData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [CommodityDetailsViewModel getCategoryProductList:self.parameter success:^(CategoryProductListRespone *responde) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (responde.responeSuc) {
            if (responde.data.lastPage) {
                self.tableView.mj_footer.hidden = YES;
                self.tableView.tableFooterView = self.footView;
            }else{
               self.tableView.mj_footer.hidden = YES;
            }
            [self.dataArray addObjectsFromArray:responde.data.list];
         
            [self.tableView reloadData];
        }else{
            if (self.parameter.pageNumber>1) {
                self.parameter.pageNumber --;
            }
        }
    }];
}
-(void)setUI{
    self.title = @"商品列表";
    [self.view addSubview:self.recruit];
    [self.recruit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(41.5);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.recruit.mas_bottom);
    }];
    [self setrightBarButtonItemWithImageName:@"sy_ssuo"];
}
-(void)rightBarButtonItemClick{
    HKGoodsSearchViewController*vc = [[HKGoodsSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)goToClick:(NSInteger)tag{
    switch (tag) {
        case 0:
        {
            self.parameter.sortId = nil;
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            self.parameter.sortId = @"integral";
            self.parameter.isAsc = !self.parameter.isAsc;
            [self loadNewData];
        }
            break;
        default:
            break;
    }
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
-(HKShopCateoryParameter *)parameter{
    if (!_parameter) {
        _parameter = [HKShopCateoryParameter alloc];
        _parameter.pageNumber = 1;
        _parameter.isAsc = NO;
    }
    return _parameter;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)setCategoryId:(NSString *)categoryId{
    _categoryId = categoryId;
    self.parameter.categoryId = categoryId;
}
-(HKRecruitScreenView *)recruit{
    if (!_recruit) {
        _recruit = [[HKRecruitScreenView alloc]init];
        [_recruit.btn1 setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] title:@"热销" imageName:@""];
        [_recruit.btn2 setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] title:@"综合" imageName:@"recruit_down"];
        [_recruit.btn3 setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] title:@"品牌" imageName:@"recruit_down"];
        [_recruit.btn4 setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] title:@"价格" imageName:@"recruit_down"];
        _recruit.delegate = self;
    }
    return _recruit;
}
- (HKGoodsListFootView *)footView{
    if (!_footView) {
        _footView = [[HKGoodsListFootView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    }
    return _footView;
}
@end
