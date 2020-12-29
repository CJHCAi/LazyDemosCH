//
//  HKEnterpriseRecruitInfoViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEnterpriseRecruitInfoViewController.h"
#import "HKReleaseViewModel.h"
#import "EnterpriseRecruitListRespone.h"
#import "EnterpriseRecruitInfoTableViewCell.h"
#import "HKPositionsTableViewCell.h"
#import "HKReseaesInfosViewController.h"
#import "HKVideoPlayView.h"
@interface HKEnterpriseRecruitInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)EnterpriseRecruitListRespone *respone;
@end

@implementation HKEnterpriseRecruitInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)loadData{
    [HKReleaseViewModel getEnterpriseRecruitListById:@{@"enterpriseId":self.enterpriseId,@"loginUid":HKUSERLOGINID} success:^(EnterpriseRecruitListRespone *responde) {
        if (responde.responeSuc) {
            self.respone = responde;
            [self.tableView reloadData];
        }
    }];
}
-(void)setUI{
     self.title = @"公司信息";
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
    if (section == 1) {
        return self.respone.data.recruits.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EnterpriseRecruitInfoTableViewCell*cell = [EnterpriseRecruitInfoTableViewCell baseCellWithTableView:tableView];
        cell.respone = self.respone;
        return cell;
    }else{
        HKPositionsTableViewCell*cell = [HKPositionsTableViewCell baseCellWithTableView:tableView];
        cell.model = self.respone.data.recruits[indexPath.row];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKReseaesInfosViewController*vc = [[HKReseaesInfosViewController alloc]init];
    vc.recruitId = [self.respone.data.recruits[indexPath.row] recruitId];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
