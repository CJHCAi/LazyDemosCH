//
//  HK_searchOrderController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_searchOrderController.h"
#import "HK_MyOrderCell.h"
#import "HK_BaseRequest.h"
#import "HK_orderTool.h"
//组头组尾视图
#import "HK_orderShopHeaderView.h"
#import "HK_orderShopFooterView.h"
#import "HK_footViewPayView.h"
#import "HKSearchView.h"
#import "HK_orderDetailVc.h"
#import "CountDown.h"
@interface HK_searchOrderController ()<UITableViewDelegate,UITableViewDataSource,footerViewDelegete,lastPayTimeBtnDelegete,HKSearchViewDelegate>
@property (nonatomic, strong)UITableView * listTableView;
@property (nonatomic, strong)NSMutableArray * dataSources;
@property (nonatomic, assign)int page;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)HKSearchView *searchV;
@property (strong, nonatomic)  CountDown *countDown;
//支付倒计时数组
@property (nonatomic, strong)NSMutableArray * footPayViewArr;
@end

@implementation HK_searchOrderController

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
    self.searchV.resignResponder =YES;
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
//记录倒计时时间的数组
-(NSMutableArray *)footPayViewArr {
    if (!_footPayViewArr) {
        _footPayViewArr =[[NSMutableArray alloc] init];
    }
    return _footPayViewArr;
}
-(NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources =[[NSMutableArray alloc] init];
    }
    return _dataSources;
}
-(void)initNav {
    HKSearchView * search =[HKSearchView searchView];
    search.delegate = self;
    search.placeHoder =@"请输入商品名称";
    search.intrinsicContentSize =CGSizeMake(260,30);
    self.searchV = search;
    self.navigationItem.titleView = search;
    [self setShowCustomerLeftItem:YES];
    [AppUtils addBarButton:self title:@"取消" action:@selector(pushSearchVc) position:PositionTypeRight];
}
-(void)pushSearchVc {
    self.searchV.resignResponder =YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)textChange:(UITextField *)textFile {
//    if (!textFile.text.length) {
//        [EasyShowTextView showText:@"请输入搜索内容"];
//        return;
//    }
    self.content = textFile.text;
    self.page =1;
    [self loadOrderListInfo];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initNav];
    [self.view addSubview:self.listTableView];
    self.page = 1;
    self.countDown = [[CountDown alloc] init];
    ///每秒回调一次
    [self.countDown countDownWithPER_SECBlock:^{
        
        [self updateTimeInVisibleCells];
    }];
}
//可见区域进行倒计时
-(void)updateTimeInVisibleCells{
    for (HK_footViewPayView * pay in self.footPayViewArr) {
        pay.timer--;
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
    if (!self.content.length) {
        [EasyShowTextView showText:@"请选输入搜索内容"];
        return;
    }
    if (_page>1) {
        [self.listTableView.mj_footer setHidden:NO];
        //不移除数据
    }else {
        [self.listTableView.mj_footer setHidden:YES];
    }
    NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:@"loginUid"];
    [params setValue:@(self.page) forKey:@"pageNumber"];
    [params setValue:self.content forKey:@"name"];
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
            }
            else
            {
                if(self.page==1){
                   // [EasyShowTextView showText:@"无搜索结果"];
                     [self.listTableView.mj_footer setHidden:YES];
                }else {
                    [self.listTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
                   [self.listTableView reloadData];
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
            footPayView.delegete = self;
            footPayView.listOrder = listOrder;
            footPayView.section =section;
            [self.footPayViewArr addObject:footPayView];

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
            break;
    }
    return orderView;
}
#pragma mark footer点击事件 (删除订单.查看物流.) //收货 转售
-(void)clickFooterBtnClick:(HK_shopOrderList *)model withSenderTag:(NSInteger)tag sections:(NSInteger)section {
    
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //获取每一组的 内容状态
    HK_shopOrderList * listOrder =[self.dataSources objectAtIndex:section];
    HK_orderShopHeaderView * headerView  =[[HK_orderShopHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,50)];
    [headerView configueListOrderHeaderWithModel:listOrder];
    return  headerView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    HK_shopOrderList * listOrder =[self.dataSources objectAtIndex:section];
    return listOrder.subList.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_MyOrderCell * orderCell =[tableView dequeueReusableCellWithIdentifier:@"myOrderCell" forIndexPath:indexPath];
    HK_shopOrderList * listOrder =[self.dataSources objectAtIndex:indexPath.section];
    Hk_subOrderList *listModel =[listOrder.subList objectAtIndex:indexPath.row];
    orderCell.model = listModel;
    return orderCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_shopOrderList * listOrder =[self.dataSources objectAtIndex:indexPath.section];
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
-(UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight) style:UITableViewStyleGrouped];
        _listTableView.delegate  =self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView =[[UIView alloc] init];
        _listTableView.rowHeight = 102;
        _listTableView.showsVerticalScrollIndicator =NO;
        _listTableView.showsHorizontalScrollIndicator =NO;
        _listTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _listTableView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [_listTableView registerNib:[UINib nibWithNibName:@"HK_MyOrderCell" bundle:nil] forCellReuseIdentifier:@"myOrderCell"];
//        //下拉刷新
//        _listTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        //    //上拉加载
        _listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_listTableView.mj_footer setHidden: YES];
        
    }
    return _listTableView;
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
