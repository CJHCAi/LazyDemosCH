//
//  HK_baseSubOrderVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_baseSubOrderVc.h"
#import "HK_MyOrderCell.h"
#import "HKShareOrderCell.h"
#import "HK_BaseRequest.h"
#import "HK_orderTool.h"
//组头组尾视图
#import "HK_orderShopHeaderView.h"
#import "HK_orderShopFooterView.h"
#import "HK_footViewPayView.h"
#import "HK_orderDetailVc.h"
#import "CountDown.h"
#import "HKCollageShareView.h"
#import "HKShareBaseModel.h"
#import "HKCollageDetailVc.h"
@interface HK_baseSubOrderVc ()<UITableViewDelegate,UITableViewDataSource,footerViewDelegete,lastPayTimeBtnDelegete>
@property (nonatomic, strong)UITableView * listTableView;
@property (nonatomic, strong)NSMutableArray * dataSources;
@property (nonatomic, assign)int page;
@property (strong, nonatomic)  CountDown *countDown;
//支付倒计时数组
@property (nonatomic, strong)NSMutableArray * footPayViewArr;
@end

@implementation HK_baseSubOrderVc

-(NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources =[[NSMutableArray alloc] init];
    }
    return _dataSources;
}
//记录倒计时时间的数组
-(NSMutableArray *)footPayViewArr {
    if (!_footPayViewArr) {
        _footPayViewArr =[[NSMutableArray alloc] init];
    }
    return _footPayViewArr;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.page =1;
    //获取列表信息
    [self loadOrderListInfo];
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.listTableView];

    self.countDown = [[CountDown alloc] init];
    ///每秒回调一次
    [self.countDown countDownWithPER_SECBlock:^{
        DLog(@".....");
        [self updateTimeInVisibleCells];
    }];
}
//可见区域进行倒计时
-(void)updateTimeInVisibleCells{
    
    for (HK_footViewPayView * pay in self.footPayViewArr) {
        pay.timer--;
        DLog(@"currenmt==%f",pay.timer);
        NSTimeInterval timer = pay.timer;
        NSString * dates =[HK_orderTool getDataStringFromTimeCount:timer];
        
        [pay.payTimeBtn setTitle:dates forState:UIControlStateNormal];
        if ([pay.payTimeBtn.titleLabel.text isEqualToString:@"支付时间截止"]) {
            pay.payTimeBtn.enabled  =NO;
            
        }else {
            pay.payTimeBtn.enabled =YES;
        }
    }
}
-(void)loadOrderListInfo {
    
    if (_page>1) {
        [self.listTableView.mj_footer setHidden:NO];
        //不移除数据
    }else {
        [self.listTableView.mj_footer setHidden:YES];
    }
    NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
    [params setValue:HKUSERLOGINID forKey:@"loginUid"];
    [params setValue:@(self.page) forKey:@"pageNumber"];
    [params setValue:self.tradeString forKey:@"type"];
    [HK_BaseRequest buildPostRequest:get_userOrderList_mediaShop body:params success:^(id  _Nullable responseObject) {
        [self.listTableView.mj_header endRefreshing];
        
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
            NSString *mes =responseObject[@"msg"];
            if (mes.length) {
                [EasyShowTextView showText:mes];
            }
        }else {
            if (self.page==1) {
                if (self.dataSources.count) {
                    [self.dataSources removeAllObjects];
                }
                
                [self.listTableView.mj_footer setHidden:NO];
            }
            
            Hk_MyOrderDataModel * bigModel =[Hk_MyOrderDataModel mj_objectWithKeyValues:responseObject];
            if (bigModel.data.list.count) {
                [self.dataSources addObjectsFromArray:bigModel.data.list];
                [self.listTableView.mj_footer endRefreshing];
                [self.listTableView reloadData];
            }
            else
            {
                 [self.listTableView.mj_footer setHidden:YES];
                if (self.page!=1) {
                          [EasyShowTextView showText:@"全部加载完毕"];
                }
            }
        }
    } failure:^(NSError * _Nullable error) {
        [self.listTableView.mj_header endRefreshing];
        [self.listTableView.mj_footer endRefreshing];
        [EasyShowTextView showText:@"无网络,稍后重试"];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.dataSources.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //获取每一组的 内容状态
    HK_shopOrderList * listOrder =[self.dataSources objectAtIndex:section];
    if (listOrder.state.intValue==-1) {
        return  0;
    }
    return  48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
    return 50;
}
#pragma mark 支付倒计时 支付代理事件
-(void)payOrderClick:(HK_shopOrderList *)model {
    
    Hk_subOrderList * sub  =model.subList.firstObject;
    //确认收货 取消订单 回调刷新界面
    
    HK_orderDetailVc * detailVc =[[HK_orderDetailVc alloc] init];

    detailVc.listModel  = sub;
    
    detailVc.comfirmBlock = ^{
        [self loadNewData];
    };
    detailVc.cancelBlock = ^{
        [self loadNewData];
    };
    [self.navigationController pushViewController:detailVc animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
     
    //获取每一组的 内容状态
      HK_shopOrderList * listOrder =[self.dataSources objectAtIndex:section];
    
   //等待支付是一类 其他的是一类
    if ([listOrder.state isEqualToString:@"1"]) {
        static NSString *viewIdentfier = @"headView";
        HK_footViewPayView *footPayView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
        if (!footPayView) {
              footPayView = [[HK_footViewPayView alloc] initWithReuseIdentifier:viewIdentfier];
            footPayView.listOrder = listOrder;
            
            footPayView.delegete = self;
            [self.footPayViewArr addObject:footPayView];
//        HK_footViewPayView *footPayView  = [[HK_footViewPayView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,48)];
//            footPayView.listOrder = listOrder;
//            footPayView.delegete = self;
//        if (!footPayView.section) {
//            footPayView.section =section+1;
//            [self.footPayViewArr addObject:footPayView];
//        }
        }
           return footPayView;
    }
    
    HK_orderShopFooterView *orderView =[[HK_orderShopFooterView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,48)];
    orderView.model = listOrder;
    orderView.section =section;
    orderView.delegete = self;
    OrderFormStatue status =listOrder.state.intValue;
    switch (status) {
        case OrderFormStatue_payed:
            [orderView.rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            orderView.leftBtn.hidden =YES;
            break;
        case OrderFormStatue_finish:
        case OrderFormStatue_cancel:
            [orderView.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            orderView.leftBtn.hidden =YES;
            break;
        case OrderFormStatue_cnsignment:
        {
            orderView.leftBtn.hidden =NO;
            [orderView.rightBtn setTitle:@"收货" forState:UIControlStateNormal];
            [orderView.leftBtn setTitle:@"去转售" forState:UIControlStateNormal];
        }
            break;
        case OrderFormStatue_verify:
              [orderView.rightBtn setTitle:@"确认订单" forState:UIControlStateNormal];
            break;
        case OrderFormStatue_close:
             [orderView.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            break;
        default:
            return nil;
            break;
    }
    return orderView;
}
#pragma mark footer点击事件 (删除订单.查看物流.) //收货 转售
-(void)clickFooterBtnClick:(HK_shopOrderList *)model withSenderTag:(NSInteger)tag  sections:(NSInteger)section{
    Hk_subOrderList * list = [model.subList firstObject];
//   //点击footer之前跳转到详情...
#pragma mark 删除订单..
    if (list.state.intValue==OrderFormStatue_close) {
        [HK_orderTool deleteOrdersWithOrderNumber:list.orderNumber handleBlock:^{
            [self loadNewData];
        } failError:^(NSString *msg) {
            if (msg.length) {
                 [EasyShowTextView showText:msg];
            }
        }];
        return;
    }
    HK_orderDetailVc * detailVc =[[HK_orderDetailVc alloc] init];
    detailVc.listModel  = list;
    //确认收货 取消订单 回调刷新界面
    detailVc.comfirmBlock = ^{
        [self loadNewData];
    };
    detailVc.cancelBlock = ^{
        [self loadNewData];
    };
    [self.navigationController pushViewController:detailVc animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //获取每一组的 内容状态
    HK_shopOrderList * listOrder =[self.dataSources objectAtIndex:section];
    HK_orderShopHeaderView * headerView  =[[HK_orderShopHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,50)];
    [headerView configueListOrderHeaderWithModel:listOrder];
    headerView.block = ^(NSString *shopId) {
        
        [AppUtils pushShopInfoWithShopId:shopId andCurrentVc:self];
    };
    return  headerView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    HK_shopOrderList * listOrder =[self.dataSources objectAtIndex:section];
    return listOrder.subList.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_shopOrderList * listOrder =[self.dataSources objectAtIndex:indexPath.section];
     Hk_subOrderList *listModel =[listOrder.subList objectAtIndex:indexPath.row];
    if (listOrder.state.intValue==-1) {
        HKShareOrderCell * cell =[tableView dequeueReusableCellWithIdentifier:@"share" forIndexPath:indexPath];
        cell.list = listModel;
        cell.block = ^(Hk_subOrderList *list, NSInteger index) {
            HKCollageDetailVc * collageVc =[[HKCollageDetailVc alloc] init];
            collageVc.orderId = listModel.orderNumber;
            collageVc.isFromOrder = YES;
            collageVc.block = ^{
                [self loadNewData];
            };
            [self.navigationController pushViewController:collageVc animated:YES];
        };
        return cell;
    }
    HK_MyOrderCell * orderCell =[tableView dequeueReusableCellWithIdentifier:@"myOrderCell" forIndexPath:indexPath];
    orderCell.model = listModel;
    return orderCell;
}

#pragma mark 待分享 取消订单
-(void)cancelOrderWithOrderNumber:(NSString *)orderNumber withIndexPath:(NSIndexPath *)indexPath {
    [Toast loading];
    [HK_orderTool cancelUserOderWithOrderNumber:orderNumber handleBlock:^{
        [Toast loaded];
        [self loadNewData];
    } failError:^(NSString *msg) {
        
         [Toast loaded];
        [EasyShowTextView showText:msg];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tradeString isEqualToString:@"100"]) {
       return  180;
    }
       return  102;
}
-(UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-45-46) style:UITableViewStyleGrouped];
        _listTableView.delegate  =self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView =[[UIView alloc] init];
        _listTableView.showsVerticalScrollIndicator =NO;
        _listTableView.showsHorizontalScrollIndicator =NO;
        _listTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _listTableView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [_listTableView registerNib:[UINib nibWithNibName:@"HK_MyOrderCell" bundle:nil] forCellReuseIdentifier:@"myOrderCell"];
        [_listTableView registerClass:[HKShareOrderCell class] forCellReuseIdentifier:@"share"];
                //    //上拉加载
                _listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
                [_listTableView.mj_footer setHidden: YES];
        
    }
    return _listTableView;
}
#pragma mark 跳转详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_shopOrderList * listOrder =[self.dataSources objectAtIndex:indexPath.section];
    Hk_subOrderList *listModel =[listOrder.subList objectAtIndex:indexPath.row];
    
    if (listOrder.state.intValue == -1) {
        //拼团详情....
        HKCollageDetailVc * collageVc =[[HKCollageDetailVc alloc] init];
        collageVc.orderId = listModel.orderNumber;
        collageVc.isFromOrder = YES;
        collageVc.block = ^{
            [self loadNewData];
        };
        [self.navigationController pushViewController:collageVc animated:YES];
    }else {
        HK_orderDetailVc * detailVc =[[HK_orderDetailVc alloc] init];
        Hk_subOrderList * model = listOrder.subList[indexPath.row];
        detailVc.listModel  = model;
        //确认收货 取消订单 回调刷新界面
        detailVc.comfirmBlock = ^{
            [self loadNewData];
        };
        detailVc.cancelBlock = ^{
            [self loadNewData];
        };
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}
-(void)loadNewData {
    self.page =1;
    [self loadOrderListInfo];
}
-(void)loadMoreData {
    self.page ++;
    [self loadOrderListInfo];
    
}
@end
