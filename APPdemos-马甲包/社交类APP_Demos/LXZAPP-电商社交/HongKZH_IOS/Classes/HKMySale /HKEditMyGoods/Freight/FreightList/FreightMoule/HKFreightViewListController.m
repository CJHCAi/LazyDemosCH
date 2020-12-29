//
//  HKFreightViewListController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFreightViewListController.h"
#import "HKEditGoodsViewModel.h"
#import "HKEditFreightViewController.h"
#import "HKFreightListTableViewCell.h"
#import "HKAddfrightModelView.h"
@interface HKFreightViewListController ()<UITableViewDelegate,UITableViewDataSource,HKFreightListTableViewCellDelegate,HKAddfrightModelViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)HKAddfrightModelView *addView;
@end

@implementation HKFreightViewListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
}
-(void)loadData{
    [HKEditGoodsViewModel freightListSuccess:^(HKFreightListRespone *respone) {
        if (respone.responeSuc) {
            [self.dataArray addObjectsFromArray:respone.data];
            [self.tableView reloadData];
        }
    }];
}
-(void)setUI{
    [self.view addSubview:self.addView];
    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.addView.mas_top);
    }];
}
-(void)addModel{
    HKEditFreightViewController*vc = [[HKEditFreightViewController alloc]init];
    HKFreightListData*model = [[HKFreightListData alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)gotoEditWithModel:(HKFreightListData *)model{
    HKEditFreightViewController*vc = [[HKEditFreightViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
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
    HKFreightListTableViewCell*cell = [HKFreightListTableViewCell baseCellWithTableView:tableView];

        cell.model = self.dataArray[indexPath.row];
    
    if (self.selectRow == indexPath.row) {
        cell.isSelect = YES;
    }else{
        cell.isSelect = NO;
    }
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(selectFreightModel:)]) {
        [self.delegate selectFreightModel:self.dataArray[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        HKFreightListData*listM = [[HKFreightListData alloc]init];
        listM.isSystem = @"-1";
        listM.freightId = @"0";
        _dataArray = [NSMutableArray arrayWithObject:listM];
    }
    return _dataArray;
}
-(HKAddfrightModelView *)addView{
    if (!_addView) {
        _addView = [[HKAddfrightModelView alloc]init];
        _addView.delegate = self;
    }
    return _addView;
}
@end
