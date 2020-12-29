//
//Created by ESJsonFormatForMac on 18/10/10.
//

#import <Foundation/Foundation.h>

@class HKDisCutData,HKDisCutRecord,HKDisCutList;
@interface HKDisCutResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKDisCutData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKDisCutData : NSObject

@property (nonatomic, assign) NSInteger beginDate;

@property (nonatomic, strong) HKDisCutRecord *records;

@property (nonatomic, assign) NSInteger sortDate;

@property (nonatomic, assign) NSInteger endDate;

@property (nonatomic, assign) NSInteger currentHour;

@property (nonatomic, copy) NSString *currentTime;

@end

@interface HKDisCutRecord : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKDisCutList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKDisCutList : NSObject

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) NSInteger activityPrice;

@property (nonatomic, assign) CGFloat discount;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, assign) NSInteger currentHour;

@property (nonatomic, copy) NSString *people;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, assign) NSInteger endDate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *currentTime;

@property (nonatomic, assign) double integral;;

@property (nonatomic, assign) NSInteger beginDate;

@end

