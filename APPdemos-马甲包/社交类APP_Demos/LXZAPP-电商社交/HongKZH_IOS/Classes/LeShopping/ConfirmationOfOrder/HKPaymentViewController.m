//
//  HKPaymentViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPaymentViewController.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"
#import "UIView+BorderLine.h"
#import "UIImage+YY.h"
#import "HKConfirmationOfOrderViewModel.h"
#import "HKSaveOrderRespone.h"
#import "HK_SaveOrderDataModel.h"
#import "HK_RechargeController.h"
#import "WXApi.h"
@interface HKPaymentViewController ()
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UIButton *gotoRecharge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceRight;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic, strong)HKSaveOrderRespone *respone;
@end

@implementation HKPaymentViewController
-(void)awakeFromNib{
    [super awakeFromNib];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[HKPaymentViewController alloc]initWithNibName:@"HKPaymentViewController" bundle:nil];
    
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setUI];
    
    //注册微信通知...
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayResult:) name:WechatPayResult object:nil];
}
-(void)setUI{
    self.gotoRecharge.layer.cornerRadius = 5;
    self.gotoRecharge.layer.masksToBounds = YES;
    [self.gotoRecharge borderForColor:RGB(64, 144, 246) borderWidth:1 borderType:UIBorderSideTypeAll];
    self.payBtn.layer.cornerRadius = 5;
    self.payBtn.layer.masksToBounds = YES;
    [self.payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [self.gotoRecharge addTarget:self action:@selector(tobalance) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn addTarget:self action:@selector(closePay) forControlEvents:UIControlEventTouchUpInside];
}
-(void)loadData{
    [HKConfirmationOfOrderViewModel getSaveOrderWithCartIdArray:self.cartArray dict:@{@"loginUid":HKUSERLOGINID,@"addressId":self.addressId} success:^(HKSaveOrderRespone *responde) {
        if (responde.responeSuc) {
            self.respone =responde;
            
        }
    }];
}
-(void)closePay{
    [self dismissViewControllerAnimated:NO completion:nil];
    if ([self.delegate respondsToSelector:@selector(gotoOrderDetailVcWithOrderId:)]) {
        [self.delegate gotoOrderDetailVcWithOrderId:self.respone.data.ordersId];
        
    }
}

-(void)wechatPayResult:(NSNotification *)nofi {
    NSString * resultString =nofi.object;
    if ([resultString isEqualToString:@"success"]) {
        [HKConfirmationOfOrderViewModel WexinInfoNotice];
         //异步获取结果 需要回调结果..
    }else {
        //支付失败..
    }
}
- (void)pay {
#pragma mark 看下微信支付...


    [HKConfirmationOfOrderViewModel getpayOrder:@{@"loginUid":HKUSERLOGINID,@"ordersId":self.respone.data.ordersId} success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            [self closePay];
        }
    }];
}
- (void)tobalance{
    if ([self.delegate respondsToSelector:@selector(gotoRecharge)]) {
        [self.delegate gotoRecharge];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
+(void)showPaymentViewControllerWithCartArray:(NSArray*)cartArray addressId:(NSString*)addressId subView:(UIViewController*)subVc{
    HKPaymentViewController*vc = [[HKPaymentViewController alloc]init];
    subVc.navigationController.definesPresentationContext = YES;
    vc.addressId = addressId;
    vc.cartArray = cartArray;
    vc.delegate = subVc;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
    [subVc.navigationController presentViewController:vc animated:YES completion:nil];
}
-(void)setRespone:(HKSaveOrderRespone *)respone{
    _respone = respone;
    [self.headBtn hk_setBackgroundImageWithURL:respone.data.user.headImg forState:0 placeholder:kPlaceholderHeadImage];
    self.name.text = respone.data.user.name;
    self.balance.text = [NSString stringWithFormat:@"%.2lf",respone.data.user.integral];
    self.price.text = [NSString stringWithFormat:@"%ld",respone.data.allIntegral];
    if (respone.data.allIntegral>respone.data.user.integral) {
        //余额不足
        self.rightLabel.text = @"余额不足";
        self.balanceRight.constant = 5;
        self.gotoRecharge.hidden = NO;
        self.payBtn.hidden = YES;
    }else{
        self.rightLabel.text = @"";
        self.balanceRight.constant = 0;
        self.gotoRecharge.hidden = YES;
        self.payBtn.hidden = NO;
    }
}
@end
