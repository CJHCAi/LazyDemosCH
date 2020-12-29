//
//  HKSelfMediaSearchListViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelfMediaSearchListViewController.h"
#import "HKNavSearchView.h"
#import "WaterFLayout.h"
#import "HKMyVideoCell.h"
#import "SelfMediaSearchsViewModel.h"
#import "SelfMediaRespone.h"
#import "HKSelfMeidaVodeoViewController.h"
#import "HKCorporateAdvertisingInfoViewController.h"
@interface HKSelfMediaSearchListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HKNavSearchViewDelegate>
@property (nonatomic, strong)NSMutableArray *dataSources;
@property (nonatomic,assign) int pageNumber;
@property (nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, assign) int page;
@property (nonatomic, strong)HKNavSearchView *navView;
@end

@implementation HKSelfMediaSearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
    }];
}
-(void)closeSearch{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //创建瀑布流
        WaterFLayout *flowLayout=[[WaterFLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumColumnSpacing = 10;
        flowLayout.columnCount = 2;
        flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-45-NavBarHeight) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[HKMyVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([HKMyVideoCell class])];
        _collectionView.backgroundColor= UICOLOR_HEX(0xf5f5f5);
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.scrollsToTop = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.showsVerticalScrollIndicator =NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        //下拉刷新
        _collectionView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        //上拉加载
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _collectionView;
}

-(void)loadNewData {
    self.page =1;
    [self loadOrderListInfo];
}
-(void)loadMoreData {
    self.page ++;
    [self loadOrderListInfo];
}
-(void)loadOrderListInfo {
    [SelfMediaSearchsViewModel getRecomendListWithDict:@{@"loginUid":HKUSERLOGINID,@"title":self.titleStr,@"pageNumber":@(self.page)} type:self.mediaType SuccessBlock:^(HKReconmendBaseResponse *response) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (self.page == response.data.totalPage || response.data.totalPage == 0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView.mj_footer resetNoMoreData];
        }
        if (self.page==1 ) {
            [self.dataSources removeAllObjects];
        }
        [self.dataSources addObjectsFromArray:response.data.list];
        [self.collectionView reloadData];
        
    } fail:^(NSString *error) {
        [EasyShowTextView showText:error];

        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}
#pragma mark UICollectionViewDataSource
//required
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSources count] > 0 ? [self.dataSources count] : 0;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HKRecommendListData *myVideoList = [self.dataSources objectAtIndex:indexPath.row];
    HKMyVideoCell *cell = [[HKMyVideoCell alloc] init];
    cell.data = myVideoList;
    return [cell calcSelfSize];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HKMyVideoCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKMyVideoCell class]) forIndexPath:indexPath];
    cell.isRecond = NO;
    HKRecommendListData *myVideoList = [self.dataSources objectAtIndex:indexPath.row];
    cell.data = myVideoList;
    return cell;
}
#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    HKRecommendListData*recommendM = self.dataSources[indexPath.row];
    [self gotoVideo:recommendM.ID antType:[NSString stringWithFormat:@"%zd",recommendM.type] coverImgSrc:recommendM.coverImgSrc];
    
}
-(void)gotoVideo:(NSString*)ID antType:(NSString*)type coverImgSrc:(NSString*)coverImgSrc{
    //1自媒体 2企业广告3城市广告4传统文化
    if (type.intValue == 1) {
        SelfMediaModelList*listM = [[SelfMediaModelList alloc]init];
        listM.title = @"";
        listM.coverImgSrc = coverImgSrc;
        //    listM.
        listM.praiseCount = @"";
        listM.rewardCount = @"";
        listM.isCity = NO;
        listM.ID = ID;
        HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
        vc.dataArray = [NSMutableArray arrayWithObject:listM];
        vc.selectRow = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type.intValue == 2){
        HKCorporateAdvertisingInfoViewController*vc = [[HKCorporateAdvertisingInfoViewController alloc]init];
        vc.ID = ID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type.intValue == 3){
        SelfMediaModelList*listM = [[SelfMediaModelList alloc]init];
        listM.title = @"";
        listM.coverImgSrc = coverImgSrc;
        //    listM.
        listM.praiseCount = @"";
        listM.rewardCount = @"";
        listM.isCity = YES;
        listM.ID = ID;
        HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
        vc.dataArray = [NSMutableArray arrayWithObject:listM];
        vc.selectRow = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SelfMediaModelList*listM = [[SelfMediaModelList alloc]init];
        listM.title = @"";
        listM.coverImgSrc = coverImgSrc;
        //    listM.
        listM.praiseCount = @"";
        listM.rewardCount = @"";
        listM.isCity = NO;
        listM.ID = ID;
        HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
        vc.dataArray = [NSMutableArray arrayWithObject:listM];
        vc.selectRow = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (NSMutableArray *)dataSources
{
    if(_dataSources == nil)
    {
        _dataSources = [ NSMutableArray array];
    }
    return _dataSources;
}
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.navView.textField.text = titleStr;
    [self loadNewData];
}
-(HKNavSearchView *)navView{
    if (!_navView) {
        _navView = [[HKNavSearchView alloc]init];
        _navView.delegate = self;
    }
    return _navView;
}
@end
