//
//Created by ESJsonFormatForMac on 18/08/18.
//

#import <Foundation/Foundation.h>

@class HKRecruitOffLineData;
@interface HKRecruitOffLineList : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<HKRecruitOffLineData *> *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKRecruitOffLineData : NSObject

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *salary;

@property (nonatomic, copy) NSString *educationName;

@property (nonatomic, copy) NSString *salaryName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *recruitId;

@property (nonatomic, copy) NSString *experience;

@property (nonatomic, copy) NSString *experienceName;

@property (nonatomic, copy) NSString *areaName;

@end

