//
//  YXWSetViewController.m
//  StarAlarm
//
//  Created by dllo on 16/3/30.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWGlobalSetViewController.h"
#import "YXWWallPaperViewController.h"
#import "YXWAboutUsViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface YXWGlobalSetViewController ()<CLLocationManagerDelegate>

//button
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *wallpaperBt;
@property (nonatomic, strong) UIButton *animationBt;
@property (nonatomic, strong) UIButton *aboutUsBt;
@property (nonatomic, strong) UIButton *weather;
//粒子效果
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) CAEmitterLayer *emitter;
@property (nonatomic, strong) CAEmitterCell *cell;
@property (nonatomic, strong) CAEmitterLayer *newenitter;
//城市搜索
@property (nonatomic, strong) UITextField *cityFiled;
@property (nonatomic, strong) CLLocationManager *lacationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) MKUserLocation *userLocation;
@property (nonatomic, strong) NSMutableString *str;

@end

@implementation YXWGlobalSetViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self creatContent];
    [self creatMap];
}

-(UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 创建页面
-(void)creatContent {
    //页面关闭button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"GB.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonAction:)];
    //背景灰
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.203825431034483];
    [self.view addSubview:backView];
    //壁纸button
    self.wallpaperBt = [UIButton buttonWithType:UIButtonTypeSystem];
    self.wallpaperBt.frame = CGRectMake(self.view.frame.size.width / 3 - 26, self.view.frame.size.height / 2 - 100, 64, 64);
    [self.wallpaperBt setImage:[[UIImage imageNamed:@"BZ.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [self.wallpaperBt addTarget:self action:@selector(wallpaperBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.wallpaperBt];
    //下方文字
    UILabel *wpLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3 -26, self.view.frame.size.height /2 - 30, 100, 20)];
    wpLabel.text = @"更换壁纸";
    wpLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:wpLabel];
    
    
    //粒子动画button
    self.animationBt = [UIButton buttonWithType:UIButtonTypeSystem];
    self.animationBt.frame = CGRectMake(self.view.frame.size.width / 2 +32, self.view.frame.size.height / 2  - 100, 64, 64);
    [self.animationBt setImage:[[UIImage imageNamed:@"DH.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.animationBt addTarget:self action:@selector(animationBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.animationBt];
    //显示粒子效果
    UILabel *animatLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 +32, self.view.frame.size.height / 2 -30, 100, 20)];
    animatLabel.text = @"粒子效果";
    animatLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:animatLabel];
    
    //关于我们
    self.aboutUsBt = [UIButton buttonWithType:UIButtonTypeSystem];
    self.aboutUsBt.frame = CGRectMake(self.view.frame.size.width / 2 + 32, self.view.frame.size.height / 2 + 64, 64, 64);
    [self.aboutUsBt setImage:[[UIImage imageNamed:@"GYWM.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.aboutUsBt addTarget:self action:@selector(aboutUsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.aboutUsBt];
    // 关于我们
    UILabel *useLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 32, self.view.frame.size.height / 2 +130, 100, 20)];
    useLabel.text = @"关于我们";
    useLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:useLabel];
    
    //显示天气
    self.weather = [UIButton buttonWithType:UIButtonTypeSystem];
    self.weather.frame = CGRectMake(self.view.frame.size.width / 3 - 26, self.view.frame.size.height / 2 + 64, 64, 64);
    [self.weather setImage:[[UIImage imageNamed:@"DH.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.weather addTarget:self action:@selector(positionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.weather];
    //选择城市天气
    UILabel *weather = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3 - 40, self.view.frame.size.height / 2 + 130, 130, 20)];
    weather.text = @"选择城市天气";
    weather.textColor = [UIColor whiteColor];
    [self.view addSubview:weather];
    
}
#pragma mark - 关闭返回button 事件
-(void)closeButtonAction:(UIButton *) sender  {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
#pragma mark - 壁纸点击事件
-(void)wallpaperBtAction:(UIButton *)sender {
    
    YXWWallPaperViewController *wallPaperVC = [[YXWWallPaperViewController alloc] init];
    
    [self.navigationController pushViewController:wallPaperVC animated:YES];
    
    
}
#pragma mark - 动画点击开启
-(void)animationBtAction:(UIButton *)sender {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"aaa"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"lizi" object:self.emitter];
        [[NSUserDefaults standardUserDefaults] setObject:self.emitter forKey:@"lizi"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"aaa"];
        [[[TAlertView alloc] initWithTitle:@"" andMessage:@"已开启粒子效果"] show];
        
    } else {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"lizi" object:self.emitter];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"aaa"];
        [[NSUserDefaults standardUserDefaults] setObject:self.emitter forKey:@"lizi"];
        [[[TAlertView alloc] initWithTitle:@"" andMessage:@"已关闭粒子效果"] show];
        
    }
}

#pragma mark -联系我们
-(void)aboutUsAction:(UIButton *)sender {
    
    YXWAboutUsViewController *aboutUsVC = [[YXWAboutUsViewController alloc] init];
    
    [self.navigationController pushViewController:aboutUsVC animated:YES];
    
}

#pragma mark - 定位
-(void)creatMap {

    _lacationManager = [[CLLocationManager alloc] init];
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_lacationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
    _lacationManager.delegate = self;
    [_lacationManager startUpdatingLocation];
    }
}
#pragma mark -定位
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSString *strLat = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.latitude];
    NSString *strLng = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.longitude];
    NSLog(@"Lat: %@  Lng: %@", strLat, strLng);
    self.geocoder = [[CLGeocoder alloc] init];
    [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        self.str = [NSMutableString stringWithString:placemark.locality];
        NSLog(@"位置 = %@", self.str);
    }];
    [_lacationManager stopUpdatingLocation];
}


#pragma mark - 当前位置点击
-(void)positionAction:(UIButton *)sender {
    NSLog(@"zzzz%@",self.str);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"当前城市为:" message:self.str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.str) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"city" object:self.str];
            [[NSUserDefaults standardUserDefaults] setObject:self.str forKey:@"city"];
        }
       
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }];
    
    [alertController addAction:determine];

    [self presentViewController:alertController animated:YES  completion:nil];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
