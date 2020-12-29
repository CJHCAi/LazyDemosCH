//
//  HKBurstingActivityInfoViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBurstingActivityInfoViewController.h"
#import "HKluckyBurstDetailRespone.h"
#import "HKShoppingViewModel.h"
#import "HKLuckyBurstListTableViewCell.h"
#import "HKExplainHeadTableViewCell.h"
#import "HKUserEnergyTableViewCell.h"
#import "HKBurstingVodeoTableViewCell.h"
#import "HKBurstingAtivityFriendTableViewCell.h"
#import "HKBurstingAtivityFriendTableViewCell.h"
#import "HKRankingHeadTableViewCell.h"
#import "HKShareBaseModel.h"
#import "HKCollageShareView.h"
#import "HKBurstingEndViewController.h"
#import "HKLuckyBurstFriendsViewController.h"
@interface HKBurstingActivityInfoViewController ()<UITableViewDelegate,UITableViewDataSource,HKUserEnergyTableViewCellDelegate,HKBurstingVodeoTableViewCellDelegate,HKLuckyBurstListTableViewCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKluckyBurstDetailRespone *respone;
@property (nonatomic, strong)HKBurstingEndViewController *endVc;
@end

@implementation HKBurstingActivityInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   HKBurstingVodeoTableViewCell*cell =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    [cell pausePlay];
}
-(void)backItemClick{
    [super backItemClick];
    HKBurstingVodeoTableViewCell*cell =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    [cell releasePlayer];
    
}
-(void)loadData{
    [HKShoppingViewModel luckyBurstDetail:@{@"loginUid":HKUSERLOGINID,@"orderNumber":self.orderNumber} success:^(HKluckyBurstDetailRespone *responde) {
        if (responde.responeSuc) {
            self.respone = responde;
            if (self.respone.data.state.integerValue < 0) {
                self.tableView.hidden = NO;
                 [self.tableView reloadData];
            }else{
                self.tableView.hidden = YES;
                [self.view addSubview:self.endVc.view];
                self.endVc.respone = responde;
                [self.endVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view);
                }];
            }
           
        }
    }];
}
-(void)setUI{
    self.title = @"爆款活动详情";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)gotoHelpFriendList{
    HKLuckyBurstFriendsViewController*vc = [[HKLuckyBurstFriendsViewController alloc]init];
    vc.orderNumber = self.orderNumber;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)friendsHelp{
    HKShareBaseModel*shareM = [[HKShareBaseModel alloc]init];
    shareM.burstListData = self.respone.data;
    shareM.subVc = self;
     [HKCollageShareView showSelfBotomWithselectSheetBlock:nil shareModel:shareM];
}
-(void)aliyunVodPlayerEventFinish:(NSString *)videoId{
    [HKShoppingViewModel getLuckyBurstByAdv:@{@"loginUid":HKUSERLOGINID,@"luckyBurstAdvId":videoId,@"orderNumber":self.orderNumber} success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
           // 获取能量成功
            [SVProgressHUD showSuccessWithStatus:@"获取能量成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:responde.msg];
        }
    }];
}
-(void)burstEnd{
    if ([self.delegate respondsToSelector:@selector(burstEnd)]) {
        [self.delegate burstEnd];
    }
}
-(void)helpFriends{
    
    [HKShoppingViewModel getLuckyBurstByFriend:@{@"loginUid":HKUSERLOGINID,@"orderNumber":self.orderNumber} success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            // 获取能量成功
            [SVProgressHUD showSuccessWithStatus:@"助力成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:responde.msg];
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
        _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bkms_dbbg"]];
        UIView*footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        footView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
        _tableView.tableFooterView = footView;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 6) {
        return self.respone.data.list.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKLuckyBurstListTableViewCell*cell = [HKLuckyBurstListTableViewCell baseCellWithTableView:tableView];
        if (self.respone) {
            cell.model = self.respone;
        }
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1){
        HKExplainHeadTableViewCell*cell = [HKExplainHeadTableViewCell baseCellWithTableView:tableView];
        return cell;
    }else if (indexPath.section == 2){
        HKUserEnergyTableViewCell*cell = [HKUserEnergyTableViewCell baseCellWithTableView:tableView];
        cell.delegate = self;
        if (self.respone) {
             cell.respone = self.respone;
        }
       
        return cell;
    }else if(indexPath.section == 3){
        HKBurstingVodeoTableViewCell*cell = [HKBurstingVodeoTableViewCell baseCellWithTableView:tableView];
        cell.vodeoArray = self.respone.data.advs;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 4){
        HKBurstingAtivityFriendTableViewCell*cell = [HKBurstingAtivityFriendTableViewCell baseCellWithTableView:tableView];
        cell.type = 1;
        cell.model = self.respone.data.u;
        return cell;
    }else if (indexPath.section == 5){
        HKRankingHeadTableViewCell*cell = [HKRankingHeadTableViewCell baseCellWithTableView:tableView];
        cell.num = self.respone.data.list.count;
        return cell;
    }else{
        HKBurstingAtivityFriendTableViewCell*cell = [HKBurstingAtivityFriendTableViewCell baseCellWithTableView:tableView];
        cell.type = 0;
        cell.model = self.respone.data.list[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 220;
    }else if (indexPath.section == 1) {
        return 30;
    }else if (indexPath.section == 2) {
        return 287;
    }else if (indexPath.section == 3){
        return 242;
    }
    return 60;
}
-(HKBurstingEndViewController *)endVc{
    if (!_endVc) {
        _endVc = [[HKBurstingEndViewController alloc]init];
    }
    return _endVc;
}
@end
