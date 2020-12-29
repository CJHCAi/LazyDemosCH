//
//Created by ESJsonFormatForMac on 18/08/18.
//

#import <Foundation/Foundation.h>

@class HKRecruitOnlineData;
@interface HKRecruitOnlineList : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<HKRecruitOnlineData *> *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKRecruitOnlineData : NSObject

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *salaryName;

@property (nonatomic, copy) NSString *salary;

@property (nonatomic, assign) NSInteger candidate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *educationName;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *areaName;

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *experienceName;

@property (nonatomic, copy) NSString *recruitId;

@property (nonatomic, copy) NSString *experience;

@property (nonatomic, copy) NSString *updateTime;

@end

