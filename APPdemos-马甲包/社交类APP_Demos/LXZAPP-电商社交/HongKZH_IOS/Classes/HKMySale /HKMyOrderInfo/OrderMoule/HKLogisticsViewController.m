//
//  HKLogisticsViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLogisticsViewController.h"
#import "HKLogisticsNameTableViewCell.h"
#import "HKLogisticsInfoTableViewCell.h"
#import "HKLogisticsList.h"
#import "HKLogisticsListResponse.h"
#import "HKOrderFormViewModel.h"
@interface HKLogisticsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKLogisticsList *dataModel;
@end

@implementation HKLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)loadData{
    [HKOrderFormViewModel logisticsInformation:@{@"loginUid":HKUSERLOGINID,@"courier":self.model.courier,@"courierNumber":self.model.courierNumber} success:^(HKLogisticsListResponse *responde) {
        if (responde.responeSuc) {
            self.dataModel = responde.data;
            [self.tableView reloadData];
        }
        
    }];
}
-(void)setUI{
    self.title = @"物流";
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return self.dataModel.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKLogisticsNameTableViewCell *cell = [HKLogisticsNameTableViewCell logisticsNameTableViewCellWithTableView:tableView];
        cell.model = self.model;
        return cell;
    }
    HKLogisticsInfoTableViewCell*cell = [HKLogisticsInfoTableViewCell logisticsInfoTableViewCellWithTableView:tableView];
    cell.model = self.dataModel.data[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(void)setModel:(HKOrderInfoData *)model{
    _model = model;
    [self loadData];
}
@end
