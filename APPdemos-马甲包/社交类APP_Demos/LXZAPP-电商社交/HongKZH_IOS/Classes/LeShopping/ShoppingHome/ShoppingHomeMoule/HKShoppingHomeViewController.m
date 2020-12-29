//
//  HKShoppingHomeViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShoppingHomeViewController.h"
#import "HKHKShoppingHomeTableViewCell.h"
#import "HKShoppingCategoryTableViewCell.h"
#import "HKShopingAdvertisementTableViewCell.h"
#import "HKShoppingActivityTableViewCell.h"
#import "HKCateroyShopTableViewCell.h"
#import "HKShopTableViewCell.h"
#import "HKShoppingViewModel.h"
#import "HKLeShopHomeRespone.h"
#import "HKLeShopingNavView.h"
#import "HKTBurstingableViewCell.h"
#import "CommodityDetailsViewController.h"
#import "HKDetailsPageViewController.h"
#import "HKShopCateoryViewController.h"
#import "HKBaseCartListViewController.h"
#import "HKGoodsSearchViewController.h"
#import "HKShopCateoryListViewController.h"
#import "HKBurstingActivityViewController.h"
#import "HKCommodityClassListCell.h"
//新人专享
#import "HKPersonCuponVc.h"
//拼团抢劵
#import "HKCollageVC.h"
#import "CategoryProductListRespone.h"

#import "HKShopCateoryListViewController.h"
@interface HKShoppingHomeViewController ()<UITableViewDelegate,UITableViewDataSource,HKCateroyShopTableViewCellDelegate,HKShoppingActivityTableViewCellDelegate,HKShoppingCategoryTableViewCellDelegate,HKLeShopingNavViewDelegate,PushShopInfoDelegete,HKTBurstingableViewCellDelegate,NewUserVipDelegete>


@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKLeShopHomeRespone *respone;
@property(nonatomic, assign) int shopsIndex;
@property (nonatomic, strong)HKLeShopingNavView *navView;
@property (nonatomic, strong)UIImageView *maskView;
@property (nonatomic,assign) int pageNum;
@property (nonatomic, strong)NSMutableArray *questionArray;
@end

@implementation HKShoppingHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadNewData];
    [self addNotification];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
}
-(void)cancelNewUser {
    [super cancelNewUser];
}
-(void)loadNewData{
    self.pageNum = 1;
    [self loadData];
    [self loadBottomProductListData];
}
-(void)loadNextData{
    self.pageNum ++;
    [self loadBottomProductListData];
}
-(void)loadBottomProductListData{
    [HKShoppingViewModel getbottomProductList:@{kloginUid:HKUSERLOGINID,@"pageNumber":@(self.pageNum)} success:^(CategoryProductListRespone *responde) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (responde.responeSuc) {
            if (responde.data.lastPage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            [self.questionArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
        }else{
            if (self.pageNum>1) {
                self.pageNum--;
            }
        }
    }];
}
-(void)loadData{
    [HKShoppingViewModel getRecruitInfoSuccess:^(HKLeShopHomeRespone *responde) {
        [self.tableView.mj_header endRefreshing];
        if (responde.responeSuc) {
            self.respone = responde;
            [self.tableView reloadData];
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(void)goToSearchVc{
    
    HKGoodsSearchViewController*vc = [[HKGoodsSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)gotoCategryVC:(id)itemM{
    HKLeShopHomeCategoryes*model = (HKLeShopHomeCategoryes*)itemM;
    if ([model.categoryId isEqualToString:@"-1"]) {
   
    HKShopCateoryViewController *vc = [[HKShopCateoryViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        HKShopCateoryListViewController*vc = [[HKShopCateoryListViewController alloc]init];
        vc.categoryId = model.categoryId;
        [self.navigationController pushViewController:vc animated:YES];

    }
}
-(void)gotoVc:(NSInteger)tag{
    if (tag == 1) {
        HKBaseCartListViewController*vc = [[HKBaseCartListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(-20);
    }];
    [self.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.view layoutIfNeeded];
    [self.navView setNavTitle];
}
-(void)selectShop:(NSIndexPath *)indexPath{
    self.shopsIndex = (int)indexPath.item;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}
-(void)gotoBurstingable:(HKLeShopHomeLuckyvouchers *)model{
    HKBurstingActivityViewController*vc = [[HKBurstingActivityViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)gotoDetailsWithID:(NSString*)productId{
    HKDetailsPageViewController*vc = [[HKDetailsPageViewController alloc]init];
    vc.productId = productId;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 6) {
        return self.questionArray.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKHKShoppingHomeTableViewCell*cell = [HKHKShoppingHomeTableViewCell baseCellWithTableView:tableView];
        if (self.respone) {
            cell.imageArray = self.respone.data.carousels;
        }
        
        return cell;
    }else if (indexPath.section == 1){
        HKShoppingCategoryTableViewCell *cell = [HKShoppingCategoryTableViewCell baseCellWithTableView:tableView];
        cell.delegate =self;
        cell.dataArray = self.respone.data.categorys;
        return cell;
    }else if (indexPath.section == 2){
        HKShopingAdvertisementTableViewCell* cell = [HKShopingAdvertisementTableViewCell baseCellWithTableView:tableView];
        cell.delegete = self;
        return cell;
        
    }else if (indexPath.section == 3){
        HKTBurstingableViewCell*cell = [HKTBurstingableViewCell baseCellWithTableView:tableView];
        cell.dataArray = self.respone.data.luckyVoucher;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 4){
        HKShoppingActivityTableViewCell*cell = [HKShoppingActivityTableViewCell baseCellWithTableView:tableView];
        cell.indexPath = indexPath;
        cell.selectedProducts = self.respone.data.selectedProducts;
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 5){
        HKCateroyShopTableViewCell*cell =  [HKCateroyShopTableViewCell baseCellWithTableView:tableView];
        cell.dataArray = self.respone.data.hotsShops;
        cell.delegate = self;
        return cell;
    }else{
        HKCommodityClassListCell*cell = [HKCommodityClassListCell baseCellWithTableView:tableView];
        cell.model = self.questionArray[indexPath.row];
        return cell;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 6) {
      CategoryProductListModels*  model = self.questionArray[indexPath.row];
        [self gotoDetailsWithID:model.productId];
    }
}
#pragma mark 进入店铺页面
-(void)enterShopDetail:(NSString *)shopId {
    
    [AppUtils pushShopInfoWithShopId:shopId andCurrentVc:self];
}
#pragma mark 新人专享-->拼团抢劵
-(void)enterNewVipControllerWithIndex:(NSInteger)index {
    if (index) {
        HKCollageVC * collageVc=[[HKCollageVC alloc] init];
        [self.navigationController pushViewController:collageVc animated:YES];
    }else {
        HKPersonCuponVc *per =[[HKPersonCuponVc alloc] init];
        [self.navigationController pushViewController:per animated:YES];
    }
}
-(void)setShopsIndex:(int)shopsIndex{
    _shopsIndex = shopsIndex;
    [self.tableView reloadData];
}
-(HKLeShopingNavView *)navView{
    if (!_navView) {
        _navView = [[HKLeShopingNavView alloc]init];
        _navView.delegate = self;
    }
    return _navView;
}
-(UIImageView *)maskView {
    if (!_maskView) {
        _maskView =[[UIImageView alloc] init];
        _maskView.image =[UIImage imageNamed:@"lgdb_zzc"];
       // _maskView.image =[UIImage imageNamed:@"p3_1"];
    }
    return _maskView;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     CGFloat y = scrollView.contentOffset.y;
    if (y>=-20) {
        self.navView.hidden = NO;
    }else{
        self.navView.hidden = YES;
    }
    if (y>=64) {
        self.navView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        self.navView.backIcon.hidden = YES;
        self.navView.isSelect = YES;
    }else if (y>=0){
        self.navView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
        self.navView.backIcon.hidden = NO;
        self.navView.isSelect = NO;
    }
}
-(void)gotoMore{
    HKShopCateoryListViewController*vc = [[HKShopCateoryListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray;
}
@end
