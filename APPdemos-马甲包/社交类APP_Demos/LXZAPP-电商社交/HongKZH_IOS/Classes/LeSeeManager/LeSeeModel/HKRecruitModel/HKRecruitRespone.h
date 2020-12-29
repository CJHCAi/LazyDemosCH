//
//Created by ESJsonFormatForMac on 18/09/14.
//

#import <Foundation/Foundation.h>

@class HKRecruitDatas,RecruitDataModel;
@interface HKRecruitRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKRecruitDatas *data;

@property (nonatomic, copy)  NSString*code;
@property (nonatomic,assign) BOOL responeSuc;
@end
@interface HKRecruitDatas : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<RecruitDataModel *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface RecruitDataModel : NSObject

@property (nonatomic, copy) NSString *name;

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

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *experience;

@end

