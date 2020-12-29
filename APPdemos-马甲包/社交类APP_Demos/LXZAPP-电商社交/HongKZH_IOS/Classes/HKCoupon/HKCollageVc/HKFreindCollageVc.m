//
//  HKFreindCollageVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFreindCollageVc.h"
#import "HKCollageSuccessVc.h"
#import "HKCounSuccessCell.h"
#import "HKColageFriendCell.h"
#import "HKFreindCollageView.h"
#import "HKCounponTool.h"
#import "HK_orderTool.h"
#import "HKCollageDetailVc.h"
#import "HK_PaymentActionSheet.h"
#import "HK_PaymentActionSheetTwo.h"
#import "HK_UserInfoDataModel.h"
#import "CountDown.h"
@interface HKFreindCollageVc ()<UITableViewDelegate,UITableViewDataSource,HKFreindCollageViewDelegate,HK_PaymentActionSheetDelegate,HK_PaymentActionSheetTwoDelegate>
@property (nonatomic, strong)UITableView * counTableView;
@property (nonatomic, strong)HKFreindCollageView * footView;
@property (nonatomic, assign)NSInteger count ;
@property (nonatomic, strong)HKCollageOrderResponse *response;
@property (nonatomic, strong)CountDown * countDown;
@end

@implementation HKFreindCollageVc

-(HKFreindCollageView *)footView {
    if (!_footView) {
        _footView =[[HKFreindCollageView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,104)];
        _footView.delegate = self;
       
    }
    return _footView;
}
-(void)collageBlock{
    [self showPayViews];
}

-(void)rechargeCallback{
    HK_RechargeController * reVc =[[HK_RechargeController alloc] init];
    [self.navigationController pushViewController:reVc animated:YES];
}
#pragma mark 支付....
-(void)showPayViews {
    //1.获取用户乐币
    NSInteger userIntergal =[LoginUserData sharedInstance].integral;
    NSInteger count =self.response.data.integral;
    if (userIntergal>=count) {
        //弹出支付界面
        HK_PaymentActionSheet *payment = [HK_PaymentActionSheet showInView:self.navigationController.view];
        [payment configueCellWithTotalCount:count];
        payment.delegate = self;
    }else {
        //弹出充值
        HK_PaymentActionSheetTwo *recharge = [HK_PaymentActionSheetTwo showInView:self.navigationController.view];
        recharge.delegate = self;
        [recharge configueCellWithTotalCount:count];
    }
}
-(void)paymentCallback{
        //支付-->吊拼团接口..
    [HKCounponTool buyCollageByOrderId:self.orderNumber successBlock:^{
        HKCollageSuccessVc *suv =[[HKCollageSuccessVc alloc] init];
        suv.orderNumber  = self.orderNumber;
        [self.navigationController pushViewController:suv animated:YES];
        } fail:^(NSString *error) {
            [EasyShowTextView showText:@"支付失败"];
    }];
}
-(UITableView *)counTableView {
    if (!_counTableView) {
        _counTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight) style:UITableViewStylePlain
                         ];
        _counTableView.delegate = self;
        _counTableView.dataSource = self;
        _counTableView.tableFooterView =self.footView;
        _counTableView.backgroundColor = MainColor
        _counTableView.rowHeight = 155;
        _counTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _counTableView.scrollEnabled = NO;
        [_counTableView registerClass:[HKColageFriendCell class] forCellReuseIdentifier:@"friend"];
    }
    return _counTableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKColageFriendCell * sucCell =[tableView dequeueReusableCellWithIdentifier:@"friend" forIndexPath:indexPath];
    sucCell.response = self.response;
    return sucCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    HKCollageDetailVc * detailVc =[[HKCollageDetailVc alloc] init];
//    [self.navigationController pushViewController:detailVc animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.showCustomerLeftItem = YES;
    [self.view addSubview:self.counTableView];
    [self getOrderInfo];
    self.countDown = [[CountDown alloc] init];
    ///每秒回调一次
    [self.countDown countDownWithPER_SECBlock:^{
        
        [self updateTimeInVisibleCells];
    }];
}
-(void)updateTimeInVisibleCells {
    
    self.footView.response = self.response;
}
-(void)getOrderInfo {
    [HKCounponTool getCollageOrderInfo:self.orderNumber successBlock:^(HKCollageOrderResponse *response) {
        self.response = response;
        HKCollageList *list =self.response.data.list.firstObject;
        self.title = list.name;
        [self.counTableView reloadData];
    } fail:^(NSString *error) {
        
    }];
}
-(void)viewWillAppear:(BOOL)animated {
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [HK_BaseRequest buildPostRequest:get_usergetUserIntegral body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        HK_UserInfoDataModel * model =[HK_UserInfoDataModel mj_objectWithKeyValues:responseObject];
        if (!model.code) {
            id interger =model.data;
            if ([interger isKindOfClass:[NSNull class]]) {
                [LoginUserData sharedInstance].integral =0;
            }else {
                [LoginUserData sharedInstance].integral =model.data.integral;
            }
        }else {
            [EasyShowTextView showText:@"获取用户乐币失败"];
        }
    } failure:^(NSError * _Nullable error) {
    }];
    
}
@end
