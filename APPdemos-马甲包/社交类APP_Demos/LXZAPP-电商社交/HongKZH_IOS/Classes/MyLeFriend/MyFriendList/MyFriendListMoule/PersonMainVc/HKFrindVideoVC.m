//
//  HKFrindVideoVC.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFrindVideoVC.h"
#import "HKMyFriendListViewModel.h"
#import "WaterFLayout.h"
#import "HKMyVideoCell.h"
#import "SelfMediaRespone.h"
#import "HKSelfMeidaVodeoViewController.h"
@interface HKFrindVideoVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign)int page;
@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSMutableArray *dataSources;
@end

@implementation HKFrindVideoVC

-(NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources =[[NSMutableArray alloc] init];
    }
    return _dataSources;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page  =1;
    self.view.backgroundColor =[UIColor colorFromHexString:@"ffffff"];
    [self.view addSubview:self.collectionView];
    [self loadVideos];
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //创建瀑布流
        WaterFLayout *flowLayout=[[WaterFLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumColumnSpacing = 10;
        flowLayout.columnCount = 2;
        flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
        if ([[LoginUserData sharedInstance].chatId isEqualToString:self.uid]) {
              _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-45-46-210-SafeAreaBottomHeight) collectionViewLayout:flowLayout];
        }else {
              _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-45-46-260-SafeAreaBottomHeight) collectionViewLayout:flowLayout];
        }
        [_collectionView registerClass:[HKMyVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([HKMyVideoCell class])];
        _collectionView.backgroundColor= UICOLOR_HEX(0xf5f5f5);
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.scrollsToTop = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.showsVerticalScrollIndicator =NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        //上拉加载
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
       // [_collectionView.mj_footer setHidden: YES];
        
    }
    return _collectionView;
}
-(void)loadNewData {
    self.page =1;
    [self loadVideos];
}
-(void)loadMoreData {
    self.page ++;
    [self loadVideos];
}
-(void)loadVideos {
    [HKMyFriendListViewModel getUserVideoDataByUid:self.uid withPage:self.page successBlock:^(HKUserVideoResponse *response) {
        if (self.page == response.data.totalPage || response.data.totalPage == 0) {
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.collectionView.mj_footer endRefreshing];
                    [self.collectionView.mj_footer resetNoMoreData];
                }
        
                [self.dataSources addObjectsFromArray:response.data.list];
                [self.collectionView reloadData];
    } fial:^(NSString *error) {
         [EasyShowTextView showText:error];
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
    HKUserVideoList *myVideoList = [self.dataSources objectAtIndex:indexPath.row];
    HKMyVideoCell *cell = [[HKMyVideoCell alloc] init];
    cell.userList = myVideoList;
    return [cell calcSelfSize];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HKMyVideoCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKMyVideoCell class]) forIndexPath:indexPath];
    HKUserVideoList *myVideoList = [self.dataSources objectAtIndex:indexPath.row];
    cell.userList = myVideoList;
    [cell setUserVideoInfo:self.name andHeadImg:self.headImg];
    return cell;
}
#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray*array = [NSMutableArray arrayWithCapacity:self.dataSources.count];
    for (HKUserVideoList*listD in self.dataSources) {
        SelfMediaModelList*listM =[[SelfMediaModelList alloc] init];
        listM.ID =listD.mediaId;
        listM.praiseCount =listD.playCount;
        listM.uid =self.uid;
        listM.uName = listD.name;
        listM.headImg = listD.headImg;
        listM.coverImgHeight =listD.coverImgHeight;
        listM.coverImgWidth =listD.coverImgWidth;
        listM.title=listD.title;
        listM.coverImgSrc =listD.coverImgSrc;
        [array addObject:listM];
    }
    HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
    vc.dataArray = array;
    vc.selectRow = indexPath.item;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
