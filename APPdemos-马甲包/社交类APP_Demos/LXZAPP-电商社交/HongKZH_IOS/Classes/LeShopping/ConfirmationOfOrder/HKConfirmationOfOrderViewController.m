//
//  HKConfirmationOfOrderViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKConfirmationOfOrderViewController.h"
#import "getCartList.h"
#import "HKUpdataFromDataModel.h"
#import "HKConfirmationOfOrderViewModel.h"
#import "HKConfirmationOfOrderRespone.h"
#import "HKLeBuyShoppingCartTableViewCell.h"
#import "HKConfirmationOfOrderData.h"
#import "HKLeBuyShoppingCartTableViewCell.h"
#import "HKLeBuyShoppingCartSectionView.h"
#import "HKAddressTableViewCell.h"
#import "HKPlaceOrder.h"
#import "HK_RechargeController.h"
#import "HK_orderDetailVc.h"
#import "Hk_MyOrderDataModel.h"
#import "HK_AddressInfoView.h"
#import "HKMyGoodsTranslateViewController.h"
#import "UIAlertView+Blocks.h"
#import "HKGameNavView.h"
#import "HKSettlementReceptionViewController.h"
//#import "UnityAppController+HKGame.h"
@interface HKConfirmationOfOrderViewController ()<UITableViewDelegate,UITableViewDataSource,HKPlaceOrderDelegate,HKAddressTableViewCellDelegate,HKLeBuyShoppingCartTableViewCellDelegate,HKMyGoodsTranslateViewControllerDelegate,HK_AddressInfoViewDeleagte,HKGameNavViewDelegate>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)HKConfirmationOfOrderRespone *respone;
@property (nonatomic, strong)HKAddressTableViewCell *addressCell;
@property (nonatomic, strong)UIView *footView;
@property (nonatomic, strong)HKPlaceOrder *payTool;

@property(nonatomic, assign) double totalPrice;

@property (nonatomic, strong)HKGameNavView *gameNav;
@end

@implementation HKConfirmationOfOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)backVc{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"您确定离开吗" cancelButtonItem:[RIButtonItem itemWithLabel:@"确定离开" action:^{
//        [GetAppController() setupUnity];
    }] otherButtonItems:[RIButtonItem itemWithLabel:@"我在想想" action:^{
        
    }] , nil];
    [alertView show];
}
-(void)backItemClick{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"您确定离开吗" cancelButtonItem:[RIButtonItem itemWithLabel:@"确定离开" action:^{
        [self.navigationController popViewControllerAnimated:YES];
    }] otherButtonItems:[RIButtonItem itemWithLabel:@"我在想想" action:^{
        
    }] , nil];
    [alertView show];
}
-(void)loadData{
    [HKConfirmationOfOrderViewModel getPreorderWithCartIdArray:self.cartIdArray dict:@{@"loginUid":HKUSERLOGINID,@"integral":@"0"} success:^(HKConfirmationOfOrderRespone *responde) {
        
        if (responde.responeSuc) {
            self.respone = responde;
        }else {
            NSString *mes =responde.msg;
            if (mes.length) {
                [EasyShowTextView showText:mes];
            }else {
                [EasyShowTextView showText:@"操作失败"];
            }
            
        }
    }];
}
-(void)setUI{
    self.title = @"确认下单";
    self.gameNav.title = @"确认下单";
    self.view.backgroundColor = [UIColor colorFromHexString:@"F5F5F5"];
    [self.view addSubview:self.gameNav];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.payTool];
    [self.gameNav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.payTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_offset(50);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gameNav.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.payTool.mas_top);
    }];
}
-(void)selectCoinWithIsCoin:(BOOL)isCoin getCartListDataProducts:(getCartListDataProducts *)model{
    model.isSelectCoin = isCoin;
}
-(void)selected:(NSString *)couponId getCartListDataProducts:(getCartListDataProducts *)product{
    product.couponId = couponId;
    [self.tableView reloadData];
}
-(void)changeBlock:(addressDataModel *)model{
    HKAddressModel*addM = [HKAddressModel mj_objectWithKeyValues:[model mj_keyValues]];
    self.respone.data.address = addM;
    self.addressCell.address = addM;
    [self.tableView reloadData];
}
-(void)gotEditAddressWithModel:(HKAddressModel *)address{
    HK_AddressInfoView*addVc = [[HK_AddressInfoView alloc]init];
    addVc.delegate = self;
    [self.navigationController pushViewController:addVc animated:YES];
}
-(void)placeOrder{
    for (getCartListData*cartModel in self.respone.data.list) {
        for (getCartListDataProducts*product in cartModel.products) {
            if (product.isSelectCoin||product.couponId.length>0) {
                NSString*string = [NSString stringWithFormat:@"%@-%@-%@-%d",product.skuId,product.productId,product.couponId.length>0?product.couponId:@"",product.isSelectCoin];
                HKUpdataFromDataModel*fromData = [[HKUpdataFromDataModel alloc]init];
                fromData.name = @"skuProductCouponIdIsIntegral";
                fromData.vaule = string;
                [self.cartIdArray addObject:fromData];
            }
        }
    }

    if (!self.respone.data.address.addressId.length) {
        [EasyShowTextView showText:@"请先选择收货地址"];
        return;
    }

    HKSettlementReceptionViewController*vc = [[HKSettlementReceptionViewController alloc]init];
    vc.isFromGame = self.isFromGame;
    [vc loadDataCartArray:self.cartIdArray addressId:self.respone.data.address.addressId];
    [self.navigationController pushViewController:vc animated:YES];
    

}
-(void)gotoRecharge{
    HK_RechargeController*vc = [[HK_RechargeController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableHeaderView = self.addressCell;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}
-(void)selectCartListDataProducts:(getCartListDataProducts*)model isSelect:(BOOL)isSelect indexPath:(NSIndexPath*)indexPath{
    
}
-(void)numChange:(NSInteger)change products:(getCartListDataProducts*)model{
        self.payTool.numAll = self.payTool.numAll+change;
   
}
#pragma tableView--delegate
#pragma tableView
-(void)setRespone:(HKConfirmationOfOrderRespone *)respone{
    _respone = respone;
    self.addressCell.address = respone.data.address;
    [self.tableView reloadData];
    self.payTool.numAll = respone.data.productIntegral;
}
-(void)translateList:(getCartListDataProducts *)model{
    [HKMyGoodsTranslateViewController showMyGoodsTranslateViewControllerWithSuperVc:self productId:model];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.respone.data.list.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.respone.data.list[section] products] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKLeBuyShoppingCartTableViewCell*cell = [HKLeBuyShoppingCartTableViewCell baseCellWithTableView:tableView];
    cell.orderData = self.respone.data;
    cell.model = [self.respone.data.list[indexPath.section] products][indexPath.row];
    cell.indexPath = indexPath;
    cell.isHideLeft = YES;
    cell.delegate = self;
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HKLeBuyShoppingCartSectionView*view = [[HKLeBuyShoppingCartSectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    view.model = self.respone.data.list[section];
    view.section = section;
    view.isHideLine = YES;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

-(void)setCartArray:(NSArray *)cartArray{
    _cartArray = cartArray;
    NSMutableArray*cartIdArray = [NSMutableArray array];
    for (getCartListData*models in cartArray) {
        for (getCartListDataProducts*produt in models.products) {
           HKUpdataFromDataModel*from = [[HKUpdataFromDataModel alloc]init];
            from.name = @"cartId";
            from.vaule = produt.cartId;
            [cartIdArray addObject:from];
            
        }
        }
    self.cartIdArray = cartIdArray;
}
-(HKAddressTableViewCell *)addressCell{
    if (!_addressCell) {
        _addressCell = [[NSBundle mainBundle]loadNibNamed:@"HKAddressTableViewCell" owner:self options:nil].lastObject;
        _addressCell.frame = CGRectMake(0, 0, kScreenWidth, 85);
        _addressCell.isRight = YES;
        _addressCell.delegate = self;
    }
    return _addressCell;
}
-(HKPlaceOrder *)payTool{
    if (!_payTool) {
        _payTool = [[HKPlaceOrder alloc]init];
        _payTool.delegate = self;
    }
    return _payTool;
}
-(HKGameNavView *)gameNav{
    if (!_gameNav) {
        _gameNav = [[HKGameNavView alloc]init];
        _gameNav.delegate = self;
    }
    return _gameNav;
}
-(void)setType:(int)type{
    _type = type;
    if (type == 0) {
        self.isFromGame = NO;
        [self.gameNav mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        self.gameNav.hidden  = YES;
        [self.view layoutSubviews];
    }else{
        self.isFromGame = YES;
        [self.gameNav mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(64);
        }];
        self.gameNav.hidden  = NO;
        [self.view layoutSubviews];
    }
}
@end
