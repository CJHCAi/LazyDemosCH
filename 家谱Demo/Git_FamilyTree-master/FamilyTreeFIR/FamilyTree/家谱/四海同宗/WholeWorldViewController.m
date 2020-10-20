//
//  WholeWorldViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/31.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WholeWorldViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WholeWorldAdgnatioModel.h"

#define LeftSetuView_size 15

static NSString *const kReusableIdentifier = @"PinAnnotation";

@interface WholeWorldViewController ()<HeaderSelectViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,CommandNavigationViewsDelegate>

@property (nonatomic,strong) HeaderSelectView *headerView; /*选择视图*/

@property (nonatomic,strong) MKMapView *mapView; /*地图*/

@property (nonatomic,copy) NSArray *dataArr; /*点击坐标显示的文字信息*/

/** 定位管理器 **/
@property (nonatomic, strong)CLLocationManager *clLocationManager;

/** 宗亲模型数组*/
@property (nonatomic, strong) NSArray<WholeWorldAdgnatioModel *> *WholeWorldAdganatioModelArr;

@end

@implementation WholeWorldViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.comNavi.delegate = self;
    //默认为空
    self.queryString = @"";
    
    [self initUI];
    //打开定位
    [self startLocation];
    //[self getData];
    //[self initLocation];
    
    
}
#pragma mark *** 选择右上角家谱后的更新UI ***
-(void)CommonNavigationViews:(CommonNavigationViews *)comView selectedFamilyId:(NSString *)famId{
    NSLog(@"选择了这个家谱id-%@", famId);
}
-(void)startLocation{
    // 1.设备是否开启了定位服务
    if (![CLLocationManager locationServicesEnabled])
    {
        //NSLog(@"定位服务不可用，请打开定位功能");
        [SXLoadingView showAlertHUD:@"定位服务不可用，请打开定位功能" duration:0.5];
        return;
    }
    
    // 2.检测本应用的定位服务是否已经开启
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        //NSLog(@"你已经拒绝了开启定位，还是去设置中打开吧");
        [SXLoadingView showAlertHUD:@"你已经拒绝了开启定位，还是去设置中打开吧" duration:0.5];
        return;
    }
    
    // 3.开始更新位置信息(定位)
    //[self.mgr startUpdatingLocation];
    
    // requestLocation是iOS9之后才有的
    // 特点：只会发一次请求定位的消息
    // 注意：要想使用此方法，必须在代理中添加locationManager:didFailWithError:方法
    // 否则系统崩溃
    [self.clLocationManager requestLocation];
}



#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    MYLog(@"定位中");
    MYLog(@"%lf,%lf",locations.lastObject.coordinate.latitude,locations.lastObject.coordinate.longitude);
    MKCoordinateRegion region ;//表示范围的结构体
    region.center = locations.lastObject.coordinate;//中心点
    region.span.latitudeDelta = 0.5;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.5;//纬度范围
    [self.mapView setRegion:region animated:YES];
    
    
    //[self.mapView setCenterCoordinate:locations.lastObject.coordinate];
    [self getData:locations.lastObject];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    MYLog(@"定位失败");
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"用户还没做出决定");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"访问受限");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"用户选择了不允许");
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"开启了Alway模式");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"开启了whenInUse状态");
            break;
        default:
            NSLog(@"default");
            break;
    }
}



-(void)getData:(CLLocation *)location{
    NSDictionary *logDic = @{@"query":self.queryString,
                             @"type":@"Near",
                             @"lat":[NSString stringWithFormat:@"%lf",location.coordinate.latitude],
                             @"lng":[NSString stringWithFormat:@"%lf",location.coordinate.longitude]};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeQueryClan success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"附近--%@",[NSString jsonDicWithDic:jsonDic[@"data"]]);
        if (succe) {
            weakSelf.WholeWorldAdganatioModelArr = [NSArray modelArrayWithClass:[WholeWorldAdgnatioModel class] json:jsonDic[@"data"]];
            
//            WholeWorldAdgnatioModel *model = [[WholeWorldAdgnatioModel alloc]init];
//            model.GemeName = @"李白";
//            model.GemeLat = 39.26;
//            model.GemeLng = 115.25;
//            weakSelf.WholeWorldAdganatioModelArr = @[model];
            
            [weakSelf initLocation];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


//模拟定位
-(void)initLocation{
    
//    NSArray *latArr = @[@"40",@"36",@"29",@"10"];
//    NSArray *longArr = @[@"107",@"115",@"128",@"90"];

    //    for (int idx = 0; idx<latArr.count; idx++) {
//        
//        CLLocationCoordinate2D corrdinate = CLLocationCoordinate2DMake([latArr[idx] floatValue],[longArr[idx] floatValue]);
//        
//        //创建标注数据源
//        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//        
//        annotation.coordinate = corrdinate;
//        
//        annotation.title = @"三张李四张三李四";
//        
//        
//        [self.mapView addAnnotation:annotation];
//    }
    
    for (int i = 0; i < self.WholeWorldAdganatioModelArr.count; i++) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.WholeWorldAdganatioModelArr[i].GemeLat, self.WholeWorldAdganatioModelArr[i].GemeLng);
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = coordinate;
        annotation.title = self.WholeWorldAdganatioModelArr[i].GemeName;
        [self.mapView addAnnotation:annotation];
    }
    
    
    
}

#pragma mark *** HeaderSelectViewDelegate ***

-(void)HeaderSelecteView:(HeaderSelectView *)headSeView didSelectedBtn:(UIButton *)sender{
    NSLog(@"%@", sender.titleLabel.text);
}

#pragma mark *** 初始化界面 ***
-(void)initUI{
    
    //顶部图
    HeaderSelectView *headView = [[HeaderSelectView alloc] init];
    headView.delegate = self;
    [self.view addSubview:headView];
    self.headerView = headView;
    headView.sd_layout.heightIs(50).rightSpaceToView(self.view,0).topSpaceToView(self.view,64).rightSpaceToView(self.view,0);
    self.comNavi.delegate = self;
    //地图
    [self.view addSubview:self.mapView];
    self.mapView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,64)
    .bottomSpaceToView(self.view,0);
    
    //左下角图
    NSArray *namesArr = @[@"宗室团体",@"家族成员",@"重要地点"];
    NSArray *imageNames = @[@"red_sm",@"yel_sm",@"ci_sm"];
    for (int idx = 0; idx<namesArr.count; idx++) {
        
        UIImageView *theImage = [UIImageView new];
        theImage.image = MImage(imageNames[idx]);
        theImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:theImage];
        //布局
        
        theImage.sd_layout.leftSpaceToView(self.view,20).topSpaceToView(self.view,0.8*Screen_height+idx*(25)).heightIs(LeftSetuView_size).widthIs(LeftSetuView_size);
        
        UILabel *theLabel = [UILabel new];
        theLabel.font = MFont(12);
        theLabel.textAlignment = 0;
        theLabel.text = namesArr[idx];
        [self.view addSubview:theLabel];
        
        theLabel.sd_layout.leftSpaceToView(theImage,5).topEqualToView(theImage).widthIs(60).heightIs(LeftSetuView_size);
    }
}

#pragma mark *** MKMapViewDelegate ***

-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    NSLog(@"%@", error.localizedDescription);
    
}



//自定义标注数据原视图

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    //异常处理
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    //表主视图重用机制
    MKAnnotationView *pinAnnotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kReusableIdentifier];
    if (!pinAnnotationView) {
        pinAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kReusableIdentifier];
    }
    //更新标注数据源
//    pinAnnotationView.annotation = annotation;
    pinAnnotationView.image=[UIImage imageNamed:@"ci"];
    pinAnnotationView.canShowCallout = YES;
    return pinAnnotationView;
}

#pragma mark *** gesEvents ***
-(void)respondsToLongGes:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        //获取手势在地图上的位置
        CGPoint location = [gesture locationInView:self.mapView];
        //手势换成经纬度
        CLLocationCoordinate2D corrdinate = [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
        
        MYLog(@"%lf--%lf",corrdinate.latitude,corrdinate.longitude);
        
        //创建标注数据源
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        
        annotation.coordinate = corrdinate;
        
        annotation.subtitle = @"elpsycongroo";
        
        [self.mapView addAnnotation:annotation];
    }
    
}

#pragma mark *** getters ***

-(MKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.mapType = MKMapTypeStandard;
        
        _mapView.delegate = self;
        
        _mapView.showsCompass = YES;
        
        //长按手势添加大头针
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLongGes:)];
        [_mapView addGestureRecognizer:longGesture];
        
    }
    return _mapView;
}

- (CLLocationManager *)clLocationManager{
    if (!_clLocationManager) {
        // 1.创建定位管理器
        _clLocationManager = [[CLLocationManager alloc]init];
        
        // 2.设置代理
        _clLocationManager.delegate = self;
        
        // 3.询问用户是否允许开启定位(前台定位)
        //WhenInUse:默认只支持前台定位
        //但：可以通过两步设置，是的whenInUser也能后台定位
        //step1:到target中勾选后台定位选项
        //step2:设置manager的allowsBackground为yes
        //与always进入后台后的区别，在于whenInUse模式会在
        //顶部出现蓝色提示条
        [_clLocationManager requestWhenInUseAuthorization];
        //_clLocationManager.allowsBackgroundLocationUpdates = YES;
        
//        //Always:默认支持前后台定位
    //[_clLocationManager requestAlwaysAuthorization];
    }
    return _clLocationManager;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_clLocationManager stopUpdatingLocation];
    _mapView = nil;
    _mapView.delegate = nil;
    _mapView.showsUserLocation = NO;
    _clLocationManager.delegate = nil;
    _clLocationManager = nil;
}

@end
