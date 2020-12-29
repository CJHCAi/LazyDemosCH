//
//Created by ESJsonFormatForMac on 18/09/17.
//

#import <Foundation/Foundation.h>

@class HK_jobList,HK_jobData;
@interface HK_jobRecResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HK_jobList *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HK_jobList : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HK_jobData *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HK_jobData : NSObject

@property (nonatomic, copy) NSString *experience;

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *salaryName;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *salary;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *educationName;

@property (nonatomic, copy) NSString *areaName;

@property (nonatomic, copy) NSString *experienceName;

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *recruitId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *headImg;

@end

