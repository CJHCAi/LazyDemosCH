//
//Created by ESJsonFormatForMac on 18/09/18.
//

#import <Foundation/Foundation.h>

@class HK_positionData;
@interface HK_RecriutPosition : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<HK_positionData *> *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HK_positionData : NSObject

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *enterpriseId;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *natureName;

@property (nonatomic, copy) NSString *salaryName;

@property (nonatomic, copy) NSString *salary;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *nature;

@property (nonatomic, copy) NSString *educationName;

@property (nonatomic, copy) NSString *areaName;

@property (nonatomic, copy) NSString *experienceName;

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *recruitId;

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, copy) NSString *experience;

@end

