//
//  HKAddressViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAddressViewController.h"
#import "HKAddressListRespone.h"
#import "HKAfterSaleViewModel.h"
#import "HKAddressTableViewCell.h"
#import "HKAddAddressBtn.h"
//#import "HK_AddAddressView.h"
#import "HKModifyAddressViewController.h"
@interface HKAddressViewController ()<UITableViewDelegate,UITableViewDataSource,HKAddAddressBtnDelegate,HKAddressTableViewCellDelegate,UIAlertViewDelegate,HKModifyAddressViewControllerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKAddressListRespone *respone;
@property (nonatomic, strong)HKAddAddressBtn *addressBtn;
@property(nonatomic,copy)NSString*selctAddid;
@end

@implementation HKAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
}
-(void)loadData{
    [HKAfterSaleViewModel address:@{@"loginUid":HKUSERLOGINID} type:1 success:^(HKAddressListRespone *responde) {
        if (responde.responeSuc) {
            self.respone = responde;
            [self.tableView reloadData];
        }
    }];
}
-(void)setUI{
    self.title = @"添加退货地址";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addressBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
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
-(void)save:(HKOrderInfoData *)mode indebpath:(NSIndexPath *)indexpath{
  HKAddressModel*addreM =  self.respone.data[indexpath.row];
    addreM.provinceId = mode.address.provinceId;
    addreM.cityId = mode.address.cityId;
    addreM.areaId = mode.address.areaId;
    [self.tableView reloadData];
}
-(void)refreshLastVc{
    [self loadData];
}
-(void)gotEditAddressWithModel:(HKAddressModel *)address{
    HKModifyAddressViewController*vc = [[HKModifyAddressViewController alloc]init];
    HKOrderInfoData*orderInfoM = [[HKOrderInfoData alloc]init];
      NSDictionary*dict = [address mj_keyValues];
    AddressModel*addM = [AddressModel mj_objectWithKeyValues:dict];
    orderInfoM.address = addM;
    orderInfoM.addressId = address.addressId;
    vc.model = orderInfoM;
    vc.isRefund = YES;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)modifyTheAddress{
    
}
#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.respone.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKAddressTableViewCell*cell = [HKAddressTableViewCell addressTableViewCellWithTableView:tableView];
    cell.address = self.respone.data[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKAddressModel*model = self.respone.data[indexPath.row];
    self.selctAddid = model.addressId;
    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"同意退货并提交该退货地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSDictionary*dict = @{@"loginUid":HKUSERLOGINID,@"orderNumber":self.orderNumber,@"addressId":self.selctAddid};
        [HKAfterSaleViewModel agreeReturnGoods:dict type:AfterSaleViewStatue_ApplicationReturn  success:^(HKBaseResponeModel *responde) {
            if(responde.responeSuc){
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
-(void)gotoAddAddress{
//    HK_AddAddressView*addvc = [[HK_AddAddressView alloc]init];
//    addvc.isRefund = YES;
//    addvc.delegate = self;
//    [self.navigationController pushViewController:addvc animated:YES];
}
-(HKAddAddressBtn *)addressBtn{
    if (!_addressBtn) {
        _addressBtn = [[HKAddAddressBtn alloc]init];
        _addressBtn.delegate = self;
    }
    return _addressBtn;
}
@end
