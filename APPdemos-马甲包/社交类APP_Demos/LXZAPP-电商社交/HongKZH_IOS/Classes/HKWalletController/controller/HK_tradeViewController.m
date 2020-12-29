//
//  HK_tradeViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_tradeViewController.h"
#import "HK_tradeCell.h"
#import "HK_BaseRequest.h"
#import "HK_orderListModel.h"
@interface HK_tradeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * listTableView;
@property (nonatomic, strong)NSMutableArray * dataSources;
@property (nonatomic, strong)NSString *apiStr;
@property (nonatomic, assign)int page;
@end

@implementation HK_tradeViewController


-(void)initNav {
    if (self.tradeStatus ==tradeSucess) {
        self.navigationItem.title =@"结算中";
        self.apiStr =get_sellerorderListBySettlement;
    }else {
        self.navigationItem.title = @"交易中";
        self.apiStr =get_sellerorderListByTransaction;
    }
    [self setShowCustomerLeftItem:YES];
    
}
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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    self.page =1;
    [self.view addSubview:self.listTableView];
    [self getDataInfo];
 
}
-(NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources =[[NSMutableArray alloc] init];
    }
    return _dataSources;
}
-(UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight) style:UITableViewStylePlain];
        _listTableView.delegate  =self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView =[[UIView alloc] init];
        _listTableView.rowHeight = 70;
        _listTableView.showsVerticalScrollIndicator =NO;
        _listTableView.showsHorizontalScrollIndicator =NO;
        _listTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _listTableView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [_listTableView registerNib:[UINib nibWithNibName:@"HK_tradeCell" bundle:nil] forCellReuseIdentifier:@"tradeCell"];
        UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
        headerView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        _listTableView.tableHeaderView = headerView;
//        //加上拉刷新下拉加载
        //下拉刷新
        _listTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        //    //上拉加载
        _listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_listTableView.mj_footer setHidden: YES];
        
    }
    return _listTableView;
}
//////下拉刷新
-(void)loadNewData {
    self.page =1;
  
}
////加载更多
-(void)loadMoreData {
    self.page++;
    [self getDataInfo];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataSources.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_tradeCell * cell =[tableView dequeueReusableCellWithIdentifier:@"tradeCell" forIndexPath:indexPath];
    OrderList *listData = self.dataSources[indexPath.row];
    
    [cell configueDataWithModel:listData];
    
    return cell;
}
//获取列表信息
-(void)getDataInfo {
    
    if (_page>1) {
        [self.listTableView.mj_footer setHidden:NO];
        //不移除数据
    }else {
        [self.listTableView.mj_footer setHidden:YES];
    }
    NSMutableDictionary * dic =[[NSMutableDictionary alloc] init];
    // LoginUserData * data =[LoginUserData sharedInstance];
    [dic setValue:LOGIN_UID forKey:@"loginUid"];
    
    [dic setValue:[NSNumber numberWithInt:self.page] forKey:@"pageNumber"];
    
    [HK_BaseRequest buildPostRequest:self.apiStr body:dic success:^(id  _Nullable responseObject) {
        
        [self.listTableView.mj_header endRefreshing];
        HK_orderListModel *orderModel=[HK_orderListModel mj_objectWithKeyValues:responseObject];
        if (orderModel.code) {
            NSString *message =orderModel.msg;
            if (message.length) {
                [EasyShowTextView showText:message];
            }
            
        }else {
            if (orderModel.data.list.count) {
                self.dataSources =[NSMutableArray arrayWithArray:orderModel.data.list];
                [self.listTableView reloadData];
                
            }else {
                //返回无记录
                [self.listTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSError * _Nullable error) {
        [self.listTableView.mj_header endRefreshing];
        [self.listTableView.mj_footer endRefreshing];
        [EasyShowTextView showText:@"无网络,稍后重试"];
    }];
    
}
@end
