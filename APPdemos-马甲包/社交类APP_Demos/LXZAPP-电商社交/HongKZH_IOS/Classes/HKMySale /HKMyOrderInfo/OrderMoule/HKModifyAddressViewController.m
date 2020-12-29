//
//  HKModifyAddressViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKModifyAddressViewController.h"
#import "HKModifyAddressTableViewCell.h"
#import "HKBaseCitySelectorViewController.h"
#import "HKAfterSaleViewModel.h"
@interface HKModifyAddressViewController ()<UITableViewDelegate,UITableViewDataSource,HKModifyAddressTableViewCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation HKModifyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    // Do any additional setup after loading the view.
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)saveData{
  NSDictionary*dict =  [self.model.address mj_keyValues];
    [HKAfterSaleViewModel addUserReturnAddress:dict type:self.isRefund success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            if ([self.delegate respondsToSelector:@selector(save:indebpath:)]) {
                [self.delegate save:self.model indebpath:self.indexpath];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
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
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKModifyAddressTableViewCell*cell = [HKModifyAddressTableViewCell modifyAddressTableViewCellWithTableView:tableView];
    cell.model = self.model;
    cell.delegate = self;
    return cell;
}
-(void)showSelectCity{
     @weakify(self)
    [HKBaseCitySelectorViewController showCitySelectorWithProCode:self.model.provinceId cityCode:self.model.cityId areaCode:self.model.areaId navVc:self ConfirmBlock:^(HKProvinceModel *proCode, HKCityModel *cityCode, getChinaListAreas *areaCode) {
        @strongify(self)
        self.model.address.provinceId = proCode.code;
        self.model.address.cityId = cityCode.code;
        self.model.address.areaId = areaCode.code;
        [self.tableView reloadData];
        DLog(@"");
    }];
//    HKBaseCitySelectorViewController *vc = [[HKBaseCitySelectorViewController alloc]init];
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(void)setIsRefund:(BOOL)isRefund{
    _isRefund = isRefund;
    if (_isRefund) {
        self.title = @"修改退货地址";
    }else{
    self.title = @"修改收货地址";
    }
}
@synthesize model = _model;
-(void)setModel:(HKOrderInfoData *)model{
    _model = model;
    model.address.addressId = model.addressId;
    [self.tableView reloadData];
}
-(HKOrderInfoData *)model{
    if (!_model) {
        _model = [[HKOrderInfoData alloc]init];
    }
    return _model;
}
@end
