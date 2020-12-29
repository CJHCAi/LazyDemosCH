//
//  HKCitySelfMediaViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCitySelfMediaViewController.h"
#import "WaterfallColectionLayout.h"
#import "CityHomeRespone.h"
#import "HKCityCollectionViewCell.h"
#import "HKLeSeeViewModel.h"
#import "HKSelfMeidaVodeoViewController.h"
#import "SelfMediaRespone.h"
#import "HKCityTravelsViewController.h"
#import "HKCorporateAdvertisingInfoViewController.h"
#import "HKLocalSelfMediaViewController.h"
@interface HKCitySelfMediaViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)UICollectionViewLayout* layout;
@property (nonatomic,assign) int pageNum;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation HKCitySelfMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.pageNum = 1;
    [self loadData];
}
-(void)loadData{
    [HKLeSeeViewModel getCategoryCityAdvList:@{@"categoryId":self.categoryId,@"cityId":self.cityId,@"pageNumber":@(self.pageNum)} success:^(CityHomeRespone *responde) {
        if (responde.responeSuc) {
            [self.dataArray addObjectsFromArray:responde.data.list];
            [self.collectionView reloadData];
        }
    }];
}
#pragma mark collectionViewDelegate-collectionViewDatesource
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    CityHomeModel*model = self.dataArray[indexPath.item];
    if (model.isweb.integerValue==1) {
        //网页地址...
        HKCityTravelsViewController*vc = [[HKCityTravelsViewController alloc]init];
        vc.cityAdvId = model.cityAdvId;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        //视频播放....
        if (model.advType == 1) {
            SelfMediaModelList*listM = [[SelfMediaModelList alloc]init];
            listM.title = @"";
            listM.coverImgSrc = model.coverImgSrc;
            //    listM.
            listM.praiseCount = model.praiseCount;
            listM.rewardCount = model.rewardCount;
            listM.isCity = YES;
            if (model.ID.length) {
                listM.ID =model.ID;
            }else {
                listM.ID = model.cityAdvId;
            }
            HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
            vc.dataArray = [NSMutableArray arrayWithObject:listM];
            vc.selectRow = 0;
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if (model.type == 1) {
                SelfMediaModelList*listM = [[SelfMediaModelList alloc]init];
                listM.title = @"";
                listM.coverImgSrc = model.coverImgSrc;
                //    listM.
                listM.praiseCount = model.praiseCount;
                listM.rewardCount = model.rewardCount;
                if (model.ID.length) {
                    listM.ID =model.ID;
                }else {
                    listM.ID = model.cityAdvId;
                }
                HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
                vc.dataArray = [NSMutableArray arrayWithObject:listM];
                vc.selectRow = 0;
                
                [self.navigationController pushViewController:vc animated:YES];
            }else if (model.type == 2){
                HKCorporateAdvertisingInfoViewController*vc = [[HKCorporateAdvertisingInfoViewController alloc]init];
                vc.ID = model.ID;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                HKLocalSelfMediaViewController*vc = [[HKLocalSelfMediaViewController alloc]init];
                vc.cityId =model.cityAdvId;
                vc.categoryId = @"";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HKCityCollectionViewCell* cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"city" forIndexPath:indexPath];
    CityHomeModel*model = self.dataArray[indexPath.item];
    cell.model = model;
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;;
}

#pragma mark getter-setter
-(UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight -40-36) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [_collectionView registerNib:[UINib nibWithNibName:@"HKCityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"city"];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _collectionView;
}
-(UICollectionViewLayout *)layout{
    if(!_layout){
        _layout = [[WaterfallColectionLayout alloc]initWithItemsHeightBlock:^CGFloat(NSIndexPath *index) {
            CityHomeModel*model = self.dataArray[index.item];
            
            return  kScreenWidth*0.5*model.coverImgHeight.intValue/ model.coverImgWidth.intValue+103 ;
        }];
        
    }
    return _layout;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];    
    }
    return _dataArray;
}
@end
