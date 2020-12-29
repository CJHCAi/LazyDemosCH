//
//  HKSetMoneyViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSetMoneyViewController.h"
#import "HK_BaseRequest.h"
#import "HK_UserInfoDataModel.h"
#import "HK_PaymentActionSheet.h"
#import "HK_PaymentActionSheetTwo.h"
#import "HK_RechargeController.h"
#import "HKSendRedEnvelopesTableViewCell.h"
@interface HKSetMoneyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HKSendRedEnvelopesTableViewCellDelagate,HK_PaymentActionSheetDelegate,HK_PaymentActionSheetTwoDelegate>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)HKMoneyModel *monery;
@end
@implementation HKSetMoneyViewController
-(void)getUserCoinNumber {
    [HK_BaseRequest buildPostRequest:get_usergetUserIntegral body:@{kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HK_UserInfoDataModel * model =[HK_UserInfoDataModel mj_objectWithKeyValues:responseObject];
        if (!model.code) {
            id interger =model.data;
            if ([interger isKindOfClass:[NSNull class]]) {
                [LoginUserData sharedInstance].integral =0;
            }else {
                [LoginUserData sharedInstance].integral =model.data.integral;
            }
        }
    } failure:^(NSError * _Nullable error) {
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"发红包";
    [self getUserCoinNumber];
    self.view.backgroundColor = MainColor;
    [self.view addSubview:self.tableView];
}
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(void)setModel:(HKMoneyModel *)model {
    _model = model;
    if (model) {
        //普通模式
        if (model.type.integerValue ==1) {
        }else {
        }
    }
}
-(void)paymentCallback{

    if (self.block) {
        self.block(self.model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rechargeCallback{
    HK_RechargeController * reVc =[[HK_RechargeController alloc] init];
    [self.navigationController pushViewController:reVc animated:YES];
}
#pragma  mark 确定发红包
-(void)subComplains:(HKMoneyModel *)model {
    [self.view endEditing:YES];
    //1.获取用户乐币
    self.model = model;
    NSInteger userIntergal =[LoginUserData sharedInstance].integral;
    if (userIntergal>=model.totalMoney) {
        HK_PaymentActionSheet *payment = [HK_PaymentActionSheet showInView:self.navigationController.view];
          [payment configueCellWithTotalCount:model.totalMoney];
          payment.delegate = self;
       
    }else {
//        弹出充值
        HK_PaymentActionSheetTwo *recharge = [HK_PaymentActionSheetTwo showInView:self.navigationController.view];
        [recharge configueCellWithTotalCount:model.totalMoney];
        recharge.delegate = self;
        
    }
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView =[[UIView alloc] init];
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKSendRedEnvelopesTableViewCell*cell = [HKSendRedEnvelopesTableViewCell baseCellWithTableView:tableView];
    cell.delegate = self;
    return cell;
    
}
@end
