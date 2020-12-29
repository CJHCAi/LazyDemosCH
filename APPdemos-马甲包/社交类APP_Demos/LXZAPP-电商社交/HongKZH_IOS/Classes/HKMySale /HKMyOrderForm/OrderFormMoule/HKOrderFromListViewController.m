//
//  HKOrderFromListViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKOrderFromListViewController.h"
#import "HKOrderFormHeadView.h"
#import "HKOrderFormViewModel.h"
#import "HKOrderFormTableViewCell.h"
#import "HKSellerorderListRespone.h"
#import "HKParameterModel.h"
#import "HKSaleOrderInfoViewController.h"
#import "HKHKMyAfterSaleViewController.h"
@interface HKOrderFromListViewController ()<UITableViewDelegate,UITableViewDataSource,HKOrderFormHeadViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKOrderFormHeadView *headView;
@property (nonatomic, strong)HKParameterModel *waitArray;
@property (nonatomic, strong)HKParameterModel *waitPayArray;
@property (nonatomic, strong)HKParameterModel *goedArray;
@property (nonatomic, strong)HKParameterModel *afterSaleArray;
@property(nonatomic, assign) OrderFormHeadType state;
@end

@implementation HKOrderFromListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self loadNewData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
}
-(void)loadNextData{
     HKParameterModel*model = [self getDataArray];
    model.pageNum =  model.pageNum + 1;
    [self loadData];
}
-(void)loadNewData{
    
    HKParameterModel*model = [self getDataArray];
    [model.questionArray removeAllObjects];
    model.pageNum = 1;
    [self loadData];
}
-(void)loadData{
     HKParameterModel*model = [self getDataArray];
    NSDictionary *dict = @{@"loginUid":HKUSERLOGINID,@"state":@(self.state),@"pageNumber":@(model.pageNum)};
    [HKOrderFormViewModel sellerorderListByState:dict success:^(HKSellerorderListRespone *responde) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (responde.code.length>0 && [responde.code intValue] == 0) {
            [[[self getDataArray] questionArray] addObjectsFromArray:responde.data.list];
            if (responde.data.lastPage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            [self.tableView reloadData];
        }else{
            HKParameterModel*model = [self getDataArray];
            if (model.pageNum>1) {
                model.pageNum = model.pageNum-1;
            }
            
        }
    }];
}
-(void)loadHeader{
    [HKOrderFormViewModel sellerorderListHeaderWithsuccess:^(HKSellerorderListHeaderPesone *responde) {
        self.headView.model = responde.data;
    }];
}
-(void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(70);
        make.top.equalTo(self.view).offset(0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headView.mas_bottom);
    }];
}
-(void)selectStaueWithType:(OrderFormHeadType)type{
    self.state = type;
    
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self getDataArray] questionArray] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKOrderFormTableViewCell *cell  = [HKOrderFormTableViewCell orderFormTableViewCellWithTableView:tableView];
    cell.model = [[self getDataArray] questionArray][indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       HKSellerorderModel*model = [[self getDataArray] questionArray][indexPath.row];
    if (self.state == OrderFormHeadType_afterSale) {
        HKHKMyAfterSaleViewController*vc = [[HKHKMyAfterSaleViewController alloc]init];
        vc.orderNumber = model.orderNumber;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
    HKSaleOrderInfoViewController *infoVc = [[HKSaleOrderInfoViewController alloc]init];
 
    infoVc.orderNumber = model.orderNumber;
    [self.navigationController pushViewController:infoVc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(HKOrderFormHeadView *)headView{
    if (!_headView) {
        _headView = [[HKOrderFormHeadView alloc]init];
        _headView.delegate = self;
    }
    return _headView;
}
-(HKParameterModel*)getDataArray{
    switch (self.state) {
        case OrderFormHeadType_wait:{
            return self.waitArray;
        }
            break;
        case OrderFormHeadType_waitPay:{
            return self.waitPayArray;
        }
            break;
        case OrderFormHeadType_goed:{
            return self.goedArray;
        }
            break;
        case OrderFormHeadType_afterSale:{
            return self.afterSaleArray;
        }
            break;
        default:
            return self.waitArray;
            break;
    }
}

-(HKParameterModel *)waitArray{
    if (!_waitArray) {
        _waitArray = [[HKParameterModel alloc]init];
    }
    return _waitArray;
}
-(HKParameterModel *)waitPayArray{
    if (!_waitPayArray) {
        _waitPayArray = [[HKParameterModel alloc]init];
    }
    return _waitPayArray;
}
-(HKParameterModel *)goedArray{
    if (!_goedArray) {
        _goedArray = [[HKParameterModel alloc]init];
    }
    return _goedArray;
}
-(HKParameterModel *)afterSaleArray{
    if (!_afterSaleArray) {
        _afterSaleArray = [[HKParameterModel alloc]init];
    }
    return _afterSaleArray;
}
-(void)setOrderType:(OrderFormType)orderType{
    _orderType = orderType;
    if (_orderType == OrderFormType_Ing) {
        self.headView.hidden = NO;
        [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(70);
        }];
        [self loadHeader];
    }else{
        self.headView.hidden = YES;
        [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
     [self.view layoutIfNeeded];
    
    if (orderType == OrderFormType_Ing) {
        self.state = OrderFormHeadType_wait;
    }else if (orderType == OrderFormType_Finish){
        self.state = OrderFormHeadType_Finish;
    }else{
        self.state = OrderFormHeadType_Close;
    }
}

-(void)setState:(OrderFormHeadType)state{
    _state = state;
    self.headView.headType = state;
    [self.tableView reloadData];
    if ([[[self getDataArray]questionArray] count] == 0) {
        [self loadNewData];
    }
}

@end
