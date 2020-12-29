//
//  HKSeleMediaCliceViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSeleMediaCliceViewController.h"
#import "HKSeleMediaCollectionViewCell.h"
#import "CategoryCirclesListRespone.h"
#import "HKLeSeeViewModel.h"
#import "WaterfallColectionLayout.h"
#import "HKCategoryCirclesParamter.h"
#import "HKMyCircleViewController.h"
#import "HKClicleTopToolCell.h"
#import "HKEstablishCliclesViewController.h"
@interface HKSeleMediaCliceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,HKClicleTopToolCellDelegate>
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)UICollectionViewLayout* layout;
@property (nonatomic,assign) int pageNum;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)CategoryCirclesListRespone *responde;
@property (nonatomic, strong)HKCategoryCirclesParamter *paramter;
@end

@implementation HKSeleMediaCliceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.view addSubview:self.collectionView];
    self.pageNum = 1;
    [self loadData];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.collectionView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_footer.hidden = YES;
}
-(void)loadNextData{
    self.pageNum++;
    [self loadData];
}
-(void)loadNewData{
    self.pageNum = 1;
    [self.dataArray removeAllObjects];
    [self loadData];
}
-(void)loadData{
    
    [HKLeSeeViewModel mediaAdvgetCategoryCirclesList:[self.paramter mj_keyValues] success:^(CategoryCirclesListRespone *responde) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [Toast loaded];
        if (responde.responeSuc) {
            if (responde.data.lastPage) {
                self.collectionView.mj_footer.hidden = YES;
            }else{
                self.collectionView.mj_footer.hidden = NO;
            }
            if (self.pageNum==1) {
                [self.dataArray removeAllObjects];
            }
           //拿到圈子数量总和..回调..
            if (self.block) {
                self.block(responde.data.totalRow);
            }
            [self.dataArray addObjectsFromArray:responde.data.list];
            [self.collectionView reloadData];
        }else{
            if (self.pageNum>1) {
                self.pageNum--;
            }
        }
    }];
}
#pragma mark collectionViewDelegate-collectionViewDatesource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }
    HKMyCircleViewController*vc = [[HKMyCircleViewController alloc]init];
   CategoryCirclesListModel*model = self.dataArray[indexPath.row];
    vc.circleId = model.circleId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HKClicleTopToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKClicleTopToolCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    HKSeleMediaCollectionViewCell* cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"HKSeleMediaCollectionViewCell" forIndexPath:indexPath];
    CategoryCirclesListModel*model = self.dataArray[indexPath.row];
    cell.circlesListModel = model;
    //    CityHomeModel*model = self.responde.data.list[indexPath.item];
    //    cell.model = model;
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

#pragma mark - 代理方法 Delegate Methods





// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth, 50);
    }
    return CGSizeMake(kScreenWidth*0.5,(kScreenWidth - 40)*0.5+103) ;
}


// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


#pragma mark getter-setter
-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height-65-50) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [_collectionView registerNib:[UINib nibWithNibName:@"HKSeleMediaCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKSeleMediaCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKClicleTopToolCell" bundle:nil] forCellWithReuseIdentifier:@"HKClicleTopToolCell"];
        
        //        _collectionView.contentInset = UIEdgeInsetsMake(551, 0, 0, 0);
        //        [_collectionView addSubview:self.headView];
    }
    return _collectionView;
}
-(void)clickWithTag:(NSInteger)tag{
    if (tag == 2) {
        HKEstablishCliclesViewController*vc = [[HKEstablishCliclesViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tag ==1) {
       //最新创建
        self.paramter.sortId =@"create_date";
        self.pageNum = 1;
        [Toast loading
         ];
        [self loadData];
    }else {
       //成员较多
        self.paramter.sortId =@"user_count";
        self.pageNum =1;
        [Toast loading];
        [self loadData];
    }
   
}
-(HKCategoryCirclesParamter *)paramter{
    if (!_paramter) {
        _paramter = [[HKCategoryCirclesParamter alloc]init];
        _paramter.pageNumber = 1;
       // _paramter.categoryId = self.categoryId;
    }
    return _paramter;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
