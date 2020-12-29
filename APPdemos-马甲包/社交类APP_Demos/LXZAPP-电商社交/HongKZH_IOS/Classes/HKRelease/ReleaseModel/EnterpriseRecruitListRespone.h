//
//Created by ESJsonFormatForMac on 18/09/19.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class EnterpriseRecruitDatas,EnterpriseRecruitModel;
@interface EnterpriseRecruitListRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) EnterpriseRecruitDatas *data;


@end
@interface EnterpriseRecruitDatas : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *scale;

@property (nonatomic, copy) NSString *industry;

@property (nonatomic, copy) NSString *enterpriseId;

@property (nonatomic, copy) NSString *industryName;

@property (nonatomic, copy) NSString *isAuth;

@property (nonatomic, copy) NSString *scaleName;

@property (nonatomic, copy) NSString *stage;

@property (nonatomic, strong) NSArray<EnterpriseRecruitModel *> *recruits;

@property (nonatomic, copy) NSString *stageName;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *introduce;

@end

@interface EnterpriseRecruitModel : NSObject

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *salaryName;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *salary;

@property (nonatomic, copy) NSString *stateName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *educationName;

@property (nonatomic, copy) NSString *areaName;

@property (nonatomic, copy) NSString *experienceName;

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *recruitId;

@property (nonatomic, copy) NSString *experience;

@end

