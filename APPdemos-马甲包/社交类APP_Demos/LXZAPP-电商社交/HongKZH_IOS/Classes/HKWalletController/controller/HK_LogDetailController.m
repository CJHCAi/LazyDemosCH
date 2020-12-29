//
//  HK_LogDetailController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_LogDetailController.h"
#import "HK_DetailLogView.h"
#import "HK_BaseRequest.h"
#import "HK_WalletLogDetailModel.h"
@interface HK_LogDetailController ()
@property (nonatomic, strong)HK_DetailLogView * detailV;
@property (nonatomic, strong)UILabel *cashLabel;
@property (nonatomic, strong)UIImageView * coinImageV;
@property (nonatomic, strong)UILabel *countLabel;
@property (nonatomic, strong)UIView *liveV;
@property (nonatomic, strong)LogDetailData * data;
@end

@implementation HK_LogDetailController
-(void)initNav {
    self.navigationItem.title = @"明细";
    [self setShowCustomerLeftItem:YES];
    
}
-(HK_DetailLogView *)detailV {
    if (!_detailV) {
        _detailV =[[HK_DetailLogView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.liveV.frame)+8,kScreenWidth,160)];
    }
    return _detailV;
}
-(UILabel *)cashLabel {
    if (!_cashLabel) {
        _cashLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,32,60,10)];
        [AppUtils getConfigueLabel:_cashLabel font:PingFangSCMedium13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"入账金额:"];
        
    }
    return _cashLabel;
}

-(UIImageView *)coinImageV {
    if (!_coinImageV) {
        _coinImageV =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cashLabel.frame)+20,CGRectGetMinY(self.cashLabel.frame)-4,17,18)];
        _coinImageV.image =[UIImage imageNamed:@"coin5"];
    }
    return _coinImageV;
}
-(UILabel *)countLabel {
    if (!_countLabel) {
        
        _countLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.coinImageV.frame)+3,CGRectGetMinY(self.cashLabel.frame)-5,120,20)];
        [AppUtils getConfigueLabel:_countLabel font:PingFangSCMedium25 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"e15640"] text:@""];
    }
    return _countLabel;
}
-(UIView *)liveV {
    if (!_liveV) {
        _liveV =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.cashLabel.frame)+32,kScreenWidth,1)];
        _liveV.backgroundColor =[UIColor colorFromHexString:@"eeeeee"];
    }
    return _liveV;
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
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self  initNav];
    [self.view addSubview:self.cashLabel];
    [self.view addSubview:self.coinImageV];
    [self.view addSubview:self.countLabel];
    [self.view addSubview:self.liveV];
    [self.view addSubview:self.detailV];
    
    [self getDetails];
    
}
-(void)getDetails {
    NSMutableDictionary * dic =[[NSMutableDictionary alloc] init];
    //LoginUserData * data =[LoginUserData sharedInstance];
    [dic setValue:self.logId forKey:@"logId"];
    [dic setValue:LOGIN_UID  forKey:@"loginUid"];
    [HK_BaseRequest buildPostRequest:get_userMyWalletLogDetails body:dic success:^(id  _Nullable responseObject) {
        HK_WalletLogDetailModel *detailModel =[HK_WalletLogDetailModel mj_objectWithKeyValues:responseObject];
        
        self.data = detailModel.data;
       
        [self UpDateUI];
        
    
    } failure:^(NSError * _Nullable error) {
    }];
}

#pragma mark 更新数据
-(void)UpDateUI {
    if ([self.data.type isEqualToString:@"1"]) {
        self.cashLabel.text =@"入账金额:";
    }
    else {
        self.cashLabel.text =@"消费金额:";
    }
    NSString * countStr  =[NSString stringWithFormat:@"%.2f",self.data.integral];
    NSMutableString * stringCount =[[NSMutableString alloc] initWithString:countStr];
    if (stringCount.length>2) {
        [stringCount insertString:@" " atIndex:2];
    }
    self.countLabel.text = stringCount;
    [self.detailV upDateLogDatasWithModel:self.data];
    
}

@end
