//
//  HKMyFriendListViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyFriendListViewController.h"
#import "HKFriendRespond.h"
#import "HKMyFriendTableViewCell.h"
#import "HKMyFriendListViewModel.h"
#import "HK_CladlyChattesView.h"
#import "HKFriendListHeadView.h"
#import "HKLeSearchAllViewController.h"
#import "HKAddFriendViewController.h"
@interface HKMyFriendListViewController ()<UITableViewDelegate,UITableViewDataSource,HKFriendListHeadViewDelegate,PushUserBaseInfoDelegete>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKFriendRespond *respone;
@property (nonatomic, strong)HKFriendListHeadView *headView;
@end

@implementation HKMyFriendListViewController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addBlackList" object:nil];
}
-(void)upDateData {
    self.respone = nil;
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateData) name:@"addBlackList" object:nil];
    
    [self setUI];
    [self loadData];
}
-(void)loadData{
    [HKMyFriendListViewModel myFriend:@{@"loginUid":HKUSERLOGINID} success:^(HKFriendRespond *responde) {
        if (responde.responeSuc) {
            self.respone =responde;
            [self.tableView reloadData];
        }
    }];
}
-(void)setUI{
    self.view.backgroundColor =[UIColor colorFromHexString:@"#f5f5f5"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.edges.equalTo(self.view);
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
-(void)gotoRecommend{
    HKAddFriendViewController *vc= [[HKAddFriendViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pushUserDetailControllerWithModel:(HKFriendModel *)model {
    
    HKMyFollowAndFansList * listModel =[[HKMyFollowAndFansList alloc] init];
    listModel.uid = model.uid;
    listModel.name =model.name;
    listModel.headImg =model.headImg;
    listModel.level =model.level;
    listModel.sex =model.sex;
    [AppUtils pushUserDetailInfoVcWithModel:listModel andCurrentVc:self];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView =[[UIView alloc] init];
        _tableView.backgroundColor =[UIColor colorFromHexString:@"#f5f5f5"];
        
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
    HKFriendListModel*listData = self.respone.data[section];
    label.text = listData.name;
    return view;
}
#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.respone.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HKFriendListModel*friendData = self.respone.data[section];
    
    return friendData.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyFriendTableViewCell*cell = [HKMyFriendTableViewCell myFriendTableViewCellWithTableView:tableView];
    cell.delegete = self;
    HKFriendListModel*friendData = self.respone.data[indexPath.section];
    cell.friendM = friendData.list[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKFriendListModel*listData = self.respone.data[indexPath.section];;
    HKFriendModel *item =  listData.list[indexPath.row];
    
    
    [AppUtils PushChatControllerWithType:ConversationType_PRIVATE uid:item.uid name:item.name headImg:item.headImg andCurrentVc:self];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(HKFriendListHeadView *)headView{
    if (!_headView) {
        _headView = [[HKFriendListHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 114)];
        _headView.delegate = self;
    }
    return _headView;
}
@end
