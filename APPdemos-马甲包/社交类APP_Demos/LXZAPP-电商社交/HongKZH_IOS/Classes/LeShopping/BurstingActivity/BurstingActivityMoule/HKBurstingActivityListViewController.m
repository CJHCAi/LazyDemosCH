//
//  HKBurstingActivityListViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBurstingActivityListViewController.h"
#import "HKShoppingViewModel.h"
#import "HKLuckyBurstListTableViewCell.h"
#import "HKLuckyBurstListRespone.h"
#import "HKExplainHeadTableViewCell.h"
#import "HKBurstingAtivityFriendTableViewCell.h"
#import "HKRankingHeadTableViewCell.h"
#import "BurstingActivityPayBtn.h"
#import "UIAlertView+Blocks.h"
#import "HKBurstingActivityInfoViewController.h"
@interface HKBurstingActivityListViewController ()<UITableViewDelegate,UITableViewDataSource,BurstingActivityPayBtnDelegate,HKLuckyBurstListTableViewCellDelegate,HKBurstingAtivityFriendTableViewCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKLuckyBurstListRespone *listRespone;
@property (nonatomic, strong)BurstingActivityPayBtn*btn ;


@end

@implementation HKBurstingActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadDataSuccess:^(BOOL isSuc) {
        
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)gotoInfoVc{
    HKBurstingActivityInfoViewController*vc = [[HKBurstingActivityInfoViewController alloc]init];
    vc.orderNumber = self.listRespone.data.u.orderNumber;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)gotoInfoVcLoad{
    [self loadDataSuccess:^(BOOL isSuc) {
        if (isSuc) {
            HKBurstingActivityInfoViewController*vc = [[HKBurstingActivityInfoViewController alloc]init];
            vc.orderNumber = self.listRespone.data.u.orderNumber;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    
}
-(void)burstingAtivityFriendClick{
    [self gotoInfoVc];
}
-(void)burstEnd{
    if ([self.delegate respondsToSelector:@selector(updateStaue:index:)]) {
        [self.delegate updateStaue:-1 index:self.indexVc];
    }
}
-(void)toInfoVc{
     
    if (self.listRespone.data.u&&self.model.sortDate == 0) {
        [self gotoInfoVc];
        
    }else{
    }
}
-(void)loadDataSuccess:(void (^)(BOOL isSuc))success{
    [HKShoppingViewModel getLuckyBurstList:@{@"loginUid":HKUSERLOGINID,@"typeId":self.model.typeId} success:^(HKLuckyBurstListRespone *responde) {
        if (responde.responeSuc) {
            self.listRespone = responde;
            [self.tableView reloadData];
            if (self.model.sortDate == 0&&responde.data.u == nil) {
                self.btn.num = responde.data.integral;
            }
            if (self.model.sortDate != 0&&responde.data.u ==nil) {
                self.btn.num = -2;
            }
            
            if (responde.data.u&&self.model.sortDate != 0) {
                self.btn.num = -1;
            }
            if (responde.data.u&&self.model.sortDate == 0) {
                self.btn.num = -2;
            }
           
            success(YES);
        }else{
             success(NO);
        }
    }];
    
}

-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(43);
        make.bottom.equalTo(self.view).offset(-22);
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//        _tableView.estimatedRowHeight = 245;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bkms_dbbg"]];
        UIView*footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        footView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
        _tableView.tableFooterView = footView;
    }
    return _tableView;
}
-(void)burstingActivityPay{
    if (self.listRespone.data.u) {
        [self gotoInfoVc];
    }else{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"您确定支付吗" cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
    }] otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
        [HKShoppingViewModel buyLuckyBurst:@{@"loginUid":HKUSERLOGINID,@"burstCouponId":self.listRespone.data.burstCouponId} success:^(HKBaseResponeModel *responde) {
            if (responde.responeSuc) {
                [SVProgressHUD showSuccessWithStatus:@"购买成功"];
                [self gotoInfoVcLoad];
            }else{
                [SVProgressHUD showErrorWithStatus:responde.msg];
            }
        }];
    }] , nil];
    
    [alertView show];
    }
   
}
#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0||section==1||section == 3) {
        return 1;
    }
    if (section == 2) {
        if (self.listRespone.data.u) {
            return 1;
        }
    }
    if (section == 4) {
        return self.listRespone.data.list.count;
        
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKLuckyBurstListTableViewCell*cell = [HKLuckyBurstListTableViewCell baseCellWithTableView:tableView];
        if (self.listRespone) {
            cell.respone = self.listRespone;
        }
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1){
        HKExplainHeadTableViewCell*cell = [HKExplainHeadTableViewCell baseCellWithTableView:tableView];
        return cell;
    }else if(indexPath.section == 2){
        HKBurstingAtivityFriendTableViewCell*cell = [HKBurstingAtivityFriendTableViewCell baseCellWithTableView:tableView];
        cell.type = 1;
        cell.model = self.listRespone.data.u;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 3){
        HKRankingHeadTableViewCell*cell = [HKRankingHeadTableViewCell baseCellWithTableView:tableView];
        cell.num = self.listRespone.data.list.count;
        return cell;
    }else{
        HKBurstingAtivityFriendTableViewCell*cell = [HKBurstingAtivityFriendTableViewCell baseCellWithTableView:tableView];
        cell.type = 0;
        cell.model = self.listRespone.data.list[indexPath.row];
        return cell;
    }
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
         return 220;
    }else if (indexPath.section==1){
        return 43;
    }
    return 60;
}
-(BurstingActivityPayBtn *)btn{
    if (!_btn) {
        BurstingActivityPayBtn*btn = [[BurstingActivityPayBtn alloc]init];
        _btn = btn;
        _btn.delegate = self;
        _btn.hidden = YES;
    }
    return _btn;
}
@end
