//
//  HKHKMyAfterSaleViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHKMyAfterSaleViewController.h"
#import "HKAfterSaleRespone.h"
#import "HKAfterSaleViewModel.h"
#import "HKLogisticsViewController.h"
#import "HKAddressViewController.h"
#import "HKRefusingGoodsViewController.h"
#import "HKAfterStaueTableViewCell.h"
@interface HKHKMyAfterSaleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKAfterSaleRespone *respone;
@end

@implementation HKHKMyAfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
-(void)loadData{
    [HKAfterSaleViewModel orderAfterSale:@{@"loginUid ":HKUSERLOGINID,@"orderNumber":self.orderNumber} success:^(HKAfterSaleRespone *responde) {
        if (responde.responeSuc) {
            self.respone = responde;
        
            [self.tableView reloadData];
            
        }
    }];
}
-(void)directRefund{
  //直接退款
    NSDictionary*dict = @{@"loginUid":HKUSERLOGINID,@"orderNumber":self.orderNumber};
    [HKAfterSaleViewModel agreeReturnGoods:dict type:10 success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            [self loadData];
        }
    }];
}
-(void)approvalArefund{
    //同意退款
    [self directRefund];
//    HKAddressViewController*vc = [[HKAddressViewController alloc]init];
//    vc.orderNumber = self.orderNumber;
//    [self.navigationController pushViewController:vc animated:YES];
}
-(void)refusingArefund{
//    拒绝退了
    HKRefusingGoodsViewController*vc = [[HKRefusingGoodsViewController alloc]init];
    vc.orderNumber = self.orderNumber;
    vc.staue = AfterSaleViewStatue_Refuse;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)refusingGoods{
   //拒绝退货
    HKRefusingGoodsViewController*vc = [[HKRefusingGoodsViewController alloc]init];
    vc.orderNumber = self.orderNumber;
    vc.staue = AfterSaleViewStatue_RefuseReturn;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)approvalGoods{
   //同意退货
    HKAddressViewController*vc = [[HKAddressViewController alloc]init];
    vc.orderNumber = self.orderNumber;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)trackingLogistics{
    HKLogisticsViewController*vc = [[HKLogisticsViewController alloc]init];
    HKOrderInfoData*model = [[HKOrderInfoData alloc]init];
    model.courier = self.respone.data.courier;
    model.courierNumber = self.respone.data.courierNumber;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
//    跟踪物流
}
-(void)proof{
//    举证
    //拒绝退货
    HKRefusingGoodsViewController*vc = [[HKRefusingGoodsViewController alloc]init];
    vc.orderNumber = self.orderNumber;
    vc.staue = AfterSaleViewStatue_ProofOfBuyerseller;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)setUI{
    self.title = @"退款/售后";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView
        .separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    NSInteger rowNum =  self.respone.data.cellArray.count;
    return rowNum;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKAfterBaseTableViewCell *cell = [HKAfterSaleViewModel tableView:tableView cellForRowAtIndexPath:indexPath model:self.respone];
     AfterSaleViewStatue statue = [self.respone.data.cellArray[indexPath.row] intValue];
    cell.staue = statue;
    cell.delegate = self;
    cell.model = self.respone;
    if (indexPath.section == 0) {
        HKAfterStaueTableViewCell*staueCell = (HKAfterStaueTableViewCell*)cell;
        staueCell.orderNumber = self.orderNumber;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
@end
