//
//  HKSettlementReceptionViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSettlementReceptionViewController.h"
#import "HKConfirmationOfOrderViewModel.h"
#import "WXApi.h"
#import "HKSaveOrderRespone.h"
#import "HK_SaveOrderDataModel.h"
#import "UIImage+YY.h"
#import "UIView+Frame.h"
#import "HK_orderDetailVc.h"
@interface HKSettlementReceptionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (nonatomic, strong)HKSaveOrderRespone *responde;
@property (nonatomic, strong)UIView *footView;
@property (nonatomic, copy)NSString *payOrderId;
@property (weak, nonatomic) IBOutlet UIView *navVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navDown;
@property (nonatomic, strong)UIButton *payBtn;
@end

@implementation HKSettlementReceptionViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[HKSettlementReceptionViewController alloc]initWithNibName:@"HKSettlementReceptionViewController" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableVIew.delegate = self;
    self.tableVIew.dataSource = self;
    self.tableVIew.tableFooterView = self.footView;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayCallback:) name:WechatPayResult object:nil];
    
}
-(void)wxPayCallback:(NSNotification*)notifia{
    NSString*result =(NSString*)notifia.object;
    if ([WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"未安装微信" cancelButtonItem:nil otherButtonItems:nil, nil];
        [alertView show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
    if (self.payType == HKPayType_LeShopOrder) {
        if (self.isFromGame) {
            if ([result isEqualToString:@"success"]) {
                //        [self.navigationController popToRootViewControllerAnimated:YES];
                NSDictionary*dict = @{@"payType":@(self.payType),@"resultCode":@"1"};
                NSError *parseError = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                [self backClick:nil];
            }else{
                NSDictionary*dict = @{@"payType":@(self.payType),@"resultCode":@"1"};
                NSError *parseError = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                
//                [self backClick:nil];
            }
            return;
        }
        [self gotoOrderDetailVcWithOrderId:self.payOrderId];
    }else{
        if ([result isEqualToString:@"success"]) {
            //        [self.navigationController popToRootViewControllerAnimated:YES];
            NSDictionary*dict = @{@"payType":@(self.payType),@"resultCode":@"1"};
            NSError *parseError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
           
            [self backClick:nil];
        }else{
            NSDictionary*dict = @{@"payType":@(self.payType),@"resultCode":@"1"};
            NSError *parseError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
//            [self backClick:nil];
        }
    }
    
}
-(void)gotoOrderDetailVcWithOrderId:(NSString*)orderId{
    HK_orderDetailVc * detailVc =[[HK_orderDetailVc alloc] init];
    
    Hk_subOrderList * model = [[Hk_subOrderList alloc]init];
    model.orderNumber = orderId;
    detailVc.listModel  = model;
    [self.navigationController pushViewController:detailVc animated:YES];
    NSMutableArray*array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (int i = (int)array.count-1; i>=0; i--) {
        UIViewController*vc = array[i];
        if ((i != 0)&&(![vc isKindOfClass:[HK_orderDetailVc class]])) {
            [array removeObject:vc];
        }
    }
    DLog(@"%@",self.navigationController.viewControllers);
    self.navigationController.viewControllers = array;
}
-(void)payClick{
    [HKChargeViewModel creatPayInfoWithOrders:self.payOrderId andPayType:self.payType success:^(WxAppPayresponse *responde) {
        if (responde.responeSuc) {
            PayReq *req = [[PayReq alloc] init];
            req.openID =responde.data.appid;
            req.partnerId =responde.data.partnerid;
            req.nonceStr =responde.data.nonceStr;
            req.timeStamp =(UInt32)responde.data.timeStamp;
            req.package =responde.data.package;
            req.sign  =responde.data.sign;
            req.prepayId =responde.data.prepayid;
            
            [WXApi sendReq:req];
        }else{
            [SVProgressHUD showErrorWithStatus:@"生成订单失败"];
        }
        
    }];
}
-(void)loadData:(NSString *)orderID monery:(NSString*)monery payType:(HKPayType)paytype{
    self.payOrderId = orderID;
    self.num.text = monery;
    self.payType = paytype;
    self.payBtn.userInteractionEnabled = YES;
}
#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Reception"];
    if (cell==nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Reception"];
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
-(void)loadDataCartArray:(NSArray*)cartArray addressId:(NSString*)addressId{
    self.cartArray = cartArray;
    self.addressId = addressId;
    [self loadData];
}
-(void)loadData{
    [HKConfirmationOfOrderViewModel getSaveOrderWithCartIdArray:self.cartArray dict:@{@"loginUid":HKUSERLOGINID,@"addressId":self.addressId} success:^(HKSaveOrderRespone *responde) {
        if (responde.responeSuc) {
            self.responde =responde;
            [self loadData:responde.data.ordersId monery:[NSString stringWithFormat:@"%ld",responde.data.allIntegral] payType:HKPayType_LeShopOrder];
        }
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45+137+45)];
   
        [_footView addSubview:self.payBtn];
    }
    return _footView;
}
-(UIButton *)payBtn{
    if (!_payBtn) {
        CGFloat w = kScreenWidth;
        if (kScreenWidth>kScreenHeight) {
            w = kScreenHeight;
        }
        UIButton*btn = [[UIButton alloc]initWithFrame:CGRectMake(30, 137, w-60, 45)];
        btn.centerX = w*0.5;
        btn.userInteractionEnabled = NO;
        [btn setTitle:@"立即付款" forState:0];
        btn.titleLabel.font = PingFangSCMedium15;
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        
        UIImage*image = [[UIImage createImageWithColor:[UIColor colorFromHexString:@"EF593C"] size:CGSizeMake(w-60, 45)]zsyy_imageByRoundCornerRadius:5];
        [btn setBackgroundImage:image forState:0];
        [btn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
        _payBtn = btn;
    }
    return _payBtn;
}

-(void)setPayType:(HKPayType)payType{
    _payType = payType;
    if (payType == HKPayType_GameCharge) {
        self.navDown.constant = 64;
        self.navVIew.hidden = NO;
    }else{
        self.navDown.constant = 0;
        self.navVIew.hidden = YES;
    }
}
- (IBAction)backClick:(id)sender {
//    [GetAppController() setupUnity];
}
@end
