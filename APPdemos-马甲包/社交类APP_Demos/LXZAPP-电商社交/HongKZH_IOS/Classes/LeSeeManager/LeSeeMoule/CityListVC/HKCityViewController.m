//
//  HKCityViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCityViewController.h"
#import "HKLeSeeViewModel.h"
#import "CityHomeRespone.h"
#import "HKCityCollectionViewCell.h"
#import "HKCityHomeHeadView.h"
#import "CityMainRespone.h"
#import "HKCitySelectViewController.h"
#import "HKLocalSelfMediaViewController.h"
#import "HKSelfMeidaVodeoViewController.h"
#import "SelfMediaRespone.h"
#import "HKCorporateAdvertisingInfoViewController.h"
#import "HKCityTravelsViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "HKCityAdvParameter.h"
#import "HKTravelPubLishController.h"
#import "WaterFLayout.h"
#import "HKSeleMediaCollectionViewCell.h"
#import "HKVideoRecordTool.h"
@interface HKCityViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,HKCityHomeHeadViewDelegate,AMapLocationManagerDelegate>
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)WaterFLayout* layout;
@property (nonatomic, strong)CityHomeRespone *responde;
@property (nonatomic, strong)HKCityHomeHeadView *headView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic,strong)AMapLocationManager *locationManager;
@property (nonatomic, strong)NSMutableArray *parameterArray;
@property(nonatomic, assign) int type;
@property (nonatomic, strong)HKVideoRecordTool *tool;
@end

@implementation HKCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(self.view).offset(-45-SafeAreaBottomHeight);
    }];
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.top.equalTo(self.view);
//        make.bottom.equalTo(self.view);;
//    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.collectionView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_footer.hidden = YES;
    [self loadNewData];
}
-(void)loadNextData{
    
    HKCityAdvParameter*parameter =  [self getParameter];
    parameter.pageNumber ++ ;
    [self loadData];
}
-(void)loadNewData{
    HKCityAdvParameter*parameter =  [self getParameter];
    parameter.pageNumber = 1;
    [self loadData];
    [self getMainData];
}
-(void)gotoSwitchType:(NSInteger)tag{
    if (tag ==20) {
        self.type=1;
    }else {
        self.type =0;
    }
}
-(void)toVcCity{
    [HKReleaseVideoParam setObject:@"e124ec25353d43c39394d30ff1416879" key:@"categoryId"];
    [HKReleaseVideoParam setObject:HKUSERLOGINID key:@"loginUid"];
    
    
    HK_BaseAllCategorys*models = [[HK_BaseAllCategorys alloc]init];
    models.type = @"3";
    models.parentId = @"0";
    models.name = @"城市";
    models.categoryId = @"e124ec25353d43c39394d30ff1416879";
    models.isUpdateCategory = YES;
    [HKReleaseVideoParam shareInstance].category = models;
    [HKReleaseVideoParam shareInstance].publishType = ENUM_PublishTypePublic;
    [self.tool toRecordView];
    
}
-(void)gotoVcLocaWithIsLoc:(int)index{
    if (index < 0) {
        HKLocalSelfMediaViewController*vc = [[HKLocalSelfMediaViewController alloc]init];
        vc.cityId =@"110100";
        vc.categoryId = @"";
        vc.cityName =@"本地";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
      CityMainHostModel* model =  self.headView.respone.data.hots[index];
        HKLocalSelfMediaViewController*vc = [[HKLocalSelfMediaViewController alloc]init];
        vc.cityId =model.ID;
        vc.categoryId = @"";
        vc.cityName =model.cityName;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)getMainData{
    [HKLeSeeViewModel getCityMain:@{} success:^(CityMainRespone *responde) {
        if (responde.responeSuc) {
            self.headView.respone = responde;
        }
    }];
}
-(void)loadData{
    
    HKCityAdvParameter*parameter =  [self getParameter];
    [HKLeSeeViewModel getCityAdvList:parameter success:^(CityHomeRespone *responde) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (responde.responeSuc) {
            if (responde.data.lastPage) {
                self.collectionView.mj_footer.hidden = YES;
            }else{
                self.collectionView.mj_footer.hidden = NO;
            }
            if (parameter.pageNumber == 1) {
                [parameter.questionArray removeAllObjects];
            }
            [parameter.questionArray addObjectsFromArray:responde.data.list];
            [self.collectionView reloadData];
        }else{
            if (parameter.pageNumber>1) {
                parameter.pageNumber--;
            }
        }
       
    }];
}
//获取附近城市信息...
-(void)getNearByList {
  HKCityAdvParameter*parameter =  [self getParameter];
    [HKLeSeeViewModel getCityAdvList:parameter success:^(CityHomeRespone *responde) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (responde.responeSuc) {
            if (parameter.pageNumber ==1) {
                [parameter.questionArray removeAllObjects];
            }
            if (responde.data.lastPage) {
                self.collectionView.mj_footer.hidden = YES;
            }else{
                self.collectionView.mj_footer.hidden = NO;
            }
            [parameter.questionArray addObjectsFromArray:responde.data.list];
            [self.collectionView reloadData];
            
        }else{
            if (parameter.pageNumber>1) {
                parameter.pageNumber--;
            }
        } 
    }];
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
    if ([ViewModelLocator sharedModelLocator].latitude >0&&[ViewModelLocator sharedModelLocator].longitude >0) {
        [self.locationManager stopUpdatingLocation];
        [self getNearByList];
    }
}
#pragma mark 城市附近 人气


#pragma mark - 代理方法 Delegate Methods
-(void)gotoPubLish:(NSString *)cityId {
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    HKTravelPubLishController *tran =[[HKTravelPubLishController alloc] init];
    [self.navigationController pushViewController:tran animated:YES];
}
// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKCityAdvParameter*parameter =  [self getParameter];
        CityHomeModel*model = parameter.questionArray[indexPath.item];
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
    if (indexPath.item < 2) {
        h+=self.headView.height;
    }
    return CGSizeMake((kScreenWidth-10)*0.5, h+93);
}
#pragma mark collectionViewDelegate-collectionViewDatesource
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    
    HKCityAdvParameter*parameter =  [self getParameter];
    CityHomeModel*model = parameter.questionArray[indexPath.item];
    if (model.isweb.integerValue==1) {
        //网页地址...
        HKCityTravelsViewController*vc = [[HKCityTravelsViewController alloc]init];
        vc.cityAdvId = model.cityAdvId;
        vc.isCity = YES;
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
    HKSeleMediaCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKSeleMediaCollectionViewCell" forIndexPath:indexPath];
    cell.headH = self.headView.height;
    cell.indexPath = indexPath;
    HKCityAdvParameter*parameter =  [self getParameter];
     CityHomeModel*model = parameter.questionArray[indexPath.item];
    cell.cityM = model;
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    HKCityAdvParameter*parameter =  [self getParameter];
    return parameter.questionArray.count;;
}

// 设置区头尺寸高度
#pragma mark getter-setter
-(UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [_collectionView registerNib:[UINib nibWithNibName:@"HKSeleMediaCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKSeleMediaCollectionViewCell"];
        [_collectionView addSubview:self.headView];
    }
    return _collectionView;
}
-(void)setType:(int)type{
    _type = type;
    HKCityAdvParameter*p =  [self getParameter];
//    if (p.questionArray.count == 0) {
//
//
//    }else{
//        [self.collectionView reloadData];
//    }
    [self loadNewData];
}
-(WaterFLayout *)layout{
    if(!_layout){

        WaterFLayout *flowLayout=[[WaterFLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumColumnSpacing = 0;
        flowLayout.columnCount = 2;
        flowLayout.rightMark = 5;
        _layout = flowLayout;
        }
    return _layout;
}
-(HKCityHomeHeadView *)headView{
    if (!_headView) {
        _headView = [[HKCityHomeHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ((kScreenWidth - 10)/3-10)*3/4+74 + 364)];
        _headView.delegate = self;
    }
    return _headView;
}
-(HKCityAdvParameter*)getParameter{
    return self.parameterArray[_type];
}
-(NSMutableArray *)parameterArray{
    if (!_parameterArray) {
        HKCityAdvParameter *parameter = [[HKCityAdvParameter alloc]init];
        parameter.type = 0;
        HKCityAdvParameter *parameter1 = [[HKCityAdvParameter alloc]init];
        parameter1.type = 1;
        _parameterArray = [NSMutableArray arrayWithArray:@[parameter,parameter1]];
    }
    return _parameterArray;
}
- (HKVideoRecordTool *)tool {
    if (!_tool) {
        _tool = [HKVideoRecordTool videoRecordWithDelegate:self];
    }
    return _tool;
}
@end
