//
//  AppDelegate.m
//  Douban-today
//
//  Created by dzw on 2018/10/26.
//  Copyright © 2018 dzw. All rights reserved.
//
#import "AppDelegate.h"
#import "MainTabbarViewController.h"


@interface AppDelegate ()<CLLocationManagerDelegate>

@end

@implementation AppDelegate{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLAuthorizationStatus localStatus;
    BOOL needRefreshLocation;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    MainTabbarViewController *tabbar = [MainTabbarViewController new];
    [DzwSingleton sharedInstance].tabBarVC = tabbar;
    self.window.rootViewController = [DzwSingleton sharedInstance].tabBarVC;
    [self.window makeKeyAndVisible];
    return YES;
}

//定位
- (void)getLocationInfo{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    
    if (status==kCLAuthorizationStatusAuthorizedAlways || status==kCLAuthorizationStatusAuthorizedWhenInUse || status==kCLAuthorizationStatusNotDetermined) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.activityType = CLActivityTypeOther;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLLocationAccuracyKilometer;
        
    }
    
    if (status == kCLAuthorizationStatusNotDetermined ||status == 0) {
        
        
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
        
    }
    [locationManager startUpdatingLocation];
}

#pragma mark -- CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied){
        currentLocation = [[CLLocation alloc] initWithLatitude:0.000000 longitude:0.000000];
        return;
    }
    
    if (localStatus != status && status == kCLAuthorizationStatusAuthorizedWhenInUse) {
    }else{
        localStatus = status;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [manager stopUpdatingLocation];
    
    if (!needRefreshLocation) {
        return;
    }
    currentLocation = [locations lastObject];
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    [clGeoCoder reverseGeocodeLocation:currentLocation completionHandler: ^(NSArray *placemarks,NSError *error) {
        for (CLPlacemark *placeMark in placemarks) {
            [DzwSingleton sharedInstance].currentCity = placeMark.locality;
        }
    }];
    needRefreshLocation = NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
