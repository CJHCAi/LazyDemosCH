//
//  HKMyTravelViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyTravelViewController.h"
#import "WaterFLayout.h"
#import "HKMyVideoCell.h"
#import "HK_MyVideoTool.h"
#import "HKCityTravelsViewController.h"
@interface HKMyTravelViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, WaterFLayoutDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger curPage;

@property (nonatomic, strong) NSMutableArray *myTravels;

@end

@implementation HKMyTravelViewController

- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //创建瀑布流
        WaterFLayout *flowLayout=[[WaterFLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumColumnSpacing = 10;
        flowLayout.columnCount = 2;
        flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        [collectionView registerClass:[HKMyVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([HKMyVideoCell class])];
        
        collectionView.backgroundColor= UICOLOR_HEX(0xf5f5f5);
        collectionView.delegate=self;
        collectionView.dataSource=self;
        collectionView.scrollsToTop = YES;
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //下拉刷新
//        @weakify(self);
        collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            @strongify(self);
            self.curPage = 1;
            [self requestMyTravel];
        }];
        //上拉刷新
        collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            @strongify(self);
            self.curPage++;
            [self requestMyTravel];
        }];
        
        [self.view addSubview:collectionView];
        _collectionView = collectionView;

        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _collectionView;
}

- (NSMutableArray *)myTravels {
    if (!_myTravels) {
        _myTravels = [NSMutableArray array];
    }
    return _myTravels;
}
#pragma  mark 网络请求
- (void)requestMyTravel {
    [HK_MyVideoTool getTravelsListWithCurrentPage:self.curPage SucceeBlcok:^(id responseJson) {
        HKMyVideo * response =[HKMyVideo mj_objectWithKeyValues:responseJson];
        HKMyVideoData *myTravelVideoData =response.data;
        if (self.curPage == 1) {
            [self.myTravels removeAllObjects];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer resetNoMoreData];
            if (self.curPage == myTravelVideoData.totalPage) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            if (self.curPage == myTravelVideoData.totalPage) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView.mj_footer resetNoMoreData];
            }
        }
        [self.myTravels addObjectsFromArray:myTravelVideoData.list];
        [self.collectionView reloadData];
        
    } Failed:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的游记";
    self.curPage = 1;
    [self setNavItem];
    [self requestMyTravel];
}


#pragma mark UICollectionViewDataSource
//required
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.myTravels count] > 0 ? [self.myTravels count] : 0;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HKMyVideoList *myTravelVideoList = [self.myTravels objectAtIndex:indexPath.row];
    HKMyVideoCell *cell = [[HKMyVideoCell alloc] init];
    cell.myList = myTravelVideoList;
    return [cell calcSelfSize];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HKMyVideoCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKMyVideoCell class]) forIndexPath:indexPath];
    
    HKMyVideoList *myTravelVideoList = [self.myTravels objectAtIndex:indexPath.row];
    cell.myList = myTravelVideoList;
    
    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HKCityTravelsViewController*vc = [[HKCityTravelsViewController alloc]init];
   HKMyVideoList *myTravelVideoList = [self.myTravels objectAtIndex:indexPath.row];
    vc.cityAdvId = myTravelVideoList.ID;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
