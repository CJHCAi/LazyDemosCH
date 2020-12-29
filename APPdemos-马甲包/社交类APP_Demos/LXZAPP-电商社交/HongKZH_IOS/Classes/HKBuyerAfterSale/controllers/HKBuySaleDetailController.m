//
//  HKBuySaleDetailController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBuySaleDetailController.h"
#import "HKAfterSaleRespone.h"
#import "HKAfterSaleViewModel.h"
#import "HK_SaleInfoCell.h"
#import "HK_orderShopFooterView.h"
#import "HK_orderDetailVc.h"
#import "Hk_MyOrderDataModel.h"
#import "HKApplicationRefundTableViewCell.h"
#import "HKTAgreeableViewCell.h"
#import "HKAfterLogisticsTableViewCell.h"
#import "HKPleaseReturnTableViewCell.h"
#import "HKCancleTableViewCell.h"
#import "HKProofTableViewCell.h"
#import "HK_BuyAfterTool.h"
#import "HK_orderTool.h"

@interface HKBuySaleDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKAfterSaleRespone *respone;
@property (nonatomic, strong)HK_orderShopFooterView *footViews;
@end

@implementation HKBuySaleDetailController

#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self loadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)loadData{
   
    [HKAfterSaleViewModel orderAfterSale:@{@"loginUid ":LOGIN_UID,@"orderNumber":self.mdoel.orderNumber} success:^(HKAfterSaleRespone *responde) {
        if (responde.responeSuc) {
        
            self.respone = responde;
            [self.tableView reloadData];
        }
    }];
}
-(void)setUI{
    
    self.title = @"退款进度";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footViews];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-48-SafeAreaBottomHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView
        .separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[UINib nibWithNibName:@"HK_SaleInfoCell" bundle:nil] forCellReuseIdentifier:@"sale"];
    }
    return _tableView;
}
- (void)viewDidLoad {
   
    [super viewDidLoad];
    [self setShowCustomerLeftItem:YES];
    [self setUI];
    
}
-(HK_orderShopFooterView *)footViews {
    if (!_footViews) {
        _footViews =[[HK_orderShopFooterView alloc] initWithFrame:CGRectMake(0,kScreenHeight-48-NavBarHeight-StatusBarHeight-SafeAreaBottomHeight,kScreenWidth,48)];
        _footViews.layer.borderWidth =1;
        _footViews.layer.borderColor  =[[UIColor colorFromHexString:@"cccccc"] CGColor];
        [_footViews.rightBtn setTitle:@"订单详情" forState:UIControlStateNormal];
        [_footViews.rightBtn addTarget:self action:@selector(checkDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footViews;
}
//订单详情
-(void)checkDetail {
    HK_orderDetailVc *vc =[[HK_orderDetailVc alloc] init];
    Hk_subOrderList * listM =[[Hk_subOrderList alloc] init];
    listM.orderNumber =self.mdoel.orderNumber;
    vc.listModel =listM;
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        NSInteger rowNum =  self.respone.data.cellArray.count;
        return rowNum;
    }
    return  1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return 80;
    }
    return tableView.rowHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
    v.backgroundColor =self.view.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    return v;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        AfterSaleViewStatue statue = [self.respone.data.cellArray[indexPath.row] intValue];

        switch (statue) {
            //申请退款
            case AfterSaleViewStatue_Application:
            case AfterSaleViewStatue_ApplicationReturn:
            {
                HKApplicationRefundTableViewCell*cell = [HKApplicationRefundTableViewCell afterBaseTableViewCellWithTableView:tableView];
                cell.staue = statue;
                cell.delegate = self;
                cell.model = self.respone;
                
                [cell changeBarStatus];
                
                return cell;
            }
             //取消退款
           case AfterSaleViewStatue_cancel:
            {
                HKApplicationRefundTableViewCell*cell = [HKApplicationRefundTableViewCell afterBaseTableViewCellWithTableView:tableView];
                cell.staue = statue;
                cell.delegate = self;
                cell.model = self.respone;
                [cell cancelRefund];
                return cell;
            }
                break;
            case AfterSaleViewStatue_Refuse:
            case AfterSaleViewStatue_Agree:
            case AfterSaleViewStatue_finish:
            case AfterSaleViewStatue_RefuseReturn:
            {
                HKTAgreeableViewCell*cell = [HKTAgreeableViewCell afterBaseTableViewCellWithTableView:tableView];
                cell.staue = statue;
                cell.delegate = self;
                cell.model = self.respone;
            //拒绝退款显示底部的工具条并修改标题...
                if (cell.model.data.afterState.intValue==AfterSaleViewStatue_Refuse||cell.model.data.afterState.intValue==AfterSaleViewStatue_RefuseReturn) {
                    [cell sellerRefuseRefundShowing];
                }else if (cell.model.data.afterState.intValue==AfterSaleViewStatue_Complaint||cell.model.data.afterState.intValue ==AfterSaleViewStatue_cancelComplaint||cell.model.data.afterState.intValue==AfterSaleViewStatue_cancelApplicationReturn){
                   //买家投诉 取消投诉
                    [cell buyComplain];
                }
                return cell;
            }
                break;
            case AfterSaleViewStatue_SendReturnDelivery:
            case AfterSaleViewStatue_Complaint:
            {
                HKAfterLogisticsTableViewCell*cell = [HKAfterLogisticsTableViewCell afterBaseTableViewCellWithTableView:tableView];
                cell.staue = statue;
                cell.delegate = self;
                cell.model = self.respone;
                
                [cell changeBtnStatus];
                
                return cell;
            }
                break;
            //同意退货
            case AfterSaleViewStatue_AgreeReturn:
            {
                
                HKPleaseReturnTableViewCell*cell = [HKPleaseReturnTableViewCell afterBaseTableViewCellWithTableView:tableView];
                cell.staue = statue;
                cell.delegate = self;
                cell.model = self.respone;
                [cell changeBarStatus];
                return cell;
            }
                break;
            case AfterSaleViewStatue_ReturnFinish:
            {
                HKTAgreeableViewCell*cell = [HKTAgreeableViewCell afterBaseTableViewCellWithTableView:tableView];
                cell.staue = statue;
                cell.delegate = self;
                cell.model = self.respone;
                return cell;
            }
                break;
            case AfterSaleViewStatue_ProofOfBuyerseller:
            case AfterSaleViewStatue_ProofOfBuyer:
            {
                HKProofTableViewCell *cell = [HKProofTableViewCell afterBaseTableViewCellWithTableView:tableView];
                cell.staue = statue;
                cell.delegate = self;
                cell.model = self.respone;
                [cell changeBtnTitles];
                return cell;
            }
                break;
            case AfterSaleViewStatue_cancelApplicationReturn:
            case AfterSaleViewStatue_cancelComplaint:
                
            {
                HKCancleTableViewCell*cell = [HKCancleTableViewCell afterBaseTableViewCellWithTableView:tableView];
                cell.staue = statue;
                cell.delegate = self;
                cell.model = self.respone;
            
                return cell;
            }
                break;
                
            default:
                break;
        }
    }
    HK_SaleInfoCell * saleCell =[tableView dequeueReusableCellWithIdentifier:@"sale" forIndexPath:indexPath];
    [saleCell ConfigueCellWithOrderString:self.mdoel.orderNumber andResponse:self.respone];
    return  saleCell;
}

#pragma mark 修改物流
-(void)trackingLogistics {
    
    if (self.respone.data.afterState.intValue ==AfterSaleViewStatue_RefuseReturn) {
        //修改退款
        [HK_orderTool pushOrderReFundVc:self.mdoel.orderNumber orderStatus:HK_orderReFund orderType:@"2" andCurrentVc:self];
    }else {
        if (self.respone.data.afterState.intValue==AfterSaleViewStatue_SendReturnDelivery) {
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showErrorWithStatus:@"快递已经发出,不可修改!"];
        }else {
            //填写物流..
            [HK_BuyAfterTool pushAddressControllerWithOrderString:self.mdoel.orderNumber withCurrentVC:self];
        }
    }
}
#pragma mark 投诉
-(void)directRefund {
    
    [HK_orderTool pushrderComplainVc:self.mdoel.orderNumber andCurrentVc:self withType:1];
}
#pragma mark 举证
-(void)proof {

    [HK_orderTool pushrderComplainVc:self.mdoel.orderNumber andCurrentVc:self withType:2];
}
#pragma mark 修改退款 // 取消投诉
-(void)approvalArefund {
    
    if (self.respone.data.afterState.intValue ==AfterSaleViewStatue_ApplicationReturn) {
        //修改退款
        [HK_orderTool pushOrderReFundVc:self.mdoel.orderNumber orderStatus:Hk_orderRefundAfter orderType:@"2" andCurrentVc:self];
    }else if (self.respone.data.afterState.intValue ==AfterSaleViewStatue_AgreeReturn){
       //填写物流..
        [HK_BuyAfterTool pushAddressControllerWithOrderString:self.mdoel.orderNumber withCurrentVC:self];
    }else if (self.respone.data.afterState.intValue==AfterSaleViewStatue_SendReturnDelivery){
       //查看物流..
       // [EasyShowTextView showText:@"跟踪物流"];
        HKLogisticsViewController*vc = [[HKLogisticsViewController alloc]init];
        HKOrderInfoData*model = [[HKOrderInfoData alloc]init];
        model.courier = self.respone.data.courier;
        model.courierNumber = self.respone.data.courierNumber;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.respone.data.afterState.intValue==AfterSaleViewStatue_Complaint||self.respone.data.afterState.intValue==AfterSaleViewStatue_ProofOfBuyer||self.respone.data.afterState.intValue==AfterSaleViewStatue_ProofOfBuyerseller ){
      //取消投诉
        [HK_BuyAfterTool cancelUserOderWithOrderNumber:self.mdoel.orderNumber handleBlock:^{
            if (self.cancelBlock) {
                self.cancelBlock();
            }
        } failError:^(NSString *msg) {
        
            
              [EasyShowTextView showText:msg];
        }];
        [self.navigationController popViewControllerAnimated:YES];
      //拒绝退货-->取消退货
    }else if (self.respone.data.afterState.intValue==AfterSaleViewStatue_RefuseReturn){
        
          [self refusingArefund];
    }
    else
    {
        //退款
        [HK_orderTool pushOrderReFundVc:self.mdoel.orderNumber orderStatus:HK_orderReFund orderType:@"2" andCurrentVc:self];
    }
}
#pragma mark 取消退货或者退款--> 取消退货 ...
-(void)refusingArefund {
    
    NSString * message ;
    if (self.respone.data.afterState.intValue==AfterSaleViewStatue_Application) {
        
        message =@"确定取消退款吗?";
    }else {
        message =@"确定取消退货吗?";
    }
    UIAlertController *HK_alert =[UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]; 
    [HK_alert addAction:actionCancel];
    UIAlertAction * define =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [HK_BuyAfterTool confirmCollectGoodsWithOrderNumber:self.mdoel.orderNumber withAfterStatus:self.respone.data.afterState.intValue handleBlock:^{
            if (self.cancelBlock) {
                self.cancelBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failError:^(NSString *msg) {
            [EasyShowTextView showText:msg];
        }];
    }];
    [HK_alert addAction:define];
    [self presentViewController:HK_alert animated:YES completion:nil];
}
@end
