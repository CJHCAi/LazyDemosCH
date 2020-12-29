//
//  HK_RechargeController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//
#define  ID  @"cellId"
#import "HK_RechargeController.h"
#import "HK_chargeBtn.h"
#define line 15
#define  path 10
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HKChargeViewModel.h"
@interface HK_RechargeController ()<UITableViewDelegate,UITableViewDataSource,chargeViewClickDelegete>
{
    NSMutableArray * _priceArr;
    HK_ChargeModel * _selectModel;
    int _payTye;  //1 .微信 2.支付宝
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray * viewsArray;
@property (nonatomic, strong)UIView *headView;
@property (nonatomic, strong)UILabel *lebiCoinLabel;
@property (nonatomic, strong)UIButton *definBtn;

@end

@implementation HK_RechargeController

-(NSMutableArray *)viewsArray {
    if (!_viewsArray) {
        _viewsArray =[[NSMutableArray alloc] init];
    }
    return _viewsArray;
}
#pragma mark 支付金额等显示
-(UIView *)headView {
    if (!_headView) {
        _headView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,210)];
        UIView *topInfoView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,50)];
        topInfoView.backgroundColor =[UIColor whiteColor];
        [_headView addSubview:topInfoView];
        UILabel * left =[[UILabel alloc] initWithFrame:CGRectMake(15,0,300,50)];
        [AppUtils getConfigueLabel:left font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"当前乐币剩余"];
        left.attributedText =[AppUtils configueLabelAtLeft:YES andCount:-1];
        [topInfoView addSubview:left];
        UILabel *right =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-300,0,300,50)];
        
        [AppUtils getConfigueLabel:right font:PingFangSCMedium14 aliment:NSTextAlignmentRight textcolor:RGB(255,49,34) text:@"500"];
        [topInfoView addSubview:right];
        self.lebiCoinLabel = right;
        self.lebiCoinLabel.text =[NSString stringWithFormat:@"%.2lf",[LoginUserData sharedInstance].integral];
        
    //下部分的选择视图
        UIView * selectView =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(topInfoView.frame),kScreenWidth,250)];
        selectView.backgroundColor =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [_headView addSubview:selectView];
       
        CGFloat btnW =(kScreenWidth-line *2 -path *2)/3;
        CGFloat btnH = 60;
        for (int i=0; i<_priceArr.count; i++) {
            HK_chargeBtn * charV =[[HK_chargeBtn alloc] initWithFrame:CGRectMake(line+(path+btnW)*(i%3),line+(btnH+path)*(i/3),btnW,btnH)];
            charV.mdoel =_priceArr[i];
            [self.viewsArray addObject:charV];
            charV.CoinLabel.text =[NSString stringWithFormat:@"%@ 乐币",charV.mdoel.coin];
            charV.RmbLabel.text =[NSString stringWithFormat:@"%@ 元",charV.mdoel.rmb];
            charV.tag =i+100;
            charV.delegete = self;
            if (i==0) {
                charV.layer.borderColor = [RGB(255,49,34) CGColor];
                HK_ChargeModel * firstM = (HK_ChargeModel *)_priceArr[i];
                _selectModel =firstM;
            }
            [selectView addSubview:charV];
        }
    }
    return _headView;
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

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.headView.frame),kScreenWidth,100) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.scrollEnabled =NO;
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.showsHorizontalScrollIndicator =NO;
        _tableView.tableFooterView =[[UIView alloc] init];
        _tableView.backgroundColor =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    }
    return _tableView;
}

-(UIButton *)definBtn
{
    if (!_definBtn) {
        _definBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _definBtn.frame =CGRectMake(30,CGRectGetMaxY(self.tableView.frame)+40,kScreenWidth-60,49);
        [AppUtils getButton:_definBtn font:PingFangSCRegular15 titleColor:[UIColor whiteColor] title:@"确认支付"];
        _definBtn.layer.cornerRadius =5;
        _definBtn.layer.masksToBounds =YES;
        _definBtn.backgroundColor =RGB(255,49,34);
        [_definBtn addTarget:self action:@selector(chargeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _definBtn;
}
-(void)chargeAction:(UIButton *)sender {
    NSString * types;
    if (_payTye==1) {
        types =@"微信";
    }else {
        types =@"支付宝";
    }
    [HKChargeViewModel getChargeOrderIdWithIntegral:_selectModel.coin successBlock:^(HKChargeResponse *response) {
        NSString *orderString =response.data.orderNumber;
//        //创建支付订单..
        [HKChargeViewModel creatPayInfoWithOrders:orderString andPayType:HKPayType_Charge success:^(WxAppPayresponse *responde) {
            PayReq *req = [[PayReq alloc] init];
            req.openID =responde.data.appid;
            req.partnerId =responde.data.partnerid;
            req.nonceStr =responde.data.nonceStr;
            req.timeStamp =(UInt32)responde.data.timeStamp;
            req.package =responde.data.package;
            req.sign  =responde.data.sign;
            req.prepayId =responde.data.prepayid;
     
            [WXApi sendReq:req];
        }];
    } fial:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}
-(void)configueWechatAndAliPay {
    //判断是否安装微信
    if([WXApi isWXAppInstalled]) {
        // 监听一个通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"ORDER_PAY_NOTIFICATION" object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiUserPayInfo:) name:AliPayOrderResult object:nil];
}
#pragma mark 支付宝回调
-(void)notifiUserPayInfo:(NSNotification *)info {
    
    NSString *status =info.userInfo[@"status"];
    
    if ([status isEqualToString:@"Finished"]) {
        //处理结果
        [EasyShowTextView showText:@"支付完成"];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [EasyShowTextView showText:@"支付失败"];
    }
}
#pragma mark - 收到支付成功的消息后作相应的处理
- (void)getOrderPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"]) {
//      //支付成功之后加上乐币数值..
//        NSInteger coin =_selectModel.coin.integerValue;
//        NSInteger intergral=[LoginUserData sharedInstance].integral;
//        NSInteger total =coin + intergral;
//        [LoginUserData sharedInstance].integral = total;
    } else {
        //支付成功之后加上乐币数值..
        NSInteger coin =_selectModel.coin.integerValue;
        NSInteger intergral=[LoginUserData sharedInstance].integral;
        NSInteger total =coin + intergral;
        [LoginUserData sharedInstance].integral = total;
        self.lebiCoinLabel.text =[NSString stringWithFormat:@"%.2lf",[LoginUserData sharedInstance].integral];
        [EasyShowTextView showText:@"支付失败"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"充值";
    [self setShowCustomerLeftItem:YES];
//配置微信和阿里的支付监听
    [self configueWechatAndAliPay];
    
  //配置价格数据
    _priceArr =[[NSMutableArray alloc] init];
    HK_ChargeModel * mdoel1 =[[HK_ChargeModel alloc] init];
    mdoel1.coin =@"600";
    mdoel1.rmb =@"6";
    [_priceArr addObject:mdoel1];
    HK_ChargeModel *model2 =[[HK_ChargeModel alloc]init];
    model2.coin =@"1800";
    model2.rmb =@"18";
    [_priceArr addObject:model2];
    HK_ChargeModel *model3 =[[HK_ChargeModel alloc]init];
    model3.coin =@"3000";
    model3.rmb =@"30";
    [_priceArr addObject:model3];
    HK_ChargeModel *model4 =[[HK_ChargeModel alloc]init];
    model4.coin =@"5000";
    model4.rmb =@"50";
    [_priceArr addObject:model4];
    HK_ChargeModel *model5 =[[HK_ChargeModel alloc]init];
    model5.coin =@"10000";
    model5.rmb =@"100";
    [_priceArr addObject:model5];
    HK_ChargeModel *model6 =[[HK_ChargeModel alloc]init];
    model6.coin =@"15000";
    model6.rmb =@"130";
    [_priceArr addObject:model6];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.definBtn];
    _payTye =1;
}
#pragma mark 点击View的响应事件
-(void)clickChageV:(HK_ChargeModel *)model {
    NSInteger index =[_priceArr indexOfObject:model];
    HK_chargeBtn * curent =[self.viewsArray objectAtIndex:index];
    for (HK_chargeBtn * views in self.viewsArray) {
        views.layer.borderColor =[RGB(229,229,229) CGColor];
    }
    curent.layer.borderColor = [RGB(255,49,34) CGColor];
    _selectModel = model;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *cells =self.tableView.visibleCells;
    for (UITableViewCell * rowCell in cells) {
        rowCell.accessoryType =UITableViewCellAccessoryNone;
    }
    UITableViewCell * currentCell =[self.tableView cellForRowAtIndexPath:indexPath];
    currentCell.accessoryType =UITableViewCellAccessoryCheckmark;
    
    if (indexPath.row) {
        _payTye =2;
    }else {
        _payTye =1;
    }
}
#pragma mark 支付方式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font =PingFangSCRegular15;
        cell.textLabel.textColor =[UIColor colorFromHexString:@"333333"];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text =@"微信支付(推荐)";
            cell.imageView.image =[UIImage imageNamed:@"weixin"];
            cell.accessoryType =UITableViewCellAccessoryCheckmark;
            break;
        case 1:
            cell.textLabel.text =@"支付宝支付";
            cell.imageView.image =[UIImage imageNamed:@"zhifubao"];
            break;
        default:
            break;
    }
    return  cell;
}
#pragma mark 移除通知
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
