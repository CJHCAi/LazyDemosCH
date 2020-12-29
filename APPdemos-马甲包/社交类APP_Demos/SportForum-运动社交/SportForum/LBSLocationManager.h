//
//  LBSLocationManager.h
//  SportForum
//
//  Created by liyuan on 12/17/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define  MMLastLongitude @"MMLastLongitude"
#define  MMLastLatitude  @"MMLastLatitude"
#define  MMLastCity      @"MMLastCity"
#define  MMLastAddress   @"MMLastAddress"

typedef void (^LocationBlock)(CLLocationCoordinate2D locationCorrrdinate, NSString* strDetail, NSString *streetString);
typedef void (^LocationErrorBlock) (NSError *error);
typedef void(^NSStringBlock)(NSString *cityString);
typedef void(^NSStringBlock)(NSString *addressString);

@interface LBSLocationManager : NSObject<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager *locationManager;

@property (nonatomic) CLLocationCoordinate2D lastCoordinate;
@property(nonatomic,strong)NSString *lastCity;
@property (nonatomic,strong) NSString *lastAddress;

@property(nonatomic,assign)float latitude;
@property(nonatomic,assign)float longitude;

+ (LBSLocationManager *)shareLocation;

/**
 *  获取坐标
 *
 *  @param locaiontBlock locaiontBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock ;

/**
 *  获取坐标和地址
 *
 *  @param locaiontBlock locaiontBlock description
 *  @param addressBlock  addressBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock;

/**
 *  获取地址
 *
 *  @param addressBlock addressBlock description
 */
- (void) getAddress:(NSStringBlock)addressBlock;

/**
 *  获取城市
 *
 *  @param cityBlock cityBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock;

/**
 *  获取城市和定位失败
 *
 *  @param cityBlock  cityBlock description
 *  @param errorBlock errorBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock;

@end
