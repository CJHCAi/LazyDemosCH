//
//  HKPersonCuponVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPersonCuponVc.h"
#import "HKNewPersonCell.h"
#import "HK_VipUserHeadview.h"
#import "HK_VipFooterView.h"
//折扣劵详情页面
#import "HKCounponDetailVc.h"
@interface HKPersonCuponVc ()<UITableViewDelegate,UITableViewDataSource,UserHeaderSectionDelegete,HKNewPersonCellDelegate>
{
    //抢购中
    BOOL _duringShop;
    //即将开始
    BOOL _aterLater;
}
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)HK_VipUserHeadview * userHeaderView;
@property (nonatomic, strong)HK_VipFooterView *footView;
@property (nonatomic, copy) NSString * typeStr;
//返回是否当前可以抢
@property (nonatomic, assign)NSInteger sortDate;
//筛选请求参数
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *datas;


@end
@implementation HKPersonCuponVc
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
    self.title = @"新人专享";
    self.showCustomerLeftItem = YES;
    UIButton * moreBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0,0,40,40);
    [moreBtn setImage:[UIImage imageNamed:@"class_search"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(searchNewVip) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * itemMore =[[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    self.navigationItem.rightBarButtonItem = itemMore;
}
-(void)searchNewVip {
    [AppUtils pushGoodsSearchWithCurrentVc:self];
}
-(NSMutableArray *)datas {
    if (!_datas) {
        _datas =[[NSMutableArray alloc] init];
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
     self.page = 1;
    [self.view addSubview:self.tableView];
    [self loadtopReuest
     ];
}
-(void)loadtopReuest {
    [HKNewPerSonTool getNewPersonBaseDataSuccessBlock:^(HKNewPerSonTypeResponse *renponse) {
        self.userHeaderView.response = renponse;
        NSArray * arr =renponse.data.types;
        HKNewPerSonType *tyModel= [arr firstObject];
        self.typeStr = tyModel.typeId;
        self.sortDate = tyModel.sortDate;
    //此处可以判断是否可以抢购..
//        if (tyModel.currentHour >=tyModel.beginDate && tyModel.currentHour <=tyModel.endDate) {
//            self->_duringShop = YES;
//        }else {
//            self->_duringShop = NO;
//        }
//        HKNewPerSonType *laterModel =[arr lastObject];
//        if (laterModel.currentHour >=laterModel.beginDate && laterModel.currentHour <=laterModel.endDate) {
//            self->_aterLater = YES;
//        }else {
//            self->_aterLater = NO;
//        }
        [self loadList];
    } fail:^(NSString *error) {
        
    }];
}
-(void)loadList {
    [HKNewPerSonTool getTypeNewUserListWithId:self.typeStr pageNumber:self.page SuccessBlock:^(HKNewPersonResponse *renponse) {
            [self.tableView.mj_header endRefreshing];
             if (self.page==1) {
                [self.datas removeAllObjects];
              }
            if (self.page == renponse.data.totalPage || renponse.data.totalPage == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_footer resetNoMoreData];
            }
            [self.datas addObjectsFromArray:renponse.data.list];
            [self.tableView reloadData];

    } fail:^(NSString *error) {
        
    }];
}

#pragma mark 点击头部的代理事件
-(void)clickHeaderSectionWithTypeId:(NSString *)typeId  withTag:(NSInteger)tag{
    self.page = 1;
    self.typeStr =typeId;
    self.sortDate = tag;
    [self loadList
     ];
    
}
-(HK_VipUserHeadview *)userHeaderView {
    if (!_userHeaderView) {
        _userHeaderView =[[HK_VipUserHeadview alloc] initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenWidth/3+150)];
        _userHeaderView.delegete = self;
    }
    return _userHeaderView;
}
-(HK_VipFooterView *)footView {
    if (!_footView) {
        _footView =[[HK_VipFooterView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,140)];
    }
    return _footView;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight -NavBarHeight -StatusBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView =[[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight =155;
        _tableView.backgroundColor = MainColor
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = self.userHeaderView;
        _tableView.tableFooterView = self.footView;
        [_tableView registerClass:[HKNewPersonCell class] forCellReuseIdentifier:@"NW"];
        _tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
        _tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewData)];
    }
    return _tableView;
}
-(void)getNewData {
    self.page =1;
    [self loadList];
}
-(void)getMoreData {
    self.page ++;
    [self loadList];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.datas.count;
}
-(void)labelTagBlock:(HKNewPersonList *)list tag:(NSInteger)tag{
    [self enterDetailsWithCellModel:list andTag:tag];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKNewPersonCell *cell =[tableView dequeueReusableCellWithIdentifier:@"NW" forIndexPath:indexPath];
    HKNewPersonList *list =[self.datas objectAtIndex:indexPath.row];
    [cell setListModel:list andTags:self.sortDate];
   
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       HKNewPersonList *list =[self.datas objectAtIndex:indexPath.row];
    [self enterDetailsWithCellModel:list andTag:self.sortDate];
}

-(void)enterDetailsWithCellModel:(HKNewPersonList *)model andTag:(NSInteger)tag {
    //是否登录
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
//    //是否在抢购时间..
//    if (tag==1 && _duringShop) {
//        HKCounponDetailVc * detail =[[HKCounponDetailVc alloc] init];
//        detail.detailID = model.vipCouponId;
//        detail.isVipUser =YES;
//        detail.hasToolBar =YES;
//        [self.navigationController pushViewController:detail animated:YES];
//    }else if (tag ==2 && _aterLater) {

//    }else {
//        [EasyShowTextView showText:@"当前不在抢购时间"];
//    }
    if (tag >=0) {
       //可以抢
    HKCounponDetailVc * detail =[[HKCounponDetailVc alloc] init];
    detail.detailID = model.vipCouponId;
    detail.isVipUser =YES;
    detail.hasToolBar =YES;
    [self.navigationController pushViewController:detail animated:YES];
    }else {
        [EasyShowTextView showText:@"当前不在抢购时间"];
    }
}
@end

