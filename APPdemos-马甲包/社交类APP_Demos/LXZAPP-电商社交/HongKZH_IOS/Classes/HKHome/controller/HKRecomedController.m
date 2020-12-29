//
//  HKRecomedController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/9.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRecomedController.h"
#import "HKHomeTool.h"
#import "SelfMediaRespone.h"
#import "HKSelfMeidaVodeoViewController.h"
#import "HKCorporateAdvertisingInfoViewController.h"
#import "HKSelfMeidaVodeoViewController.h"
#import "HKRecommendHeadCollectionViewCell.h"
#import "SelfMediaSearchsViewModel.h"
#import "HKSelfMedioheadRespone.h"
#import "HKSeleMediaCollectionViewCell.h"
#import "SelfMediaHeadView.h"
#import "HKSowingRespone.h"
@interface HKRecomedController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HKRecommendHeadCollectionViewCellDelegate,SelfMediaHeadViewDelegate>
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSMutableArray *dataSources;
@property (nonatomic, strong)HKSelfMedioheadRespone *headInfo;
@property (nonatomic, strong)SelfMediaHeadView *mediaHeadView;
@property (nonatomic, strong)UIView *lineView;
@end

@implementation HKRecomedController
-(NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources =[[NSMutableArray alloc] init];
    }
    return _dataSources;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.page  =1;
    [self.view addSubview:self.collectionView];
    [self loadNewData];
    
}
-(void)clickItme:(CategoryTop10ListModel*)model{
    [self selectTop3:model];
}
-(void)selectTop3:(CategoryTop10ListModel *)top3{
    SelfMediaModelList*listM = [[SelfMediaModelList alloc]init];
    listM.title = @"";
    listM.coverImgSrc = top3.coverImgSrc;
    //    listM.
    listM.praiseCount = @"";
    listM.rewardCount = @"";
    listM.isCity = NO;
    listM.ID = top3.ID;
    HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
    vc.dataArray = [NSMutableArray arrayWithObject:listM];
    vc.selectRow = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 代理方法 Delegate Methods








- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //创建瀑布流
        WaterFLayout *flowLayout=[[WaterFLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumColumnSpacing = 0;
        flowLayout.columnCount = 2;
        flowLayout.rightMark = 5;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-36-46-SafeAreaBottomHeight) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[HKRecommendHeadCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HKRecommendHeadCollectionViewCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKSeleMediaCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKSeleMediaCollectionViewCell"];
        [_collectionView registerClass:[HKMyVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([HKMyVideoCell class])];
        _collectionView.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.scrollsToTop = YES;
        _collectionView.showsVerticalScrollIndicator =NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView addSubview:self.mediaHeadView];
        [_collectionView addSubview:self.lineView];
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
    [self loadHeadData];
}
-(void)loadHeadData{
    [SelfMediaSearchsViewModel getRecommendMain:@{} type:0 SuccessBlock:^(HKSelfMedioheadRespone *response) {
        if (response.responeSuc) {
            self.headInfo = response;
            HKSowingRespone*sowM = [[HKSowingRespone alloc]init];
            sowM.data = response.data.carousels;
            self.mediaHeadView.sowM = sowM;
            CategoryTop10ListRespone*top10 = [[CategoryTop10ListRespone alloc]init];
            top10.data = response.data.top;
            self.mediaHeadView.top10 =  top10;
        }
    } fail:^(NSString *error) {
        
    }];
}
-(void)loadMoreData {
    self.page ++;
    [self loadOrderListInfo];
}
-(void)loadOrderListInfo {
    [HKHomeTool getRecomendListWithPage:self.page SuccessBlock:^(HKReconmendBaseResponse *response) {
          [self.collectionView.mj_header endRefreshing];
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
//    if (section == 0) {
//        return 1;
//    }
    return [self.dataSources count] > 0 ? [self.dataSources count] : 0;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.section == 0) {
//        UIImage*image = [UIImage imageNamed:@"zmt_rdph"];
//        return CGSizeMake(kScreenWidth, (kScreenWidth-10)/3-10+20+20+20+image.size.height+190);
//    }
    HKRecommendListData *myVideoList = [self.dataSources objectAtIndex:indexPath.item];
    CGFloat w = (kScreenWidth-30)*0.5;
    CGFloat maxH = w*4/3;
    CGFloat minH = w*3/4.5;
    
    CGFloat h = kScreenWidth*0.5*myVideoList.coverImgHeight.floatValue/ myVideoList.coverImgWidth.floatValue;
    if (h>maxH) {
        h = maxH;
    }
    if (h<minH) {
        h = minH;
    }
    if (indexPath.item < 2) {
        h+=self.mediaHeadView.height;
    }
    return CGSizeMake((kScreenWidth-10)*0.5, h+93);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        HKRecommendHeadCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKRecommendHeadCollectionViewCell" forIndexPath:indexPath];
//        if (self.headInfo) {
//             cell.respone = self.headInfo;
//        }
//        cell.delegate = self;
//        return cell;
//    }
    HKSeleMediaCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKSeleMediaCollectionViewCell" forIndexPath:indexPath];
    cell.headH = self.mediaHeadView.height;
    cell.indexPath = indexPath;
    HKRecommendListData *myVideoList = [self.dataSources objectAtIndex:indexPath.item];
    SelfMediaModelList *model = [SelfMediaModelList mj_objectWithKeyValues:[myVideoList mj_keyValues]];
    cell.model = model;
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
    
    [self gotoVideo:recommendM.ID antType:[NSString stringWithFormat:@"%ld",(long)recommendM.type] coverImgSrc:recommendM.coverImgSrc indexPath:indexPath];
    
}
-(void)gotoVideo:(NSString*)ID antType:(NSString*)type coverImgSrc:(NSString*)coverImgSrc indexPath:(NSIndexPath*)indexPath{
    //1自媒体 2企业广告3城市广告4传统文化
    if (type.intValue == 1) {
        
        NSMutableArray*array = [NSMutableArray arrayWithCapacity:self.dataSources.count];
        HKRecommendListData*listD = self.dataSources[indexPath.item];
        SelfMediaModelList*listM = [SelfMediaModelList mj_objectWithKeyValues:[listD mj_keyValues]];
        [array addObject:listM];
        HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
        vc.dataArray = array;
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
        
    }
}
-(SelfMediaHeadView *)mediaHeadView{
    if (!_mediaHeadView) {
        UIImage*image = [UIImage imageNamed:@"zmt_rdph"];
        _mediaHeadView = [[SelfMediaHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ((kScreenWidth-10)/3-10+20+20+20+image.size.height)+kScreenWidth/3)];
        _mediaHeadView.delegate = self;
        _mediaHeadView.isHideDown = YES;
    }
    return _mediaHeadView;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mediaHeadView.frame)-1, kScreenWidth, 1)];
        _lineView.backgroundColor = [UIColor colorFromHexString:@"e2e2e2"];
    }
    return _lineView;
}
@end
