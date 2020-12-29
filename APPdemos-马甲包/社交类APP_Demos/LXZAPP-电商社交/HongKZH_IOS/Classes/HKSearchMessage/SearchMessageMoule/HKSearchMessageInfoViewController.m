//
//  HKSearchMessageInfoViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSearchMessageInfoViewController.h"
#import "HKSearchTypeTableViewCell.h"
#import "HKSearchMessageInfoModel.h"
@interface HKSearchMessageInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataArray;
@end

@implementation HKSearchMessageInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self setShowCustomerLeftItem:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
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
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKSearchTypeTableViewCell *cell = [HKSearchTypeTableViewCell searchTypeCellWithTableView:tableView];
    cell.messageM = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}

-(void)setModel:(HKSearchMessageInfoModel *)model{
    _model = model;
    self.dataArray = [[RCIMClient sharedRCIMClient] searchMessages:model.rcModel.conversation.conversationType
                                                          targetId:model.rcModel.conversation.targetId
                                                           keyword:model.searchText
                                                             count:model.count
                                                         startTime:0];
    [self.tableView reloadData];
}

@end
