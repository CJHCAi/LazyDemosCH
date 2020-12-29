//
//  HKCollageSuccessVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCollageSuccessVc.h"
#import "HK_counHeaderView.h"
#import "HKCouPonCell.h"
#import "HKCounponTool.h"

@interface HKCollageSuccessVc ()<UITableViewDelegate,UITableViewDataSource,counHeaderViewDelegete,CounDetailDelegete>
@property (nonatomic, strong)UITableView * counTableView;
@property (nonatomic, strong)HK_counHeaderView * header;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)NSInteger page;

@end
@implementation HKCollageSuccessVc
-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource =[[NSMutableArray alloc] init];
    }
    return _dataSource;
}
//去使用_>商品详情
-(void)JustForUSeCoun {
    
    
    
    
}
//出售->跳转到乐娱
-(void)justForSaleCoun {
   
}
-(HK_counHeaderView *)header {
    if (!_header) {
        _header =[[HK_counHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,160)];
        _header.delegete = self;
    }
    return _header;
}
-(UITableView *)counTableView {
    if (!_counTableView) {
        _counTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight) style:UITableViewStylePlain
                         ];
        _counTableView.delegate = self;
        _counTableView.dataSource = self;
        _counTableView.tableFooterView =[[UIView alloc] init];
        _counTableView.backgroundColor =MainColor
        _counTableView.tableHeaderView = self.header;
        _counTableView.rowHeight = 160;
        _counTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        [_counTableView registerClass:[HKCouPonCell class] forCellReuseIdentifier:@"success"];
        _counTableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
        _counTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewData)];
        
    }
    return _counTableView;
}
-(void)getNewData {
    self.page =1;
    [self loadList];
}
-(void)getMoreData {
    self.page ++;
    [self loadList];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCouPonCell *cell =[tableView dequeueReusableCellWithIdentifier:@"success" forIndexPath:indexPath];
    cell.delegete = self;
    HKDisCutList *list = self.dataSource[indexPath.row];
    cell.list = list;
    [cell setSuccessCell];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * v =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,30)];
    v.backgroundColor = MainColor;
    UILabel * tagL =[[UILabel alloc] initWithFrame:CGRectMake(15,16,kScreenWidth-30,14)];
    [AppUtils getConfigueLabel:tagL font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:RGB(102,102,102) text:@"猜你喜欢"];
    [v addSubview:tagL];
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return  nil;
}
#pragma  mark 立即购买..
-(void)setClickDelegeteWithModel:(HKCounList *)model andSender:(NSInteger)index {
    
        [EasyShowTextView showText:@"购买折扣劵"];
}
#pragma mark 跳转到商品详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     HKDisCutList *list = self.dataSource[indexPath.row];
    [AppUtils pushGoodsInfoDetailWithProductId:list.productId andCurrentController:self];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"拼单成功";
    self.showCustomerLeftItem =YES;
    self.sx_disableInteractivePop =YES;
    [self.view addSubview:self.header];
   // self.page = 1;
    //[self.view addSubview:self.counTableView];
   // [self loadList];
    [self getOrderInfo];
}
-(void)backItemClick {
    Class HK_CladlyChattesView = NSClassFromString(@"HK_CladlyChattesView");
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[HK_CladlyChattesView class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
-(void)getOrderInfo {
    [HKCounponTool getCollageOrderInfo:self.orderNumber successBlock:^(HKCollageOrderResponse *response) {
        //self.response = response;
        self.header.response = response;
    } fail:^(NSString *error) {
        
    }];
}
-(void)loadList {
    [HKCounponTool getDisCutCuponListWithPage:self.page successBlock:^(HKDisCutResponse *response) {
        [self.counTableView.mj_header endRefreshing];
        if (self.page ==1) {
            [self.dataSource removeAllObjects];
        }
        if (self.page==response.data.records.totalPage || response.data.records.totalPage==0) {
            [self.counTableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.counTableView.mj_footer endRefreshing];
            [self.counTableView.mj_footer resetNoMoreData];
        }
        [self.dataSource addObjectsFromArray:response.data.records.list];
        [self.counTableView reloadData];

    } fail:^(NSString *error) {
        
    }];
}

@end
