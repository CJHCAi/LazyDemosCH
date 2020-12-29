//
//  YCCheckViewController.m
//  YClub
//
//  Created by yuepengfei on 17/6/26.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCCheckViewController.h"
#import "YCBaseCollectionViewCell.h"
#import "YCEditCollectionController.h"
#import "UIViewController+WXSTransition.h"

@implementation YCCheckViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUpLayOut];
    [self setUpCollectionView];
    [self registerCell];
    [self requestData];
    [self addRefreshHeader];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.bEdit) {
        [self.myCollectionView reloadData];
        if (!kObjectIsEmpty(self.indexPath)) {
            [self.myCollectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
        self.bEdit = NO;
    }
}
- (void)requestData
{
    [self requestTypeListData];
}
- (void)loadNewData
{
    if (!kArrayIsEmpty(self.dataSource)) {
        [self endRefresh];
        return;
    }
    self.pageNum = 0;
    [self requestData];
}
- (void)loadMoreData
{
    if (self.loading) {
        [self.myCollectionView.mj_footer endRefreshing];
        return;
    }
    self.loading = YES;
    self.pageNum+=30;
    [self requestData];
}
- (void)requestTypeListData
{
    [YCNetManager getCategoryListWithTId:_tid skip:@(self.pageNum) callBack:^(NSError *error, NSArray *pics) {
        [self endRefresh];
        if (!kArrayIsEmpty(pics)) {
            [self.dataSource addObjectsFromArray:pics];
            [self.myCollectionView reloadData];
            [self addLoadMoreFooter];
        } else {
            [self addNoResultView];
        }
        self.loading = NO;
    }];
}
#pragma mark - collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YCBaseCollectionViewCell *baseCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    [baseCell setModel:self.dataSource[indexPath.item]];
    return baseCell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.dataSource.count-6 && self.scrollBottom && !self.loading)
    {
        [self loadMoreData];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    YCEditCollectionController *editVC = [[YCEditCollectionController alloc] init];
    editVC.presentVC  = self;
    editVC.category = YES;
    editVC.order    = _tid;
    editVC.pageNum    = self.pageNum+30;
    editVC.dataSource = self.dataSource;
    editVC.indexPath  = indexPath;
    [self wxs_presentViewController:editVC  animationType:WXSTransitionAnimationTypeSysRippleEffect completion:nil];
}
#pragma mark - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.lastOffSetY<scrollView.contentOffset.y) {
        self.scrollBottom = YES;
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.lastOffSetY = scrollView.contentOffset.y;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
