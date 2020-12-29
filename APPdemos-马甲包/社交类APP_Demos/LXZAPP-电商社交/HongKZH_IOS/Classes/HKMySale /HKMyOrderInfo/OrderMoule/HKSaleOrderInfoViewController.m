//
//  HKSaleOrderInfoViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSaleOrderInfoViewController.h"
#import "HKOrderFormViewModel.h"
#import "HKOrderFromInfoRespone.h"
#import "HKOrderStaueTableViewCell.h"
#import "HK_MyOrderCell+HKMyOrder.h"
#import "HK_orderInfoCell+HKMySale.h"
#import "HKOrderNameTableViewCell.h"
#import "HKOrderNameTableViewCell.h"
#import "HKOrderAddressTableViewCell.h"
#import "HKFreightTableViewCell.h"
#import "HKContactTheBuyerTableViewCell.h"
#import "HKMyOrderFormStaueTabView.h"
#import "HKDeliverGoodsViewController.h"
#import "HKModifyAddressViewController.h"
#import "HKRevisePriceViewController.h"
#import "HKRevisePiceParameter.h"
#import "HKCloseOrderViewController.h"
#import "HKExpresListRespone.h"
#import "HKLogisticsViewController.h"
#import "HKOrderAfterStaueTableViewCell.h"
#import "HKCloseOrderTableViewCell.h"
#import "HKOrderAfterRefundsTableViewCell.h"
#import "HK_CladlyChattesView.h"
@interface HKSaleOrderInfoViewController ()<UITableViewDelegate,UITableViewDataSource,HKMyOrderFormStaueTabViewDelegate,HKOrderAddressTableViewCellDelegate,HKRevisePriceViewControllerDelegate,HKCloseOrderViewControllerDelegate,HKDeliverGoodsViewControllerDelegate,HKContactTheBuyerTableViewCellDeleagte>
@property (nonatomic, strong)HKOrderFromInfoRespone *respone;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKMyOrderFormStaueTabView *nextView;
@end

@implementation HKSaleOrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
}
-(void)loadData{
    [HKOrderFormViewModel orderInfo:@{@"loginUid":HKUSERLOGINID,@"orderNumber":self.orderNumber} success:^(HKOrderFromInfoRespone *responde) {
        if (responde.code.length>0&&responde.code.intValue == 0) {
            self.respone = responde;
            self.nextView.statue = self.respone.data.state.intValue;
            [self  staueReloadData];
        }
    }];
}
-(void)setUI{
    self.title = @"订单详情";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nextView];
    [self.nextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.nextView.mas_top);
    }];
}
-(void)contactTheBuyer{
    HK_CladlyChattesView *chat = [[HK_CladlyChattesView alloc] init];
    
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = self.respone.data.address.uid;
    
    //设置聊天会话界面要显示的标题
    chat.title = self.respone.data.name;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}
-(void)nextStepPay{
    HKDeliverGoodsViewController*vc = [[HKDeliverGoodsViewController alloc]init];
    vc.model = self.respone.data;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)noticeVcRefreshWithType:(OrderFormStatue)statue model:(NSObject *)model{
    switch (statue) {
        
        case OrderFormStatue_cnsignment:{
            HKExpresModel*expresM = (HKExpresModel*)model;
            self.respone.data.state = [NSString stringWithFormat:@"%d",statue];
            NSDate *date = [NSDate date];
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init]; fmt.dateFormat = @"yyyy.MM.dd HH:mm";
            NSString *string = [fmt stringFromDate:date];
            self.respone.data.deliverTime = string;
            self.respone.data.courierNumber = expresM.expresNum;
            self.respone.data.courier = expresM.name;
            [self staueReloadData];
        }
            break;
            
        default:
            break;
    }
}
-(void)nextStepReviserice{
    //修改价格
    HKRevisePriceViewController*vc = [[HKRevisePriceViewController alloc]init];
    vc.model = self.respone.data;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)toVcLookLogistics{
    HKLogisticsViewController*vc = [[HKLogisticsViewController alloc]init];
    vc.model = self.respone.data;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)sellerupdateorderpriceWithModel:(HKRevisePiceParameter *)model{
    self.respone.data.productIntegral = model.productintegral.integerValue;
    [self staueReloadData];
}
-(void)lastStepClose{
    //关闭交易
    HKCloseOrderViewController*vc = [[HKCloseOrderViewController alloc]init];
    vc.delegate = self;
     self.navigationController.definesPresentationContext = YES;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
-(void)modifyTheAddress{
    HKModifyAddressViewController*vc = [[HKModifyAddressViewController alloc]init];
    vc.model = self.respone.data;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)closeWithStr:(NSString *)str{
    [HKOrderFormViewModel sellerupdatecloseorder:@{@"loginUid":HKUSERLOGINID,@"orderNumber":self.respone.data.orderNumber,@"reason":str} success:^(HKBaseResponeModel *responde) {
        
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerNib:[UINib nibWithNibName:@"HK_MyOrderCell" bundle:nil] forCellReuseIdentifier:@"goodInfo"];
        [_tableView registerNib:[UINib nibWithNibName:@"HK_orderInfoCell" bundle:nil] forCellReuseIdentifier:@"orderInfo"];
    }
    return _tableView;
}
-(void)staueReloadData{
    OrderFormStatue staue = self.respone.data.state.intValue;
    if (staue == OrderFormStatue_cnsignment||staue  == OrderFormStatue_cnsignment||staue == OrderFormStatue_finish) {
        [self.nextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(50);
        }];
        [self.view layoutIfNeeded];
    }
    [self.tableView reloadData];
}
#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if (self.respone.data.afterList.count>0) {
            return 2;
        }
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.respone.data.state.intValue == OrderFormStatue_close) {
            HKCloseOrderTableViewCell*cell = [HKCloseOrderTableViewCell closeOrderTableViewCellWithTableView:tableView];
            return cell;
        }else if (self.respone.data.afterState.intValue == AfterSaleViewStatue_finish||self.respone.data.afterState.intValue == AfterSaleViewStatue_ReturnFinish){
            HKOrderAfterRefundsTableViewCell *cell = [HKOrderAfterRefundsTableViewCell orderAfterRefundsTableViewCellWithTableView:tableView];
            return cell;
        } else{
        HKOrderStaueTableViewCell*cell = [HKOrderStaueTableViewCell orderStaueTableViewCellWithTableView:tableView];
        cell.staue = (OrderFormStatue)[self.respone.data.state intValue];
        return cell;
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            HKOrderAddressTableViewCell *cell = [HKOrderAddressTableViewCell orderAddressTableViewCellWithTableView:tableView];
            if (self.respone) {
                cell.model = self.respone.data;
            }
            cell.delegate = self;
            return cell;
        }else{
            HKOrderAfterStaueTableViewCell*cell = [HKOrderAfterStaueTableViewCell orderAfterStaueTableViewCellWithTableView:tableView];
            cell.orderInfoModel = self.respone;
            return cell;
        }
       
    }else if (indexPath.section == 2){
        HKOrderNameTableViewCell*cell = [HKOrderNameTableViewCell orderNameTableViewCellWithTableView:tableView];
        if (self.respone) {
            cell.model = self.respone.data;
        }
        return cell;
    } else if (indexPath.section==3){
        HK_MyOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"goodInfo" forIndexPath:indexPath];
        if (self.respone) {
            cell.infoModel = self.respone.data;
        }
        
        return cell;
    }else if (indexPath.section == 4){
        HKFreightTableViewCell *cell = [HKFreightTableViewCell freightTableViewCellWithTableView:tableView];
        cell.freight = self.respone.data.freightIntegral;
        return cell;
    } else if (indexPath.section == 5){
        
          HK_orderInfoCell *cell =[tableView dequeueReusableCellWithIdentifier:@"orderInfo" forIndexPath:indexPath];
        if (self.respone) {
            cell.infoModel = self.respone.data;
        }
        return cell;
    }else if (indexPath.section == 6){
        HKContactTheBuyerTableViewCell*cell = [HKContactTheBuyerTableViewCell contactTheBuyerTableViewCellWithTableView:tableView];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat h = 0;
 
    switch (indexPath.section) {
        case 0:{
            h = 101;
        }
            break;
        case 1:{
            if (indexPath.row == 1) {
                return 75;
            }
          h =  self.respone.data.h;
           
        }
            break;
        case 2:{
            h = 50;
        }
            break;
        case 3:{
            h = 100;
        }
            break;
        case 4:{
            h = 50;
        }
            break;
        case 5:{
            h = 253;
        }
            break;
        case 6:{
            h = 70;
        }
            break;

        default:
            break;
    }
    return h;
}
-(HKMyOrderFormStaueTabView *)nextView{
    if (!_nextView) {
        _nextView = [[HKMyOrderFormStaueTabView alloc]init];
        _nextView.delegate = self;
    }
    return _nextView;
}
@end
