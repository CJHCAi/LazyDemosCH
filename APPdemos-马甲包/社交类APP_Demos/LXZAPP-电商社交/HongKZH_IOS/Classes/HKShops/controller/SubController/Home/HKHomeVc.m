//
//  HKHomeVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHomeVc.h"
#import "HKShopHomeCell.h"
#import "HKGoodsListHead.h"
#import "HKShopTool.h"
//跳转到商品详情
#import "HKDetailsPageViewController.h"
@interface HKHomeVc ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong)SDCycleScrollView *headView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray * shopsData;
@property (nonatomic, copy) NSString *apiStr;
@property (nonatomic, strong)HKShopResponse * response;
@end

@implementation HKHomeVc
-(NSMutableArray *)shopsData {
    if (!_shopsData) {
        _shopsData =[[NSMutableArray alloc] init];
    }
    return _shopsData;
}
-(SDCycleScrollView *)headView {
    if (!_headView) {
        _headView =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,kScreenWidth,160) delegate:self placeholderImage:[UIImage imageNamed:@"1p_91"]];
        _headView.localizationImageNamesGroup =@[@"1p_91",@"1p_101"];
        _headView.autoScrollTimeInterval =3.0;
        _headView.pageControlStyle =SDCycleScrollViewPageContolStyleClassic;
        _headView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    }
    return _headView;
}
#pragma mark SDCycleScrollViewDelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-45-46-87) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight =135;
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.backgroundColor = MainColor
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[HKShopHomeCell class] forCellReuseIdentifier:@"homeCell"];
        if (self.isHome) {
            if (self.response.data.carousels.count) {
                 self.headView.imageURLStringsGroup =self.response.data.carousels;
                _tableView.tableHeaderView = self.headView;
            }
        }
        _tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shopsData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  0.01f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return  nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isHome) {
         return  50;
    }
    return 10;
}
#pragma mark 组头标题视图-->推荐更多
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isHome) {
        HKGoodsListHead * goofH =[[HKGoodsListHead alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,50)];
        goofH.block = ^{
            [EasyShowTextView showText:@"进入店铺商品推荐页"];
        };
        return  goofH;
    }
    UIView * v =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
    v.backgroundColor =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    return  v;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKShopHomeCell * cell =[tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
    cell.listData  =self.shopsData[indexPath.row];
    return cell;
}
#pragma mark 跳转到商品详情页
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKRecomendList *list =self.shopsData[indexPath.row];
    [AppUtils pushGoodsInfoDetailWithProductId:list.productId andCurrentController:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.page =1;
    if (self.shopType==1) {
        //请求推荐页数据
        self.apiStr = get_shopGetShopRemProduct;
    }else if (self.shopType ==2) {
        //商品
        self.apiStr = get_shopGetShopProduct;
    }else {
        //热销
        self.apiStr = get_shopGetShopProductByOrder;
    }
    [self loadRecond];
    [self loadShopInfo];
}
#pragma mark 获取店铺信息
-(void)loadShopInfo {
    [HKShopTool getShopInfoWithShopID:self.shopId SuccessBlock:^(HKShopResponse *response) {
        self.response = response;
        if (self.isHome) {
            if (self.response.data.carousels.count) {
                self.headView.imageURLStringsGroup =self.response.data.carousels;
                self->_tableView.tableHeaderView = self.headView;
            }
        }
    } fail:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}
#pragma mark 请求数据
-(void)loadRecond {
    [HKShopTool getShoplistWithUrl:self.apiStr andShopId:self.shopId andPages:self.page SuccessBlock:^(HKRecondShopResponse *response) {
        
        if (self.page == response.data.totalPage || response.data.totalPage == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }
        [self.shopsData addObjectsFromArray:response.data.list];
        [self.tableView reloadData];
    } fail:^(NSString *error) {
          [EasyShowTextView showText:error];
    }];
}
-(void)loadMoreData {
    self.page ++;
    [self  loadRecond];
}
@end
