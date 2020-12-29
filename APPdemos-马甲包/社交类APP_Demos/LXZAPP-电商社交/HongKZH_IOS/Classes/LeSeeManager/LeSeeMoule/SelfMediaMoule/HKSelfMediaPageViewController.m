//
//  HKSelfMediaPageViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelfMediaPageViewController.h"
#import "SelfMediaHeadView.h"
#import "HKSleMediaInfoViewController.h"
#import "HJTabViewControllerPlugin_HeaderScroll.h"
#import "HKLeSeeViewModel.h"
#import "HKSowingRespone.h"
#import "CategoryTop10ListRespone.h"
#import "HKSeleMediaCliceViewController.h"
#import "SelfMediaRespone.h"
#import "HKSelfMeidaVodeoViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "SelfMediaSearchsViewModel.h"
#import "HKSelfMedioheadRespone.h"
#import "HKSelfMediaTranslatePageViewController.h"
@interface HKSelfMediaPageViewController ()<HJTabViewControllerDataSource, HJTabViewControllerDelagate,SelfMediaHeadViewDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong) SelfMediaHeadView*headView;
@property (nonatomic,strong)AMapLocationManager *locationManager;
@end

@implementation HKSelfMediaPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabDataSource = self;
    self.tabDelegate = self;
    self.headerZoomIn = NO;
    [self enablePlugin:[HJTabViewControllerPlugin_HeaderScroll new]];
    [self loadHeadData];
    self.isNOTScrollEnabled = YES;
    //开始定位
    [self startLocation];
  
}
-(void)loadHeadData{
    [SelfMediaSearchsViewModel getRecommendMain:@{} type:0 SuccessBlock:^(HKSelfMedioheadRespone *response) {
        if (response.responeSuc) {
            HKSowingRespone*sowM = [[HKSowingRespone alloc]init];
            sowM.data = response.data.carousels;
            self.headView.sowM = sowM;
            CategoryTop10ListRespone*top10 = [[CategoryTop10ListRespone alloc]init];
            top10.data = response.data.top;
            self.headView.top10 =  top10;
        }
    } fail:^(NSString *error) {
        
    }];
}
-(void)startLocation {
    //开始定位
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
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
    }
}
//热门
-(void)loadHot{
    
    [HKLeSeeViewModel getCategoryTop10List:nil success:^(CategoryTop10ListRespone *responde) {
        if (responde.responeSuc) {
            self.headView.top10 = responde;
        }
    }];
}
//轮播图
-(void)loadSowing{
    [HKLeSeeViewModel mediaAdvGetCategoryCarouselList:@{} success:^(HKSowingRespone *responde) {
        if (responde.responeSuc) {
            self.headView.sowM = responde;
        }
    }];
}
-(void)selectWithTag:(NSInteger)tag{
    if (tag<0) {
        HKSelfMediaTranslatePageViewController*vc = [[HKSelfMediaTranslatePageViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    BOOL anim = labs(tag - self.curIndex) > 1 ? NO: YES;
    [self scrollToIndex:tag animated:anim];
}
-(void)clickItme:(CategoryTop10ListModel*)model{
    
            SelfMediaModelList*listM = [[SelfMediaModelList alloc]init];
            listM.title = @"";
            listM.coverImgSrc = model.coverImgSrc;
            //    listM.
            listM.praiseCount = @"";
            listM.rewardCount = @"";
            listM.isCity = NO;
            listM.ID = model.ID;
            HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
            vc.dataArray = [NSMutableArray arrayWithObject:listM];
            vc.selectRow = 0;
            [self.navigationController pushViewController:vc animated:YES];
        
    
}
- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController {
    return 3;
}

- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index {
    if (index == 2) {
      //圈子
        HKSeleMediaCliceViewController *vc = [[HKSeleMediaCliceViewController alloc]init];
        vc.categoryId =self.categoryId;
        vc.block = ^(NSInteger num) {
            self.headView.num = num;
        };
        return vc;
    }
    //人气和附近..
    HKSleMediaInfoViewController*vc = [[HKSleMediaInfoViewController alloc]init];
   // vc.categoryId = self.categoryId ;
    vc.type =index;
    return vc;
}

- (UIView *)tabHeaderViewForTabViewController:(HJTabViewController *)tabViewController {
    
    return self.headView;
}

- (CGFloat)tabHeaderBottomInsetForTabViewController:(HJTabViewController *)tabViewController {
    return 0;
//    return 365;
}

- (UIEdgeInsets)containerInsetsForTabViewController:(HJTabViewController *)tabViewController {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(SelfMediaHeadView *)headView{
    if (!_headView) {
        SelfMediaHeadView*headerView = [[SelfMediaHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 240+kScreenWidth/3+15)];
        _headView = headerView;
        _headView.delegate = self;
    }
    return _headView;
}

@end
