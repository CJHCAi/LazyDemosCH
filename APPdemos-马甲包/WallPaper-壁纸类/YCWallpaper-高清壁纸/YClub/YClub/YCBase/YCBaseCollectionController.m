//
//  YCBaseCollectionController.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCBaseCollectionController.h"
#import "YCBaseCollectionViewCell.h"
#import "YCEditCollectionController.h"

@interface YCBaseCollectionController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation YCBaseCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (UIView *)noResultView
{
    if (!_noResultView) {
        _noResultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64)];
        _noResultImaV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yc_no_result"]];
        _noResultImaV.center = CGPointMake(KSCREEN_WIDTH/2, (KSCREEN_HEIGHT-204)/2);
        _noResultImaV.userInteractionEnabled = YES;
        [_noResultView addSubview:_noResultImaV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_noResultView addGestureRecognizer:tap];
    }
    return _noResultView;
}
- (void)setUpLayOut
{
    _layOut = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (KSCREEN_WIDTH-YC_Base_Space*(YC_Line_Count+1))/YC_Line_Count;
    _layOut.itemSize = CGSizeMake(itemWidth, 54.f/35*itemWidth);
    _layOut.minimumLineSpacing = YC_Base_Space;
    _layOut.minimumInteritemSpacing = YC_Base_Space;
    _layOut.sectionInset = UIEdgeInsetsMake(YC_Base_Space, YC_Base_Space, YC_Base_Space, YC_Base_Space);
}
- (void)setUpCollectionView
{
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64) collectionViewLayout:_layOut];
    _myCollectionView.backgroundColor = YC_Base_BgGrayColor;
    _myCollectionView.showsVerticalScrollIndicator = NO;
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    [self.view addSubview:_myCollectionView];
}
- (void)registerCell
{
    [_myCollectionView registerClass:[YCBaseCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
}
#pragma mark --- Public
- (void)addRefreshHeader
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header setImages:@[[UIImage imageNamed:@"yc_loading_01"]] forState:MJRefreshStateIdle];
    NSMutableArray *gifImgs = [[NSMutableArray alloc] init];
    for (int i = 1; i < 22; i++) {
        NSString *imageName = [NSString stringWithFormat:@"yc_loading_%02d",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [gifImgs addObject:image];
    }
    [header setImages:gifImgs forState:MJRefreshStatePulling];
    [header setImages:gifImgs forState:MJRefreshStateRefreshing];
    _myCollectionView.mj_header = header;
}
- (void)addLoadMoreFooter
{
    if (!_bFirstLoad && !kArrayIsEmpty(self.dataSource)) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"上拉加载更多壁纸^_^" forState:MJRefreshStatePulling];
        [footer setTitle:@"加载中...^_^" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多了o>_<o" forState:MJRefreshStateNoMoreData];
        _myCollectionView.mj_footer = footer;
        _bFirstLoad = YES;
    }
}
- (void)loadNewData
{
}
- (void)loadMoreData
{
}
- (void)requestData
{
}
- (void)endRefresh
{
    [self.myCollectionView.mj_header endRefreshing];
    [self.myCollectionView.mj_footer endRefreshing];
}
#pragma mark --- UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - resultView
- (void)addNoResultView
{
    if (kArrayIsEmpty(self.dataSource) && !self.bFirstLoad) {
        [self.view addSubview:self.noResultView];
    } else {
        [YCHudManager showMessage:@"网络出现状况~T_T~" InView:self.navigationController.view];
        self.pageNum-=30;
    }
}
- (void)removeNoResultView
{
    if (_noResultView && [_noResultView superview]) {
        [_noResultView removeFromSuperview];
        _noResultView = nil;
    }
}
- (void)tapAction
{
    _pageNum = 30;
    [self removeNoResultView];
    [self requestData];
}
@end
