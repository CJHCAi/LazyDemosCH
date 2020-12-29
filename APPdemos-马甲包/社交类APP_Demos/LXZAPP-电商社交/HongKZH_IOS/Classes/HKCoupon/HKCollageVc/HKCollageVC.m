//
//  HKCollageVC.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCollageVC.h"
#import "HKSearchView.h"
#import "HKLaunchCollageVc.h"
#import "HKCollageCell.h"
#import "HKCounponTool.h"
#import "HKCounponDetailVc.h"
#import "HK_collageListHeaderView.h"
#import "HKCollageSuccessVc.h"

@interface HKCollageVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,rowBtnClickDelegete>
@property (nonatomic, strong)HKSearchView *searchV;
@property (nonatomic, strong)UITableView * tableView;
//筛选请求参数
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, copy) NSString * sortId;
@property (nonatomic, copy) NSString *sortValue;
@property (nonatomic, strong)NSMutableArray *datas;
@property (nonatomic, strong)HK_collageListHeaderView *topViews;
@end
@implementation HKCollageVC

-(NSMutableArray *)datas {
    if (!_datas) {
        _datas =[[NSMutableArray alloc] init];
    }
    return _datas;
}

-(HK_collageListHeaderView *)topViews {
    if (!_topViews) {
        _topViews =[[HK_collageListHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,40)];
        _topViews.delegete =self;
    }
    return _topViews;
}
-(void)changeRowBtnWithIndex:(NSInteger)index andSender:(HK_CollageBtn *)sender {
    //价格选择.....
    if (index==1) {
        if (sender.states==1) {
            sender.states =2;
            self.sortValue =@"asc";
            [sender setImage:[UIImage imageNamed:@"news_pceU"] forState:UIControlStateNormal];
        }else if (sender.states==2) {
         //降序
            sender.states =3;
            self.sortValue =@"desc";
            [sender setImage:[UIImage imageNamed:@"news_pceD"] forState:UIControlStateNormal];
        }else if (sender.states==3){
          //升序
            sender.states =2;
            self.sortValue =@"asc";
            [sender setImage:[UIImage imageNamed:@"news_pceU"] forState:UIControlStateNormal];
          
        }
           self.sortId = @"integral";
    }
    else {
        self.sortId= @"";
        self.sortValue =@"";
    }
    self.page = 1;
    [self loadList];
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
-(void)initNav {
//        HKSearchView * search =[HKSearchView searchView];
//        search.placeHoder =@"请输入要查找优惠券名称";
//        search.intrinsicContentSize =CGSizeMake(280,30);
//        self.searchV = search;
//        self.navigationItem.titleView = search;
//        self.searchV.tf.delegate = self;
    self.title =@"拼团列表";
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
   //进行搜索..
    [self search];
    
    return YES;
}
-(void)search {
    
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topViews.frame),kScreenWidth,kScreenHeight -NavBarHeight -StatusBarHeight-CGRectGetHeight(self.topViews.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView =[[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight =155;
        _tableView.backgroundColor = MainColor
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[HKCollageCell class] forCellReuseIdentifier:@"NB"];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCollageCell *cell =[tableView dequeueReusableCellWithIdentifier:@"NB" forIndexPath:indexPath];
    HKCollageBaseList * list =[self.datas objectAtIndex:indexPath.row];
    cell.list = list;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    HKCounponDetailVc * detail =[[HKCounponDetailVc alloc] init];
    HKCollageBaseList *list =[self.datas objectAtIndex:indexPath.row];
    detail.detailID = list.collageCouponId;
    detail.hasToolBar = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    self.page = 1;
    self.showCustomerLeftItem = YES;
    [self.view addSubview:self.topViews];
    [self.view addSubview:self.tableView];
    [self loadList];
}
-(void)loadList {
    [HKCounponTool getCollageListWithsortId:self.sortId andsortValue:self.sortValue andPageNumber:self.page successBlock:^(HKCollagedResponse *response) {
        [self.tableView.mj_header endRefreshing];
        if (self.page==1) {
            [self.datas removeAllObjects];
        }
        if (self.page == response.data.totalPage || response.data.totalPage == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }
        [self.datas addObjectsFromArray:response.data.list];
        [self.tableView reloadData];
        
    } fail:^(NSString *error) {
    
    }];
}

@end
