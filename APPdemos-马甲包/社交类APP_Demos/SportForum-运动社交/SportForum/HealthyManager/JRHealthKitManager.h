//
//  JRHealthKitManager.h
//  Fit
//
//  Created by Jaben on 14-12-12.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JRWeight_Unit) {
    JRWeight_Unit_kg = 0,
    JRWeight_Unit_pount,
    JRWeight_Unit_st,
};

typedef NS_ENUM(NSInteger, JRPressure_Unit) {
    JRPressure_Unit_mmHg = 0,
    JRPressure_Unit_Pa,
};

typedef NS_ENUM(NSInteger, JRPressure_Type) {
    JRPressure_Type_Systolic = 0,
    JRPressure_Type_Diastolic,
};

typedef NS_ENUM(NSInteger, JRLength_Unit) {
    JRLength_Unit_km = 0,
    JRLength_Unit_m,
    JRLength_Unit_ft,
};

typedef NS_ENUM(NSInteger, JRAuthorize_Type) {
    JRAuthorize_Type_Weight = 0,
    JRAuthorize_Type_Pressure,
    JRAuthorize_Type_Activity,
};

typedef void(^JRBooleanResultBlock)(BOOL success, NSError *error);

@import UIKit;
@import HealthKit;

@interface JRHealthKitManager : NSObject

+ (instancetype)shareManager;

- (BOOL)isHealthKitAvailable;

- (BOOL)isAuthorization;

/*======================================================
 Authorize
 /======================================================*/
- (void)getReadAndWriteAuthorizeWithCompleted:(JRBooleanResultBlock)completed;
- (void)getReadAndWriteAuthorize:(NSArray *)authorizeTypes withCompleted:(JRBooleanResultBlock)completed;

/*======================================================
 height
 /======================================================*/

- (void)saveHeight:(double)height unit:(JRLength_Unit)unit date:(NSDate *)date;
- (void)saveHeights:(NSArray *)array unit:(JRLength_Unit)unit;

/*======================================================
 weight
 /======================================================*/
- (void)saveLifesenseWeight:(NSDictionary *)weightDic;

- (void)saveWeight:(double)weight unit:(JRWeight_Unit)unit date:(NSDate *)date;
- (void)saveWeights:(NSArray *)array unit:(JRWeight_Unit)unit;

- (void)fetchWeightsFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed;
- (void)fetchFatPercentsFromDate:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed;
- (void)fetchBmisFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed;

- (void)deleteLifesenseWeightFromDate:(NSDate *)beginDate toDate:(NSDate *)endDate;

/*distance*/
- (void)fetchDistancesFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed;

/*statistics distance*/
- (void)fetchSumDistancesFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples, NSError *error))completed;

/*======================================================
 fat percent
 /======================================================*/
- (void)saveFatPercent:(double)fatPercent date:(NSDate *)date;
- (void)saveFatPercents:(NSArray *)array date:(NSDate *)date;

/*======================================================
 pressure
 /======================================================*/
- (void)saveLifesensePressure:(NSDictionary *)pressureDic;

- (void)saveLifesensePressures:(NSArray *)array unit:(JRPressure_Unit)pressureUnit;
- (void)savePressure:(double)value date:(NSDate *)date unit:(JRPressure_Unit)pressureUnit type:(JRPressure_Type)type;
- (void)savePressures:(NSArray *)array date:(NSDate *)date unit:(JRPressure_Unit)pressureUnit type:(JRPressure_Type)type;

- (void)fetchDiaPressureFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed;
- (void)fetchSysPressureFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed;
- (void)fetchHeartRateFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed;

- (void)deleteLifesensePressureFromDate:(NSDate *)beginDate toDate:(NSDate *)endDate;


/*======================================================
 activity
 /======================================================*/
- (void)saveLifesenseActivity:(NSDictionary *)activityDic;
- (void)deletedLifesenseActivityFromDate:(NSDate *)beginDate toDate:(NSDate *)endDate;
@end
