//
//  MyOrdersViewController.m
//  ListV
//
//  Created by imac on 16/8/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "OrderStatusView.h"
#import "ShopOrdersCell.h"
#import "ShopGoodModel.h"
#import "WBookingModel.h"
#import "GoodEvaluateViewController.h"
@interface MyOrdersViewController ()<OrderStatusViewDelegate,UITableViewDelegate,UITableViewDataSource,ShopOrdersCellDelegate>
{
    NSString *_currentSelectedTitle;//当前选择的状态栏title
}
/**
 *  订单状态
 */
@property (strong,nonatomic) OrderStatusView *orderStatusV;

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *dataArr;

/**订单Arr*/
@property (nonatomic,strong) WBookingModel *bookingModel;


@end

@implementation MyOrdersViewController

- (void)getDataWithTitle:(NSString *)title{
    NSString *statuTitle = @"全部";
    if ([title isEqualToString:@"待收货"]) {
        statuTitle = @"已发货";
    }else if ([title isEqualToString:@"待评价"]){
        statuTitle = @"已收货";
    }else if ([title isEqualToString:@"待付款"]){
        statuTitle = @"待付款";
    }

    _dataArr = [NSMutableArray array];

    for (int idx = 0; idx<self.bookingModel.datalist.count; idx++) {
        WbOrder *bookOrder = self.bookingModel.datalist[idx].order;
       NSArray <WbDetail *>*detailArr = self.bookingModel.datalist[idx].detail;
        
        ShopGoodModel *order = [[ShopGoodModel alloc] init];
        order.date = [bookOrder.ShorCreatetime substringToIndex:10];
        order.status = bookOrder.ShorState;
        order.totalCount = @"0";
        order.totalMoney = [NSString stringWithFormat:@"%ld",(long)bookOrder.ShorMoney];
        order.freight = [NSString stringWithFormat:@"%ld",(long)bookOrder.ShorFreight];
        order.goodArr = [NSMutableArray array];

        for ( int i=0; i<detailArr.count; i++) {
            GoodCarModel *good = [[GoodCarModel alloc]init];
            WbDetail *goodDetail = detailArr[i];
            good.goodName = goodDetail.OrdeConame;
            good.orderNo = bookOrder.ShorOrdnum;
            good.goodMoney = [NSString stringWithFormat:@"%ld",(long)goodDetail.OrdeActpri];
            good.goodQuote = [NSString stringWithFormat:@"%ld",(long)goodDetail.OrdeMoney];
            good.goodcount = [NSString stringWithFormat:@"%ld",(long)goodDetail.OrdeCount];
            good.goodImg = goodDetail.OrdeCocover;
            good.goodId = [NSString stringWithFormat:@"%ld",(long)bookOrder.ShorId];

            order.totalCount = [NSString stringWithFormat:@"%ld",(long)[good.goodcount integerValue]+(long)[order.totalCount integerValue]];
            [order.goodArr addObject:good];
            
        }
        
        if ([statuTitle isEqualToString:@"全部"]) {
            [_dataArr addObject:order];
        }else{
            if ([order.status isEqualToString:statuTitle]) {
                [_dataArr addObject:order];
            }
        }
        
    }
    [self.tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    _currentSelectedTitle = @"全部";
    [self initView];
    self.view.backgroundColor = LH_RGBCOLOR(230, 230, 230);
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getAllbookingInfomation];

}
#pragma mark *** 订单网络请求 ***
-(void)getAllbookingInfomation{
    
    __weak typeof(self)wkSelf = self;
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"pagenum":@"1",@"pagesize":@"20"} requestID:GetUserId requestcode:kRequestCodegetshoporderlist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            
            NSLog(@"订单--%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);
            NSLog(@"订单--%@", jsonDic[@"data"]);
            
            wkSelf.bookingModel = [WBookingModel modelWithJSON:jsonDic[@"data"]];

            [wkSelf getDataWithTitle:_currentSelectedTitle];

            
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)editBookingToStatus:(NSString *)status withBookingNumber:(NSString *)orderNumber{
    NSDictionary *dic = @{};
    NSString *title = @"";
    if ([status isEqualToString:@"CANCEL"]) {
        dic = @{@"ShorId":orderNumber,
                @"ShorState":status,
                @"ShorIsdel":@""};
        title = @"已取消订单";
    }else if ([status isEqualToString:@"1"]){
        dic = @{@"ShorId":orderNumber,
                @"ShorIsdel":status,
                @"ShorState":@""};
        title = @"已删除订单";
    }
    __weak typeof(self)wkSelf = self;
    [TCJPHTTPRequestManager POSTWithParameters:dic requestID:GetUserId requestcode:kRequestCodechangeshoporder success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            
            NSLog(@"%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);
            
            [wkSelf getAllbookingInfomation];
            [SXLoadingView showAlertHUD:[NSString stringWithFormat:@"%@",title] duration:0.5];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)initView{
    NSArray *typeArr = @[@"全部",@"待付款",@"待收货",@"待评价"];
    _orderStatusV = [[OrderStatusView alloc]initWithFrame:CGRectMake(0, 64, __kWidth, 40)];
    [self.view addSubview:_orderStatusV];
    [_orderStatusV initTypeArr:typeArr];
    _orderStatusV.delegate = self;

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectYH(_orderStatusV), __kWidth, __kHeight-104-64)];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = LH_RGBCOLOR(230, 230, 230);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}

#pragma mark -UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ShopOrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopOrdersCell"];
    ShopOrdersCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[ShopOrdersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopOrdersCell"];
    }
    cell.delegate = self;
    ShopGoodModel *order = _dataArr[indexPath.row];
    cell.dateLb.text = order.date;
    cell.statusLb.text = order.status;
    cell.totalLb.text = [NSString stringWithFormat:@"共%@件",order.totalCount];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"应付金额:¥%@(含运费¥%@)",order.totalMoney,order.freight]];
    NSRange redrange = NSMakeRange(5, order.totalMoney.length+1);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redrange];
    [cell.allPayLb setAttributedText:noteStr];
    [cell initShopView:order];
  
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopGoodModel *order = _dataArr[indexPath.row];
    CGFloat height = __kWidth/4*order.goodArr.count+120;
    
    return height;
}
#pragma mark ==点击cell==
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopGoodModel *order = _dataArr[indexPath.row];
    for (GoodCarModel *good  in order.goodArr) {
        NSLog(@"%@\n%@\n%@",good.goodName,good.goodMoney,good.goodcount);
    }

}
- (void)orderAction:(NSString *)order action:(UIButton *)sender{
    
    NSLog(@"%@--%@",sender.titleLabel.text,order);
    NSString *status = @"";
    if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        status = @"CANCEL";
        [Tools showAlertViewcontrollerWithTarGet:self Message:@"确认取消订单吗？" complete:^(BOOL sure) {
            if (sure) {
                [self editBookingToStatus:status withBookingNumber:order];
                
            }
        }];
        
    }else if([sender.titleLabel.text isEqualToString:@"删除订单"]){
        status = @"1";
        [Tools showAlertViewcontrollerWithTarGet:self Message:@"确认删除订单吗？" complete:^(BOOL sure) {
            if (sure) {
                [self editBookingToStatus:status withBookingNumber:order];
                
            }
        }];
        
    }else{
        
    }
    
}
-(void)orderActionWithNumber:(NSString *)orderNumber action:(UIButton *)sender{
    if([sender.titleLabel.text isEqualToString:@"评价"]){
        GoodEvaluateViewController *evaVc = [[GoodEvaluateViewController alloc] initWithShopTitle:@"评价" image:MImage(@"chec")];
        evaVc.orderNumber = orderNumber;
        [self.navigationController pushViewController:evaVc animated:YES];
    }
}
#pragma mark ==更换订单数据==
-(void)orderTypeChoose:(UIButton *)sender{
        [self getDataWithTitle:sender.titleLabel.text];
        _currentSelectedTitle = sender.titleLabel.text;
    NSLog(@"%@",sender.titleLabel.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
