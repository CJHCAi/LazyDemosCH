//
//  OrderSureViewController.m
//  ListV
//
//  Created by imac on 16/8/2.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "OrderSureViewController.h"
#import "OrderAddressView.h"
#import "OrderGoodCell.h"
#import "OrderTwoCell.h"
#import "OrderBottomView.h"
#import "ReceiveAddressViewController.h"
#import "ReceiveAddressModel.h"
#import "WOrderSureModel.h"
//运费
#define FreightPrice @"10"

@interface OrderSureViewController ()<UITableViewDelegate,UITableViewDataSource,ReceiveAddressViewControllerDelegate,OrderBottomViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) OrderBottomView *orderBottomV;
/** 上个界面购物车数据 */
@property (strong,nonatomic) NSArray <WCartTableViewCell *>*dataArr;

@property (strong,nonatomic) ReceiveAddressModel *receiveData;

@property (strong,nonatomic) OrderAddressView *orderAddV;

/**确认订单model*/
@property (nonatomic,strong) WOrderSureModel *sureModel;



@end

@implementation OrderSureViewController
- (instancetype)initWithShopTitle:(NSString *)title image:(UIImage *)image selectedArr:(NSArray <WCartTableViewCell *>*)selectArr
{
    self = [super initWithShopTitle:title image:image];
    if (self) {
        
        _dataArr = selectArr;
        
    }
    return self;
}
-(void)getdata{
    _orderAddV = [[OrderAddressView alloc]init];
    _receiveData = [[ReceiveAddressModel alloc]init];
//    _dataArr = @[];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单信息";
    [self getdata];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    [self postDataWithArr:_dataArr whileComplete:^{
        [self initView];
    }];
}


#pragma mark *** 请求 ***
-(void)postDataWithArr:(NSArray<WCartTableViewCell *> *)array whileComplete:(void (^)())back{
    NSMutableArray *dicArr = [@[] mutableCopy];
    for (WCartTableViewCell *cell in array) {
        NSDictionary *dic = @{@"coid":cell.cellGoodsId,
                              @"coprid":cell.cellTypeId,
                              @"cnt":cell.cellNumber.countLb.text};
        [dicArr addObject:dic];
        
    }
    NSLog(@"这些商品--%@", dicArr);
    __weak typeof(self)wkSelf = self;
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"Sz":dicArr} requestID:GetUserId requestcode:kRequestCodegetconorder success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            
            wkSelf.sureModel = [WOrderSureModel modelWithJSON:jsonDic[@"data"]];
            
            NSLog(@"%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);

            if (wkSelf.sureModel.address) {
                WAddress *address = wkSelf.sureModel.address;
                ReceiveAddressModel *reData = [[ReceiveAddressModel alloc] init];
                reData.raID = [NSString stringWithFormat:@"%ld",(long)address.ReId];
                reData.realname = address.ReName;
                reData.mobile = address.ReMobile;
                reData.Province = address.ReProvince;
                reData.city = address.ReCity;
                reData.area = address.ReAddrdetail;
                reData.address = @"11";
                reData.defaultCode = address.ReIsdefault;
                reData.addressId = [NSString stringWithFormat:@"%ld",(long)address.ReAreaid];
                wkSelf.receiveData = reData;
            }
            
            
            back();
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
//结算完删除购物车数据
//-(void)postCompleteOrderDataWith{
//    [TCJPHTTPRequestManager POSTWithParameters:@{@"ShId":cartId} requestID:GetUserId requestcode:kRequestCodedelshopcar success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        if (succe) {
//            [wkSelf getCartData];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
//}

- (void)initView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, __kWidth, __kHeight-110-140)];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = LH_RGBCOLOR(230, 230, 230);
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _orderBottomV = [[OrderBottomView alloc]initWithFrame:CGRectMake(0, CGRectYH(_tableView), __kWidth, 140)];
    [self.view addSubview:_orderBottomV];
    
    NSArray *moneyArr = self.sureModel.shopmoney;
    NSInteger moneyYJ = 0; //原价
    NSInteger moneyDZ = 0; //打折
    NSInteger moneyYF = 0; //运费
    for (WShopmoney *obj in moneyArr) {
        moneyYJ+=obj.money;
        moneyDZ+=obj.prepri;
    }
    moneyYF = [self.sureModel.kd[0].AllValue integerValue];
    
    _orderBottomV.orderQuoteLb.text = [NSString stringWithFormat:@"¥%ld",(long)moneyYJ];;
    _orderBottomV.orderFreightLb.text = [NSString stringWithFormat:@"¥%ld",(long)moneyYF];
    _orderBottomV.concessionsLb.text = [NSString stringWithFormat:@"¥%ld",(long)moneyYJ-(long)moneyDZ];
    _orderBottomV.orderPayLb.text = [NSString stringWithFormat:@"应付:¥%ld",(long)moneyDZ];
    
    _orderBottomV.delegate = self;

}

#pragma mark *** 结算 ***
-(void)OrderBottonView:(OrderBottomView *)orderView didTapClearButton:(UIButton *)sender{
    if (IsNilString(_receiveData.address)) {
        [SXLoadingView showAlertHUD:@"无默认收货地址请添加地址" duration:0.5];
        return;
//        _orderAddV.addressLb.text = @"无默认收货地址请添加地址";//无地址数据
    }
    NSString *address = [NSString stringWithFormat:@"%@,%@,%@",_orderAddV.addressLb.text,_orderAddV.nameLb.text,_orderAddV.mobileLb.text];
    NSMutableArray *dicArr = [@[] mutableCopy];
   
    
    for (WCartTableViewCell *cell in _dataArr) {
        
        //打折价格
        NSString *Actprice = [cell.cellPrice.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        
        NSDictionary *dic = @{@"OrdeCoid":cell.cellGoodsId,
                              @"OrdeCoprid":cell.cellTypeId,
                              @"OrdeMoney":cell.cellDisPrice,
                              @"OrdeCount":cell.cellNumber.countLb.text,
                              @"OrdeActpri":Actprice,
                              @"OrdePrepri":[NSString stringWithFormat:@"%d",[cell.cellDisPrice intValue]-[cell.cellPrice.text intValue]],
                              @"OrdeCoprname":cell.cellType.text};
        
        [dicArr addObject:dic];
        
    }
    NSLog(@"这些商品--%@", dicArr);
    
    WK(wkself);
    [TCJPHTTPRequestManager POSTWithParameters:@{@"ShorOrdnum":@"",
                                                 @"ShorMeid":GetUserId,
                                                 @"ShorFreight":FreightPrice,
                                                 @"ShorMoney":[_orderBottomV.orderPayLb.text stringByReplacingOccurrencesOfString:@"应付:¥" withString:@""],
                                                 @"ShorPaytype":@"OFFLINE",
                                                 @"ShorAddress":address,
                                                 @"ShorType":@"PTSC",
                                                 @"ShorInvoice":@"发票",
                                                 @"Sz":dicArr} requestID:GetUserId requestcode:kRequestCodecreateshoporder success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                     if (succe) {
                                                         NSLog(@"????----%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);
                                                         [SXLoadingView showAlertHUD:@"结算成功" duration:0.5];
                                                         [wkself.navigationController popViewControllerAnimated:YES];
                                                     }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count+5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *titleArr = @[@"配送方式",@"支付方式",@"发票信息",@"优惠信息"];
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        [cell.contentView addSubview:_orderAddV];
        if (IsNilString(_receiveData.address)) {
            
          _orderAddV.addressLb.text = @"无默认收货地址请添加地址";//无地址数据
            
        }else{
        _orderAddV.nameLb.text = _receiveData.realname;
        _orderAddV.mobileLb.text = _receiveData.mobile;
        _orderAddV.addressLb.text = [NSString stringWithFormat:@"%@%@%@%@",_receiveData.Province,_receiveData.city,_receiveData.area,_receiveData.address];
        }
        _orderAddV.defaultLb.hidden = YES;//加默认判断
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (indexPath.row>0&&indexPath.row<=_dataArr.count){
        OrderGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderGoodCell"];
        if (!cell) {
            cell = [[OrderGoodCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderGoodCell"];
        }
        WCartTableViewCell *data = self.dataArr[indexPath.row-1];
        cell.goodIV.image = data.cellImage.image;
        cell.goodNameLb.text = data.cellName.text;
        cell.goodMoneyLb.text = data.cellPrice.text;
        cell.goodCountLb.text = [NSString stringWithFormat:@"x %@",data.cellNumber.countLb.text];
        return cell;
    }else if (indexPath.row>_dataArr.count&&indexPath.row<=_dataArr.count+2){
         UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = titleArr[indexPath.row-_dataArr.count-1];
        cell.textLabel.font = MFont(15);
        cell.detailTextLabel.font =MFont(15);
        cell.detailTextLabel.textColor = [UIColor blackColor];
        if (indexPath.row-_dataArr.count-1) {
         cell.detailTextLabel.text = @"顺丰快递";
        }else{
          cell.detailTextLabel.text = @"在线支付";
        }
        return cell;
    }else{
        OrderTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTwoCell"];
        if (!cell) {
            cell = [[OrderTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderTwoCell"];
        }
        cell.titleLb.text = titleArr[indexPath.row-_dataArr.count-1];
        if (indexPath.row-_dataArr.count-3) {
          cell.detailOneLb.text = @"抵用券-无";
          cell.detailTwoLb.text = @"优惠券-无";
        }else{
        cell.detailOneLb.textAlignment = NSTextAlignmentLeft;
         cell.detailTwoLb.textAlignment = NSTextAlignmentLeft;
         cell.detailOneLb.text = @"纸质发票—个人";
         cell.detailTwoLb.text = @"费图书商品—不开发票";
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        return 95;
    }else if (indexPath.row>0&&indexPath.row<=_dataArr.count){
        return __kWidth*3/8*17/27+20;
    }else{
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ReceiveAddressViewController *vc = [[ReceiveAddressViewController alloc]initWithShopTitle:@"收货地址" image:MImage(@"chec")];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -ReceiveAddressViewControllerDelegate
-(void)didSelectAddress:(ReceiveAddressModel *)sender{
    _receiveData =sender;
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
