//
//  HKAddFriendViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAddFriendViewController.h"
#import "HKAddHeadVIew.h"
#import "HKAddFriendTableViewCell.h"
#import "HKAddHeadViewModel.h"
#import "HKRecommendFansModel.h"
#import "HKTableViewSessionHeadView.h"
#import "HKAddPhoneAddressViewController.h"
@interface HKAddFriendViewController ()<UITableViewDelegate,UITableViewDataSource,HKAddHeadVIewDelegate,HKAddFriendTableViewCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign) int pageNo;
@property (nonatomic, strong)HKAddHeadVIew* headView;
@end

@implementation HKAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    [self setUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)gotoAddress{
    HKAddPhoneAddressViewController*vc = [[HKAddPhoneAddressViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)loadData{
    [HKAddHeadViewModel loadRecommendedUsers:@{@"loginUid":HKUSERLOGINID,@"pageNumber":@(self.pageNo)} success:^(HKRecommendFansModel*model) {
        [self.dataArray addObjectsFromArray:model.data.list];
        [self.tableView reloadData];
    }];
}
-(void)setUI{
    self.title = @"添加好友";
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
        _tableView.tableHeaderView =self.headView;
        _tableView.showsVerticalScrollIndicator =NO;
    }
    return _tableView ;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(void)attentionSomeOneWithModel:(FriendList *)model andIndexPath:(NSIndexPath *)path {
    [self.dataArray removeObject:model];
    [self.tableView reloadData];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKAddFriendTableViewCell*cell = [HKAddFriendTableViewCell addFriendCellWithTableView:tableView];
    cell.friendM = self.dataArray[indexPath.row];
    cell.delegate = self;
    cell.indexPath =indexPath;
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HKTableViewSessionHeadView *view = [[HKTableViewSessionHeadView alloc]init];
    view.titleText = @"系统推荐";
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendList *frindM =self.dataArray[indexPath.row];
    HKMyFollowAndFansList *list =[[HKMyFollowAndFansList alloc] init];
    list.name =frindM.name;
    list.headImg = frindM.headImg;
    list.uid =frindM.uid;
    [AppUtils pushUserDetailInfoVcWithModel:list andCurrentVc:self];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)pushUserDetail:(FriendList *)model {
    HKMyFollowAndFansList *list =[[HKMyFollowAndFansList alloc] init];
    list.name =model.name;
    list.headImg = model.headImg;
    list.uid =model.uid;
    [AppUtils pushUserDetailInfoVcWithModel:list andCurrentVc:self];
}
-(HKAddHeadVIew *)headView{
    if (!_headView) {
        _headView = [[HKAddHeadVIew alloc]init];
        _headView.frame = CGRectMake(0, 0, kScreenWidth, 198);
        _headView.delegate = self;
    }
    return _headView;
    
}
- (NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [ NSMutableArray array];
    }
    return _dataArray;
}
@end
