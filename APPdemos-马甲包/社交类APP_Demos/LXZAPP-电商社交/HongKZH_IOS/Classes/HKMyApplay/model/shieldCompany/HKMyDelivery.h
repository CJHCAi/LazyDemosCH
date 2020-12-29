//
//Created by ESJsonFormatForMac on 18/08/15.
//

#import <Foundation/Foundation.h>

@class HKMyDeliveryData,HKMyDeliveryList,HKMyDeliveryLogs;

@interface HKMyDelivery : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKMyDeliveryData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKMyDeliveryData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKMyDeliveryList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKMyDeliveryList : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *salaryName;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *salary;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *stateName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *educationName;

@property (nonatomic, strong) NSArray<HKMyDeliveryLogs *> *logs;

@property (nonatomic, copy) NSString *areaName;

@property (nonatomic, copy) NSString *deliveryId;

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *experienceName;

@property (nonatomic, copy) NSString *recruitId;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *experience;

@end

@interface HKMyDeliveryLogs : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, assign) NSInteger lineStyle; //1--首个 2--中间 3--最后一个

@end

