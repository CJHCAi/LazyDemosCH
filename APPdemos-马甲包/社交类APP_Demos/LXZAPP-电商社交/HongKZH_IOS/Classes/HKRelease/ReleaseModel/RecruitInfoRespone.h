//
//Created by ESJsonFormatForMac on 18/09/19.
//

#import <Foundation/Foundation.h>

@class RecruitInfoDatas;
@interface RecruitInfoRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) RecruitInfoDatas *data;

@property (nonatomic, copy)NSString *code;
@property (nonatomic,assign) BOOL responeSuc;
@end
@interface RecruitInfoDatas : NSObject

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *areaName;

@property (nonatomic, copy) NSString *natureName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *stateName;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *isAuth;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *industry;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *salary;

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *nature;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *experienceName;

@property (nonatomic, copy) NSString *recruitId;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *enterpriseId;

@property (nonatomic, copy) NSString *salaryName;

@property (nonatomic, copy) NSString *educationName;

@property (nonatomic, copy) NSString *industryName;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *experience;

@property (nonatomic, copy) NSString *cityAreaName;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *introduce;

@end

