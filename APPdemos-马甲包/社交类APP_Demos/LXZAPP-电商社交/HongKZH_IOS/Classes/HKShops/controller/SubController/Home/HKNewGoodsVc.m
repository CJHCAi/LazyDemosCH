//
//  HKNewGoodsVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKNewGoodsVc.h"
#import "HKNewGoodsCell.h"
#import "HKNewGoodsSection.h"
#import "HKShopTool.h"
#import "HKDetailsPageViewController.h"
@interface HKNewGoodsVc ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
     UICollectionView * mainCollectionView;
    
}
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger page;
@end

@implementation HKNewGoodsVc
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc] init];
    }
    return _dataArray;
}
//列表布局
-(void)setUpListTableView {
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (kScreenWidth -15*2 -10*2)/3;
    CGFloat itemH = itemW +90;
    layout.itemSize = CGSizeMake(itemW,itemH);
    layout.headerReferenceSize = CGSizeMake(kScreenWidth,40);
    //2.初始化collectionView
    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-NavBarHeight-StatusBarHeight-45-46-87) collectionViewLayout:layout];
    [self.view addSubview:mainCollectionView];
    mainCollectionView.backgroundColor = [UIColor whiteColor];
    mainCollectionView.showsVerticalScrollIndicator =NO;
    [mainCollectionView registerClass:[HKNewGoodsCell class] forCellWithReuseIdentifier:@"newGoods"];
    [mainCollectionView registerClass:[HKNewGoodsSection class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    //上拉加载
//    mainCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    [mainCollectionView.mj_footer setHidden: YES];
      mainCollectionView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //4.设置代理
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
}
-(void)loadMoreData {
    self.page++;
    [self loadData
     ];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  self.dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    HKShopNewGoodsList *list =[self.dataArray objectAtIndex:section];
    return list.products.count;
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,15,0,15);
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
    HKNewGoodsCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"newGoods" forIndexPath:indexPath];
    HKShopNewGoodsList *list =[self.dataArray objectAtIndex:indexPath.section];
    HKShopNewGoodsProduct *product = list.products[indexPath.row];
    cell.list = product;
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
         HKNewGoodsSection *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        reusableview = headerView;
       HKShopNewGoodsList *list =[self.dataArray objectAtIndex:indexPath.section];
        headerView.timeLabel.text =[NSString  stringWithFormat:@"%@本店上新",list.day1];
     }
    return  reusableview;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HKShopNewGoodsList *list =[self.dataArray objectAtIndex:indexPath.section];
    HKShopNewGoodsProduct *product = list.products[indexPath.row];
    [AppUtils pushGoodsInfoDetailWithProductId:product.productId andCurrentController:self];
}
-(void)loadData {
    [HKShopTool getNewGoodsDataByShopId:self.shopId andPage:self.page successBlock:^(HKShopNewGoods *response) {
        
        if (self.page == response.data.totalPage || response.data.totalPage == 0) {
            [self->mainCollectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self->mainCollectionView.mj_footer endRefreshing];
            [self->mainCollectionView.mj_footer resetNoMoreData];
        }
        [self.dataArray addObjectsFromArray:response.data.list];
        [self->mainCollectionView reloadData];

    } fail:^(NSString *error) {
         [EasyShowTextView showText:error];
    }
     ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self setUpListTableView];
    //获取上新页数据
    [self loadData];
}


@end
