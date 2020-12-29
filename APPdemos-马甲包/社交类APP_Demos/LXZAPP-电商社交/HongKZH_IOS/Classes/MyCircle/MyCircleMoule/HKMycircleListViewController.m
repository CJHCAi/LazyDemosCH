//
//  HKMycircleListViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMycircleListViewController.h"
#import "HKCliceListRespondeModel.h"
#import "HKMyCircleViewModel.h"
#import "HKCircleLishTableViewCell.h"
#import "HKMyCircleViewController.h"
#import "HKMyCiecleHeadView.h"
#import "HKLeSearchAllViewController.h"
#import "HKClicleHomeViewController.h"
#import "HKLeSeeManagerViewController.h"
#import "HKMyPostManageViewController.h"
@interface HKMycircleListViewController ()<UITableViewDelegate,UITableViewDataSource,HKMyCiecleHeadViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong)HKCliceListRespondeModel *respone;
@property (nonatomic, strong)HKMyCiecleHeadView *headView;
@end

@implementation HKMycircleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [self loadData];
}
-(void)loadData{
    [HKMyCircleViewModel getCircleList:@{@"loginUid":HKUSERLOGINID} success:^(HKCliceListRespondeModel *responde) {
        if (responde.responeSuc) {
            self.respone = responde;
            [self.tableView reloadData];
        }
    }];
}
-(void)setUI{
     self.view.backgroundColor =[UIColor colorFromHexString:@"#f5f5f5"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(kScreenHeight-NavBarHeight-StatusBarHeight-TabBarHeight-SafeAreaBottomHeight-40);
    }];
}
-(void)gotoSearch{
    HKLeSearchAllViewController*vc = [[HKLeSearchAllViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)clickWithRow:(int)row{
    if (row == 0) {
        HKClicleHomeViewController*vc = [[HKClicleHomeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(row == 1){
        HKLeSeeManagerViewController*vc = [[HKLeSeeManagerViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HKMyPostManageViewController*posts = [[HKMyPostManageViewController alloc]init];
        [self.navigationController pushViewController:posts animated:YES];
    }
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView =[[UIView alloc] init];
        _tableView.backgroundColor =[UIColor colorFromHexString:@"f5f5f5"];
    }
    return _tableView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 18;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    UILabel*label = [[UILabel alloc]init];
    label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerX.equalTo(view);
    }];
    HKCliceListData*listData = self.respone.data[section];
    label.text = listData.name;
    return view;
}
#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.respone.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HKCliceListData*listData = self.respone.data[section];
    return listData.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCircleLishTableViewCell *cell = [HKCircleLishTableViewCell circleLishTableViewCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HKCliceListData*listM = self.respone.data[indexPath.section];
    cell.model = listM.list[indexPath.row];
    cell.block = ^(HKClicleListModel *model) {
         [AppUtils pushCicleMainContentWithCicleId:model.circleId andCurrentVc:self];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCliceListData*listM = self.respone.data[indexPath.section];
    NSString *cicleId =listM.list[indexPath.row].circleId;
    //    HK_GladlyFriendGroupInfoView* vc = [[HK_GladlyFriendGroupInfoView alloc] init];
    [AppUtils pushCicleMainContentWithCicleId:cicleId andCurrentVc:self];
    //    [vc addReRequest:item.circleId];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(HKMyCiecleHeadView *)headView{
    if (!_headView) {
        _headView = [[HKMyCiecleHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 185)];
        _headView.delegate = self;
    }
    return _headView;
}
@end
