//
//  HK_orderDetailVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_orderDetailVc.h"
#import "HK_orderShopFooterView.h"
#import "HK_BaseRequest.h"
#import "HK_orderAddressModel.h"
#import "HK_orderInfo.h"
#import "Hk_detailFooterView.h"
#import "HK_orderTool.h"
//收货管理
#import "HK_PaymentActionSheetTwo.h"
#import "HK_AddressInfoView.h"
#import "CountDown.h"
#import "HK_PaymentActionSheet.h"
@interface HK_orderDetailVc ()<UITableViewDelegate,UITableViewDataSource,footerViewDelegete,ContactFootViewDelegete,editUserAddressDelegete,StoreOrderCarigeDelegete,HK_AddressInfoViewDeleagte,HK_PaymentActionSheetTwoDelegate,HK_PaymentActionSheetDelegate>
@property (nonatomic, strong)UITableView * listTableView;
@property (nonatomic, strong)NSMutableArray * dataSources;
@property (nonatomic, strong)HK_orderShopFooterView *footViews;
@property (nonatomic, strong)HK_orderInfo * model;
@property (strong, nonatomic)CountDown *countDown;
@property (nonatomic, assign)NSTimeInterval timer;
@end

@implementation HK_orderDetailVc

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
-(void)initNav {
    self.title =@"订单详情";
    [self setShowCustomerLeftItem:YES];
}
-(UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-48-SafeAreaBottomHeight) style:UITableViewStyleGrouped];
        _listTableView.delegate  =self;
        _listTableView.dataSource = self;
        _listTableView.showsVerticalScrollIndicator =NO;
        _listTableView.showsHorizontalScrollIndicator =NO;
        _listTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _listTableView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
     //注册cell
    //addressCell
        [_listTableView registerClass:[HK_orderAddressCell class] forCellReuseIdentifier:@"address"];
    //topInfoCell
        [_listTableView registerNib:[UINib nibWithNibName:@"HK_InfoTopCell" bundle:nil] forCellReuseIdentifier:@"topInfo"];
    //展示商品信息
        [_listTableView registerNib:[UINib nibWithNibName:@"HK_MyOrderCell" bundle:nil] forCellReuseIdentifier:@"goodInfo"];
      //展示支付相关
        [_listTableView  registerNib:[UINib nibWithNibName:@"HK_orderInfoCell" bundle:nil] forCellReuseIdentifier:@"orderInfo"];

    }
    return _listTableView;
}
-(HK_orderShopFooterView *)footViews {
    if (!_footViews) {
        _footViews =[[HK_orderShopFooterView alloc] initWithFrame:CGRectMake(0,kScreenHeight-48-NavBarHeight-StatusBarHeight-SafeAreaBottomHeight,kScreenWidth,48)];
        _footViews.delegete = self;
    }
    return _footViews;
}
#pragma mark tableView 代理事件
//返回的组数 和订单的状态有关..
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [HK_orderTool sectionCountWithOrderStates:self.model.data.state];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
   
    return [HK_orderTool sectionFooterHightWithOrderStates:self.model.data.state andSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [HK_orderTool sectionHeaderHightWithOrderStates:self.model.data.state andSection:section];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * footView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
    footView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    return footView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
   return   [HK_orderTool sectionHeaderViewWithOrderStates:self.model andSection:section];
}
//每一组返回的items..个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //返回的组数和订单的状态有关系....不管多少组 倒数第二组是商品数量 其余都是1
    
  return  [HK_orderTool rowcountForSectionWithOrderState:self.model andSection:section];
}
//返回,每一组内容的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [HK_orderTool rowHightWithOrderState:self.model.data.state andSection:indexPath.section];
}
//cell 赋值
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //根据订单状态获取要展示的cell
    return [HK_orderTool configueTableView:tableView WithOrderStates:self.model andIndexPath:indexPath andEditDelegete:self];
}
- (void)viewDidLoad {
     [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
     [self initNav];
     [self.view addSubview:self.listTableView];
    [self.view addSubview:self.footViews];
    //获取订单详情
    [self getUSerShopAddress];
}
//底部toolBar 支付按钮做倒计时显示
-(void)updateTimeInVisibleCells{
    self.timer--;
    NSString * dates =[HK_orderTool getDataStringFromTimeCount:self.timer];
    [self.footViews.rightBtn setTitle:dates forState:UIControlStateNormal];
    if ([self.footViews.rightBtn.titleLabel.text isEqualToString:@"支付时间截止"]) {
        self.footViews.rightBtn.enabled  =NO;
        self.footViews.rightBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
    }else {
       self.footViews.rightBtn.enabled =YES;
    }
}
-(void)getUSerShopAddress {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:@"loginUid"];
    [params setValue:self.listModel.orderNumber forKey:@"orderNumber"];
   
    [HK_BaseRequest buildPostRequest:get_userOrderInfo body:params success:^(id  _Nullable responseObject) {
        
        HK_orderInfo * infoModel =[HK_orderInfo mj_objectWithKeyValues:responseObject];
        
        self.model =infoModel;
        
        if (infoModel.code) {
            [EasyShowTextView showText:infoModel.msg];
        }else {
              [self setFooterStatus];
            
             [self.listTableView reloadData];
            
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
//设置底部工具栏的状态
-(void)setFooterStatus {
    
    [self.footViews changeBarButtonStateWithStatus:self.model];
    
#pragma mark 如果是待支付状态开始一个倒计时的线程
    if ([self.model.data.state isEqualToString:@"1"]) {
        NSTimeInterval timer =[HK_orderTool AgetCountTimeWithString:self.model.data.limitTime andNowTime:self.model.data.currentTime];
        self.timer = timer;
        self.countDown = [[CountDown alloc] init];
        
        [self.countDown countDownWithPER_SECBlock:^{
            
            [self updateTimeInVisibleCells];
        }];
    }
    //尾视图
    Hk_detailFooterView *footD =[Hk_detailFooterView initWithFrame:CGRectMake(0,0,kScreenWidth,70) OrderStatus:self.model.data.state];
    self.listTableView.tableFooterView = footD;
    footD.delegete = self;
}
-(void)paymentCallback{
    [HK_orderTool payOrdersWithNumber:self.model.data.orderNumber andCurrentVc:self];
}
#pragma mark 在线客服 联系卖家
-(void)ClickFootBtnWithTag:(NSInteger)index {
    if (index==101) {
        
        [AppUtils PushChatControllerWithType:ConversationType_PRIVATE uid:self.model.data.mediaUserId name:self.model.data.name headImg:self.model.data.headImg andCurrentVc:self];
    }else {
        [EasyShowTextView showText:@"客服休息了"];
        
      //  [AppUtils PushChatControllerWithType:ConversationType_CUSTOMERSERVICE uid:nil name:nil headImg:nil andCurrentVc:self];
    }
}
-(void)rechargeCallback{
    HK_RechargeController * reVc =[[HK_RechargeController alloc] init];
    [self.navigationController pushViewController:reVc animated:YES];
}
#pragma mark 底部工具栏点击事件
-(void)clickFooterBtnClick:(HK_shopOrderList *)model withSenderTag:(NSInteger)tag sections:(NSInteger)section {
    // 待收货和 已暂存 状态可以申请退款
    if (self.model.data.state.intValue==OrderFormStatue_payed &&tag==100) {

        [HK_orderTool pushOrderReFundVc:self.model.data.orderNumber orderStatus:HK_orderReFund orderType:@"1" andCurrentVc:self];
        
    }else if (self.model.data.state.intValue ==OrderFormStatue_cnsignment  && tag==50){
         [HK_orderTool pushOrderReFundVc:self.model.data.orderNumber orderStatus:HK_orderReFund orderType:@"1" andCurrentVc:self];

    }else if (self.model.data.state.intValue ==OrderFormStatue_finish && tag==200){
        
          [HK_orderTool pushOrderReFundVc:self.model.data.orderNumber orderStatus:Hk_orderRefundAfter orderType:@"1" andCurrentVc:self];
     
       //删除订单
    }else if (self.model.data.state.intValue ==OrderFormStatue_finish && tag==100) {
        [HK_orderTool deleteOrdersWithOrderNumber:self.model.data.orderNumber handleBlock:^{
            
            [self.navigationController popViewControllerAnimated:YES];
        } failError:^(NSString *msg) {
              [EasyShowTextView showText:msg];
        }];
    }else if (self.model.data.state.intValue ==OrderFormStatue_cancel && tag==200) {
        [HK_orderTool deleteOrdersWithOrderNumber:self.model.data.orderNumber handleBlock:^{
            
            [self.navigationController popViewControllerAnimated:YES];
        } failError:^(NSString *msg) {
            [EasyShowTextView showText:msg];
        }];
    }
    else if (self.model.data.state.intValue ==OrderFormStatue_close && tag ==200) {
        [HK_orderTool deleteOrdersWithOrderNumber:self.model.data.orderNumber handleBlock:^{
            
            [self.navigationController popViewControllerAnimated:YES];
        } failError:^(NSString *msg) {
              [EasyShowTextView showText:msg];
        }];
    }
    else if (self.model.data.state.intValue ==OrderFormStatue_payed && tag==200){
      
        DLog(@".....查看物流--%@---%@",self.model.data.courier,self.model.data.courierNumber);
        //查看物流
        [HK_orderTool pushOrderLogisticsVc:self.model andCurrentVc:self];
        
        
    }else if (self.model.data.state.intValue == OrderFormStatue_cnsignment && tag==200){
       //确认收货
        [HK_orderTool confirmCollectGoodsWithOrderNumber:self.model.data.orderNumber handleBlock:^{
            [EasyShowTextView showText:@"确认收货"];
            
            [self performSelector:@selector(pop) withObject:nil afterDelay:1];
            
        } failError:^(NSString *msg) {
            
             [EasyShowTextView showText:msg];
        }];
    }else if (self.model.data.state.intValue == OrderFormStatue_waitPay && tag==200) {
        
     //支付-->要获取到用户最新的乐币数量...
      //1.获取用户乐币
       NSInteger userIntergal =[LoginUserData sharedInstance].integral;
    
        if (userIntergal>=self.model.data.integral) {
        
            HK_PaymentActionSheet *payment = [HK_PaymentActionSheet showInView:self.navigationController.view];
            [payment configueCellWithTotalCount:self.model.data.integral];
            payment.delegate = self;
        }else {
          //充值
            HK_PaymentActionSheetTwo *recharge = [HK_PaymentActionSheetTwo showInView:self.navigationController.view];
            [recharge configueCellWithTotalCount:self.model.data.integral];
            recharge.delegate = self;
            
        }
    }else if (self.model.data.state.intValue ==OrderFormStatue_waitPay &&tag==100){
        UIAlertController * alert =[UIAlertController  alertControllerWithTitle:@"您确认要取消该订单吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancle =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancle];
        UIAlertAction *define =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //取消订单
            [HK_orderTool cancelUserOderWithOrderNumber:self.model.data.orderNumber handleBlock:^{
                [EasyShowTextView showText:@"取消订单"];
                [self performSelector:@selector(pop) withObject:nil afterDelay:1];
            } failError:^(NSString *msg) {
                [EasyShowTextView showText:msg];
            }];
        }];
        [alert addAction:define];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}
-(void)pop {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    if (self.comfirmBlock) {
        self.comfirmBlock();
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark 待支付状态存储物箱  //购物车是否存储物
-(void)saveGoodsToLocal:(orderSubMitModel *)model {
    
}
#pragma mark 编辑收货地址
-(void)editGoodsAddress {
    
    [HK_orderTool pushEditAdressContorller:self withModel:self.model andTableView:self.listTableView];
}
-(void)changeBlock:(addressDataModel *)model{
    NSIndexPath * indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
    //给第一个cell.赋值..
    HK_orderAddressCell * cell =[self.listTableView cellForRowAtIndexPath:indexPath];
    cell.nameLabel.text = model.consignee;
    cell.phoneLabel.text =model.phone;
    cell.addressLabel.text = model.address;
    self.model.data.address.consignee = model.consignee;
    self.model.data.address.phone =model.phone;
    self.model.data.address.address =model.address;
}
@end
