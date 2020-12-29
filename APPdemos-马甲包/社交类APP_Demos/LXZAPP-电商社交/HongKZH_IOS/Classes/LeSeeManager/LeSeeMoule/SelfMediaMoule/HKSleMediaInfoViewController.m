//
//  HKSleMediaInfoViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSleMediaInfoViewController.h"
#import "WaterfallColectionLayout.h"
#import "HKLeSeeViewModel.h"
#import "SelfMediaRespone.h"
#import "HKSeleMediaCollectionViewCell.h"
#import "HKSelfMeidaVodeoViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "WaterFLayout.h"
@interface HKSleMediaInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,AMapLocationManagerDelegate>
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)UICollectionViewLayout* layout;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic,strong)AMapLocationManager *locationManager;
@property(nonatomic, assign) NSInteger locationPageNum;
@property (nonatomic, strong)NSMutableArray *locationArray;
@end

@implementation HKSleMediaInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //69b1f0ffa7ed4eb7bef4d987e3598ef8
    self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(0);
        make.left.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-44);;
    }];
    self.pageNum = 1;
    if (self.type==1) {
      //判断是否定位成功....
        if ([ViewModelLocator sharedModelLocator].latitude >0&&[ViewModelLocator sharedModelLocator].longitude >0) {
            [self.locationManager stopUpdatingLocation];
            //结束定位
            [self getNewLocationData];
        }else {
            //开始定位
            self.locationManager = [[AMapLocationManager alloc] init];
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
        }
    }else {
        [self loadData];
    }
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.collectionView.mj_footer.hidden = YES;
}
-(void)loadNewData{
    self.pageNum = 1;
    [self loadData];
}
-(void)loadNextData{
    self.pageNum ++;
    [self loadData];
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    DLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    [ViewModelLocator sharedModelLocator].latitude = location.coordinate.latitude;
    [ViewModelLocator sharedModelLocator].longitude = location.coordinate.longitude;
    
    if (reGeocode)
    {
        DLog(@"reGeocode:%@", reGeocode);
    }
    //开始定位
    if ([ViewModelLocator sharedModelLocator].latitude >0&&[ViewModelLocator sharedModelLocator].longitude >0) {
        [self.locationManager stopUpdatingLocation];
          //结束定位
           [self getNewLocationData];
    }
}
//获取
-(void)loadData{
        [HKLeSeeViewModel getCategoryHotAdvList:@{@"pageNumber":@(self.pageNum)} success:^(SelfMediaRespone *responde) {
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            if (responde.responeSuc) {
                if (responde.data.lastPage) {
                    self.collectionView.mj_footer.hidden = YES;
                }else{
                    self.collectionView.mj_footer.hidden = NO;
                }
                if (self.pageNum == 1) {
                    [self.questionArray removeAllObjects];
                }
                [self.questionArray addObjectsFromArray:responde.data.list];
                [self.collectionView reloadData];
            }else{
                if (self.pageNum>0) {
                    self.pageNum --;
                }
            }
        }];
}
-(void)getNewLocationData {
    
    [HKLeSeeViewModel getNearByListWithPage:self.pageNum success:^(SelfMediaRespone *responde) {
        if (responde.responeSuc) {
           [self.questionArray addObjectsFromArray:responde.data.list];
            [self.collectionView reloadData];
        }
    }];
}
#pragma mark collectionViewDelegate-collectionViewDatesource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HKSeleMediaCollectionViewCell* cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"HKSeleMediaCollectionViewCell" forIndexPath:indexPath];
    SelfMediaModelList*model = self.questionArray[indexPath.row];
    cell.model = model;
    cell.indexPath = indexPath;
//    CityHomeModel*model = self.responde.data.list[indexPath.item];
//    cell.model = model;
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.questionArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SelfMediaModelList *model = self.questionArray[indexPath.item];
    CGFloat w = (kScreenWidth-30)*0.5;
    CGFloat maxH = w*4/3;
    CGFloat minH = w*3/4.5;
    
    CGFloat h = kScreenWidth*0.5*model.coverImgHeight.floatValue/ model.coverImgWidth.floatValue;
    if (h>maxH) {
        h = maxH;
    }
    if (h<minH) {
        h = minH;
    }
    return CGSizeMake((kScreenWidth-10)*0.5, h+93);
    
}
#pragma mark getter-setter
-(UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [_collectionView registerNib:[UINib nibWithNibName:@"HKSeleMediaCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKSeleMediaCollectionViewCell"];
//        _collectionView.contentInset = UIEdgeInsetsMake(551, 0, 0, 0);
//        [_collectionView addSubview:self.headView];
    }
    return _collectionView;
}
-(UICollectionViewLayout *)layout{
    if(!_layout){
        WaterFLayout *flowLayout=[[WaterFLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumColumnSpacing = 0;
        flowLayout.columnCount = 2;
        flowLayout.rightMark = 5;
        _layout = flowLayout;
//        _layout = [[WaterfallColectionLayout alloc]initWithItemsHeightBlock:^CGFloat(NSIndexPath *index) {
//            SelfMediaModelList *model = self.questionArray[index.item];
//             return  kScreenWidth*0.5*model.coverImgHeight.intValue/ model.coverImgWidth.intValue+103 ;
//        }];
        
    }
    return _layout;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
    vc.dataArray = [NSMutableArray arrayWithObject:self.questionArray[indexPath.item]];
    vc.selectRow = 0;
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
-(NSMutableArray *)locationArray{
    if (!_locationArray) {
        _locationArray = [NSMutableArray array];
    }
    return _locationArray;
}
@end
