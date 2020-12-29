//
//  HKFrindShopVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFrindShopVc.h"
#import "HKUserGoodsCell.h"
#import "HKMyFriendListViewModel.h"
@interface HKFrindShopVc ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger page;
@end

@implementation HKFrindShopVc
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.view.backgroundColor =[UIColor colorFromHexString:@"ffffff"];
    [self.view addSubview:self.collectionView];
    [self loadShopInfo];
}
-(void)loadShopInfo {
    [HKMyFriendListViewModel getUserShopDataByUid:self.uid withPage:self.page successBlock:^(HKFrindShopResponse *response) {
    
        if (self.page == response.data.totalPage || response.data.totalPage == 0) {
        
             [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        else {
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView.mj_footer resetNoMoreData];
        }
            [self.dataArray addObjectsFromArray:response.data.list];
            [self.collectionView reloadData];
    } fial:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}
-(UICollectionView *)collectionView {
    if (!_collectionView) {
         UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenWidth -30)/2;
        CGFloat itemH = itemW +65;
        layout.itemSize = CGSizeMake(itemW,itemH);
        //2.初始化collectionView
        if ([[LoginUserData sharedInstance].chatId isEqualToString:self.uid]) {
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-NavBarHeight-StatusBarHeight-45-45-210-SafeAreaBottomHeight) collectionViewLayout:layout];
        }else {
             _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-NavBarHeight-StatusBarHeight-45-45-260-SafeAreaBottomHeight) collectionViewLayout:layout];
        }
        _collectionView.backgroundColor = [UIColor whiteColor];
         _collectionView.showsVerticalScrollIndicator =NO;
        [_collectionView registerClass:[HKUserGoodsCell class] forCellWithReuseIdentifier:@"newGoods"];
        _collectionView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        //4.设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
      
    }
    return _collectionView;
}
-(void)loadMoreData {
    self.page++;
    [self loadShopInfo
     ];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15,10,0,10);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return  0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HKUserGoodsCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"newGoods" forIndexPath:indexPath];
    HKFrindShopList *list =self.dataArray[indexPath.row];
    cell.list = list;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HKFrindShopList *list =self.dataArray[indexPath.row];
    [AppUtils pushGoodsInfoDetailWithProductId:list.productId andCurrentController:self];
}
@end
