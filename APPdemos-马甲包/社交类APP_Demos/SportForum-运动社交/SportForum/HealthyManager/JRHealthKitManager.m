//
//  JRHealthKitManager.m
//  Fit
//
//  Created by Jaben on 14-12-12.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JRHealthKitManager.h"

//@import HealthKit;
#import <HealthKit/HealthKit.h>

@interface JRHealthKitManager ()
@property (nonatomic, strong) HKHealthStore *healthStore;
@end

@implementation JRHealthKitManager

+ (instancetype)shareManager {
    static JRHealthKitManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager =[[JRHealthKitManager alloc] init];
    });
    return shareManager;
}

- (instancetype)init {
    
    @synchronized(self) {
        if (self = [super init]) {
            
            _healthStore = [[HKHealthStore alloc] init];
            
            return self;
        }
    }
    return nil;
}


- (BOOL)isHealthKitAvailable {
    return [HKHealthStore isHealthDataAvailable];
}

- (BOOL)isAuthorization {
    HKQuantityType *walkRunningType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    return (HKAuthorizationStatusSharingAuthorized == [_healthStore authorizationStatusForType:walkRunningType]);
}

#pragma mark --Create Sample

- (HKQuantitySample *)createBMI:(double)bmi date:(NSDate *)date {
    
    HKUnit *bmiUnit = [HKUnit countUnit];
    HKQuantity *bmiQuantity = [HKQuantity quantityWithUnit:bmiUnit doubleValue:bmi];
    HKQuantityType *bmiType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    HKQuantitySample *bmiSample = [HKQuantitySample quantitySampleWithType:bmiType quantity:bmiQuantity startDate:date endDate:date];
    
    return bmiSample;
}

- (HKQuantitySample *)createWeightSample:(double)weight unit:(JRWeight_Unit)unit date:(NSDate *)date {
    
    HKUnit *weightUnit;
    
    switch (unit) {
        case JRWeight_Unit_kg:
            weightUnit = [HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo];
            break;
        case JRWeight_Unit_pount:
            weightUnit = [HKUnit poundUnit];
            break;
        case JRWeight_Unit_st:
            weightUnit = [HKUnit stoneUnit];
            break;
        default:
            weightUnit = [HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo];
            break;
    }

    
    HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:weightUnit doubleValue:weight];
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:weightType quantity:weightQuantity startDate:date endDate:date];
    
    return weightSample;
}

- (HKQuantitySample *)createFatPercentSample:(double)fatPercent date:(NSDate *)date {
    
    HKUnit *fatPercentUnit = [HKUnit percentUnit];
    HKQuantity *fatPercentQuantity = [HKQuantity quantityWithUnit:fatPercentUnit doubleValue:fatPercent];
    HKQuantityType *fatPercentType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage];
    HKQuantitySample *fatPercentSample = [HKQuantitySample quantitySampleWithType:fatPercentType quantity:fatPercentQuantity startDate:date endDate:date];
    
    return fatPercentSample;
}

- (HKQuantitySample *)createPressureSample:(double)value date:(NSDate *)date unit:(JRPressure_Unit)pressureUnit type:(JRPressure_Type)type{
    
    HKUnit *unit = (pressureUnit == JRPressure_Unit_mmHg)?[HKUnit millimeterOfMercuryUnit]:[HKUnit pascalUnit];
    
    HKQuantity *pressureQuantity = [HKQuantity quantityWithUnit:unit doubleValue:value];
    
    HKQuantityType *pressureType = (type == JRPressure_Type_Diastolic)?[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic]:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    
    HKQuantitySample *pressureSample = [HKQuantitySample quantitySampleWithType:pressureType quantity:pressureQuantity startDate:date endDate:date];
    
    return pressureSample;
}

- (HKQuantitySample *)createHeartRateSample:(double)value date:(NSDate *)date {
    
    HKUnit *unit = [HKUnit unitFromString:@"count/min"];
    HKQuantity *rateQuantity = [HKQuantity quantityWithUnit:unit doubleValue:value];
    HKQuantityType *rateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    HKQuantitySample *rateSample = [HKQuantitySample quantitySampleWithType:rateType quantity:rateQuantity startDate:date endDate:date];
    
    return rateSample;
}

- (HKQuantitySample *)createActivityStepSample:(double)value date:(NSDate *)date {
    
    HKUnit *unit = [HKUnit countUnit];
    HKQuantity *stepQuantity = [HKQuantity quantityWithUnit:unit doubleValue:value];
    HKQuantityType *stepType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantitySample *stepSample = [HKQuantitySample quantitySampleWithType:stepType quantity:stepQuantity startDate:date endDate:date];
    
    return stepSample;
}


- (HKQuantitySample *)createActivityDistanceSample:(double)value date:(NSDate *)date unit:(JRLength_Unit)distanceUnit{
    
    HKUnit *unit;
    
    switch (distanceUnit) {
        case JRLength_Unit_km:
            unit = [HKUnit meterUnitWithMetricPrefix:HKMetricPrefixKilo];
            break;
        case JRLength_Unit_m:
            unit = [HKUnit meterUnit];
            break;
        case JRLength_Unit_ft:
            unit = [HKUnit footUnit];
            break;
        default:
            unit = [HKUnit meterUnit];
            break;
    }

    
    HKQuantity *distanceQuantity = [HKQuantity quantityWithUnit:unit doubleValue:value];
    HKQuantityType *distanceType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKQuantitySample *distanceSample = [HKQuantitySample quantitySampleWithType:distanceType quantity:distanceQuantity startDate:date endDate:date];
    
    return distanceSample;
}

- (HKQuantitySample *)createActivityCalorieSample:(double)value date:(NSDate *)date {
    
    HKUnit *calorieUnit = [HKUnit kilocalorieUnit];
    HKQuantity *calorieQuantity = [HKQuantity quantityWithUnit:calorieUnit doubleValue:value];
    HKQuantityType *calorieQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantitySample *calorieSample = [HKQuantitySample quantitySampleWithType:calorieQuantityType quantity:calorieQuantity startDate:date endDate:date];
    
    return calorieSample;
}

- (HKQuantitySample *)createHeightSample:(double)value unit:(JRLength_Unit)heightUnit date:(NSDate *)date {
    HKUnit *unit;
    
    switch (heightUnit) {
        case JRLength_Unit_km:
            unit = [HKUnit meterUnitWithMetricPrefix:HKMetricPrefixKilo];
            break;
        case JRLength_Unit_m:
            unit = [HKUnit meterUnit];
            break;
        case JRLength_Unit_ft:
            unit = [HKUnit footUnit];
            break;
        default:
            unit = [HKUnit meterUnit];
            break;
    }
    
    HKQuantity *heightQuantity = [HKQuantity quantityWithUnit:unit doubleValue:value];
    HKQuantityType *heightQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantitySample *heightSample = [HKQuantitySample quantitySampleWithType:heightQuantityType quantity:heightQuantity startDate:date endDate:date];
    
    return heightSample;
}



#pragma mark --Height

- (void)saveHeight:(double)height unit:(JRLength_Unit)unit date:(NSDate *)date {
    HKQuantitySample *heightSample = [self createHeightSample:height unit:unit date:date];
    [self healthStoreSaveObject:heightSample withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

- (void)saveHeights:(NSArray *)array unit:(JRLength_Unit)unit {
    NSMutableArray *heightSamples = [NSMutableArray array];
    /*
     heightDic -> @{@"height":height(m),@"unit":0,@"date":date};
     */
    for(NSDictionary *heightDic in array) {
        double height = [heightDic[@"height"] doubleValue];
        NSDate *date = heightDic[@"date"];
        
        HKQuantitySample *heightSample = [self createHeightSample:height unit:unit date:date];
        [heightSamples addObject:heightSample];
    }
    
    [self healthStoreSaveObjects:heightSamples withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

#pragma mark --Weight

- (void)saveLifesenseWeight:(NSDictionary *)weightDic {
    /*
     weightDid -> @{@"weight":weight(kg),@"unit":0,@"fat":fat%,@"bmi":bmi,@"date":date};
     */
    double weight = [weightDic[@"weight"] doubleValue];
    int weightUnit = [weightDic[@"unit"] intValue];
    double fat = [weightDic[@"fat"] doubleValue];
    double bmi = [weightDic[@"bmi"] doubleValue];
    NSDate *date = weightDic[@"date"];
    
    HKQuantitySample *weightSample = [self createWeightSample:weight unit:weightUnit date:date];
    HKQuantitySample *fatPercentSample = [self createFatPercentSample:fat date:date];
    HKQuantitySample *bmiSample = [self createBMI:bmi date:date];
    
    [self healthStoreSaveObjects:@[weightSample,fatPercentSample,bmiSample] withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

/*======================================================
 Weight
 /======================================================*/

- (void)saveWeight:(double)weight unit:(JRWeight_Unit)unit date:(NSDate *)date {
    
    HKQuantitySample *weightSample = [self createWeightSample:weight unit:unit date:date];
    
    [self healthStoreSaveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

- (void)saveWeights:(NSArray *)array unit:(JRWeight_Unit)unit {
    
    /*
     array->@[ @{@"value":value,@"date":date},@{},... ]
     */
    
    NSMutableArray *weightSamples = [NSMutableArray array];
    
    for(NSDictionary *weightDic in array) {
        double weightValue = [weightDic[@"value"] doubleValue];
        NSDate *weightDate = weightDic[@"date"];
        HKQuantitySample *weightSample = [self createWeightSample:weightValue unit:unit date:weightDate];
        [weightSamples addObject:weightSample];
    }
    
    [self healthStoreSaveObjects:weightSamples withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

- (void)fetchWeightsFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed {
    
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    [self fetchType:weightType from:beginDate toDate:endDate completed:completed];
}

/*======================================================
 Fat percent
 /======================================================*/

- (void)saveFatPercent:(double)fatPercent date:(NSDate *)date {
    
    HKQuantitySample *fatPercentSample = [self createFatPercentSample:fatPercent date:date];
    
    [self healthStoreSaveObject:fatPercentSample withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

- (void)saveFatPercents:(NSArray *)array date:(NSDate *)date {
    /*
     array->@[ @{@"value":value,@"date":date},@{},... ]
     */
    
    NSMutableArray *fatPercents = [NSMutableArray array];
    
    for(NSDictionary *fatDic in array) {
        double fatValue = [fatDic[@"value"] doubleValue];
        NSDate *fatDate = fatDic[@"date"];
        HKQuantitySample *fatPercentSample = [self createFatPercentSample:fatValue date:fatDate];
        [fatPercents addObject:fatPercentSample];
    }
    
    [self healthStoreSaveObjects:fatPercents withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

- (void)fetchFatPercentsFromDate:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed {
    
    HKQuantityType *fatType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage];
    [self fetchType:fatType from:beginDate toDate:endDate completed:completed];
}

- (void)fetchBmisFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed {
    
    HKQuantityType *bmiType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    [self fetchType:bmiType from:beginDate toDate:endDate completed:completed];
}

- (void)deleteLifesenseWeightFromDate:(NSDate *)beginDate toDate:(NSDate *)endDate {
    
    [self fetchWeightsFrom:beginDate toDate:endDate completed:^(NSArray *samples, NSError *error) {
        if (!error) {
            if (samples.count >0) {
                [self.healthStore deleteObject:samples[0] withCompletion:^(BOOL success, NSError *error) {
                    
                }];
            }
        }
    }];
    
    [self fetchFatPercentsFromDate:beginDate toDate:endDate completed:^(NSArray *samples, NSError *error) {
        if (!error) {
            if (samples.count >0) {
                [self.healthStore deleteObject:samples[0] withCompletion:^(BOOL success, NSError *error) {
                    
                }];
            }
        }
    }];
    
    [self fetchBmisFrom:beginDate toDate:endDate completed:^(NSArray *samples, NSError *error) {
        if (!error) {
            if (samples.count >0) {
                [self.healthStore deleteObject:samples[0] withCompletion:^(BOOL success, NSError *error) {
                    
                }];
            }
        }
    }];
}

#pragma mark --Pressure

- (void)saveLifesensePressure:(NSDictionary *)pressureDic {
    /*
     pressureDic ->@{@"diaValue":diaValue, @"sysValue":sysValue,@"unit":0,@"heartRate":80,@"date",date};
     */
    double diaValue = [pressureDic[@"diaValue"] doubleValue];
    double sysValue = [pressureDic[@"sysValue"] doubleValue];
    int unit = [pressureDic[@"unit"] intValue];
    double heartRate = [pressureDic[@"heartRate"] doubleValue];
    NSDate *date = pressureDic[@"date"];
    
    HKQuantitySample *diaSample = [self createPressureSample:diaValue date:date unit:unit type:JRPressure_Type_Diastolic];
    HKQuantitySample *sysSample = [self createPressureSample:sysValue date:date unit:unit type:JRPressure_Type_Systolic];
    HKQuantitySample *rateSample = [self createHeartRateSample:heartRate date:date];
    
    [self healthStoreSaveObjects:@[diaSample,sysSample,rateSample] withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

- (void)saveLifesensePressures:(NSArray *)array unit:(JRPressure_Unit)pressureUnit {
    
    NSMutableArray *pressures = [NSMutableArray array];
    
    for(NSDictionary *pressureDic in array) {
        double diaValue = [pressureDic[@"diaValue"] doubleValue];
        double sysValue = [pressureDic[@"sysValue"] doubleValue];
        NSDate *date = pressureDic[@"date"];
        
        HKQuantitySample *diaSample = [self createPressureSample:diaValue date:date unit:pressureUnit type:JRPressure_Type_Diastolic];
        HKQuantitySample *sysSample = [self createPressureSample:sysValue date:date unit:pressureUnit type:JRPressure_Type_Systolic];
        
        [pressures addObject:diaSample];
        [pressures addObject:sysSample];
    }
    
    [self healthStoreSaveObjects:pressures withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

- (void)savePressure:(double)value date:(NSDate *)date unit:(JRPressure_Unit)pressureUnit type:(JRPressure_Type)type{
    
    HKQuantitySample *pressureSample = [self createPressureSample:value date:date unit:pressureUnit type:type];
    [self healthStoreSaveObject:pressureSample withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

- (void)savePressures:(NSArray *)array date:(NSDate *)date unit:(JRPressure_Unit)pressureUnit type:(JRPressure_Type)type {
    /*
     array->@[ @{@"value":value,@"date":date},@{},... ]
     */
    
    NSMutableArray *pressures = [NSMutableArray array];
    
    for(NSDictionary *pressureDic in array) {
        
        double value = [pressureDic[@"value"] doubleValue];
        NSDate *date = pressureDic[@"date"];
        
        HKQuantitySample *pressureSample = [self createPressureSample:value date:date unit:pressureUnit type:type];
        
        [pressures addObject:pressureSample];
    }
    
    [self healthStoreSaveObjects:pressures withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

- (void)fetchDiaPressureFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed {
    HKQuantityType *diaPressureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    [self fetchType:diaPressureType from:beginDate toDate:endDate completed:completed];
}

- (void)fetchSysPressureFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed {
    HKQuantityType *sysPressureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    [self fetchType:sysPressureType from:beginDate toDate:endDate completed:completed];
}

- (void)fetchHeartRateFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed {
    HKQuantityType *ratePressureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    [self fetchType:ratePressureType from:beginDate toDate:endDate completed:completed];
}

- (void)deleteLifesensePressureFromDate:(NSDate *)beginDate toDate:(NSDate *)endDate {
    
    [self fetchDiaPressureFrom:beginDate toDate:endDate completed:^(NSArray *samples, NSError *error) {
        if (samples.count >0) {
            [self.healthStore deleteObject:samples[0] withCompletion:^(BOOL success, NSError *error) {
                
            }];
        }
    }];
    
    [self fetchSysPressureFrom:beginDate toDate:endDate completed:^(NSArray *samples, NSError *error) {
        if (samples.count >0) {
            [self.healthStore deleteObject:samples[0] withCompletion:^(BOOL success, NSError *error) {
                
            }];
        }
    }];
    
    [self fetchHeartRateFrom:beginDate toDate:endDate completed:^(NSArray *samples, NSError *error) {
        if (samples.count >0) {
            [self.healthStore deleteObject:samples[0] withCompletion:^(BOOL success, NSError *error) {
                
            }];
        }
    }];
}

#pragma mark --Height

#pragma mark --Activity

- (void)saveLifesenseActivity:(NSDictionary *)activityDic {
    /*
     pressureDic ->@{@"step":step, @"distance":distance(km),@"unit":0,@"calorie":calorie,@"date",date};
     */
    double steps = [activityDic[@"step"] doubleValue];
    double distance = [activityDic[@"distance"] doubleValue];
    int unit = [activityDic[@"unit"] intValue];
    double calorie = [activityDic[@"calorie"] doubleValue];
    NSDate *date = activityDic[@"date"];
    
    HKQuantitySample *stepSample = [self createActivityStepSample:steps date:date];
    HKQuantitySample *distanceSample = [self createActivityDistanceSample:distance date:date unit:unit];
    HKQuantitySample *calorieSample = [self createActivityCalorieSample:calorie date:date];
    
    [self healthStoreSaveObjects:@[stepSample,distanceSample,calorieSample] withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

- (void)fetchStepsFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed {
    
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    [self fetchType:stepType from:beginDate toDate:endDate completed:completed];
}

- (void)fetchDistancesFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed {
    
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    [self fetchType:distanceType from:beginDate toDate:endDate completed:completed];
}

- (NSPredicate *)predicateFrom:(NSDate *)beginDate toDate:(NSDate *)endDate {
    return [HKQuery predicateForSamplesWithStartDate:beginDate endDate:endDate options:HKQueryOptionStrictStartDate];
}

- (void)fetchSumDistancesFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed
{
    HKQuantityType *RunningType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:beginDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:RunningType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        NSMutableArray * arrData = [[NSMutableArray alloc]init];
        [arrData addObject:result];
        
        /*HKQuantity *sum = [result sumQuantity];
        HKQuantityType *quantityType1 = [result quantityType];
        NSDate *startDate1 = [result startDate];
        NSDate *endDate1 = [result endDate];
        NSArray *sources1 = [result sources];*/
        
        if (completed) {
            completed(arrData, error);
        }
    }];

    [self.healthStore executeQuery:query];
}

- (void)fetchCalorieFrom:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed {
    
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    [self fetchType:stepType from:beginDate toDate:endDate completed:completed];

}

- (void)deletedLifesenseActivityFromDate:(NSDate *)beginDate toDate:(NSDate *)endDate {
    
    [self fetchStepsFrom:beginDate toDate:endDate completed:^(NSArray *samples, NSError *error) {
        if (samples.count >0) {
            [self.healthStore deleteObject:samples[0] withCompletion:^(BOOL success, NSError *error) {
                
            }];
        }
    }];
    
    [self fetchDistancesFrom:beginDate toDate:endDate completed:^(NSArray *samples, NSError *error) {
        if (samples.count >0) {
            [self.healthStore deleteObject:samples[0] withCompletion:^(BOOL success, NSError *error) {
                
            }];
        }
    }];
    
    [self fetchCalorieFrom:beginDate toDate:endDate completed:^(NSArray *samples, NSError *error) {
        if (samples.count >0) {
            [self.healthStore deleteObject:samples[0] withCompletion:^(BOOL success, NSError *error) {
                
            }];
        }
    }];
    
}

- (void)fetchType:(HKQuantityType *)type from:(NSDate *)beginDate toDate:(NSDate *)endDate completed:(void(^)(NSArray *samples,NSError *error))completed {
    
    NSPredicate *stepPredicated = [self predicateFromDate:beginDate toDate:endDate];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    
    [self fetchSamples:type predicate:stepPredicated limited:HKObjectQueryNoLimit sortedDescriptors:@[descriptor] completion:^(NSArray *samples, NSError *error) {
        if (error) {
            completed(nil,error);
        }else {
            completed(samples,nil);
        }
    }];

}

#pragma mark --Authorize

- (void)getReadAndWriteAuthorizeWithCompleted:(JRBooleanResultBlock)completed {
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:[self dataTypesToReadAndWrite] completion:^(BOOL success, NSError *error) {
        completed(success,error);
    }];
}

- (void)getReadAndWriteAuthorize:(NSArray *)authorizeTypes withCompleted:(JRBooleanResultBlock)completed {
    [self.healthStore requestAuthorizationToShareTypes:[self dataTypesToReadAndWrite:authorizeTypes] readTypes:[self dataTypesToReadAndWrite:authorizeTypes] completion:^(BOOL success, NSError *error) {
        completed(success,error);
    }];
}

- (NSSet *)dataTypesToReadAndWrite {
    
    //HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    //HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    //HKQuantityType *fatPercentType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage];
    //HKQuantityType *bmiType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    
    //HKQuantityType *sysPressureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    //HKQuantityType *diaPressureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    HKQuantityType *heartRatePressureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    
    //HKQuantityType *stepsType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    //HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    
    return [NSSet setWithObjects:heartRatePressureType, distanceType,nil];
    
    //return [NSSet setWithObjects:heightType, weightType, fatPercentType, bmiType, sysPressureType, diaPressureType, heartRatePressureType, stepsType, distanceType, activeEnergyBurnType,nil];

}

- (NSSet *)dataTypesToReadAndWrite:(NSArray *)authorizeTypes {
    
    NSMutableSet *authorizeSet = [NSMutableSet set];
    
    for (NSNumber *type in authorizeTypes) {
        switch ([type integerValue]) {
            case JRAuthorize_Type_Weight:{
                HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
                HKQuantityType *fatPercentType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage];
                HKQuantityType *bmiType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
                [authorizeSet addObjectsFromArray:@[weightType,fatPercentType,bmiType]];
            }
                break;
            case JRAuthorize_Type_Pressure:{
                HKQuantityType *sysPressureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
                HKQuantityType *diaPressureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
                HKQuantityType *heartRatePressureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
                [authorizeSet addObjectsFromArray:@[sysPressureType,diaPressureType,heartRatePressureType]];
            }
                break;
            case JRAuthorize_Type_Activity:{
                HKQuantityType *stepsType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
                HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
                HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
                [authorizeSet addObjectsFromArray:@[stepsType,distanceType,activeEnergyBurnType]];
            }
                break;
            default:
                break;
        }
    }
    return authorizeSet;
}


#pragma mark --Save

- (void)healthStoreSaveObject:(HKSample *)sample withCompletion:(JRBooleanResultBlock)completed {
    
    [self.healthStore saveObject:sample withCompletion:^(BOOL success, NSError *error) {
        completed(success, error);
        if (success) {
            NSLog(@"Saving sample successfully");
        }else {
            NSLog(@"Saving sample with error : %@",error);
        }
    }];
}

- (void)healthStoreSaveObjects:(NSArray *)samples withCompletion:(JRBooleanResultBlock)completed {
    [self.healthStore saveObjects:samples withCompletion:^(BOOL success, NSError *error) {
        completed(success, error);
        if (success) {
            NSLog(@"Saving sample successfully");
        }else {
            NSLog(@"Saving sample with error : %@",error);
        }
    }];
}

#pragma mark --Load Data

- (NSPredicate *)predicateFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    return [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone|HKQueryOptionStrictEndDate|HKQueryOptionStrictStartDate];
}

- (void)fetchSamples:(HKSampleType *)sampleType predicate:(NSPredicate *)predicate limited:(NSUInteger)limited sortedDescriptors:(NSArray *)descriptors completion:(void (^)(NSArray *samples, NSError *error))completion {

    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:predicate limit:limited sortDescriptors:descriptors resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (error) {
            completion(nil,error);
        }else {
            completion(results,nil);
        }
    }];
    
    [self.healthStore executeQuery:sampleQuery];
}

@end
