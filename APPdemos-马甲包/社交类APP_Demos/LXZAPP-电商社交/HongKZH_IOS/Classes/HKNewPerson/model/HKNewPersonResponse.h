//
//Created by ESJsonFormatForMac on 18/10/10.
//

#import <Foundation/Foundation.h>

@class HKNewPersonData,HKNewPersonList;
@interface HKNewPersonResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKNewPersonData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKNewPersonData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKNewPersonList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKNewPersonList : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *vipCouponId;

@property (nonatomic, assign) NSInteger activityStocks;

@property (nonatomic, assign) NSInteger pintegral;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger discount;

@property (nonatomic, assign) double integral;;

@property (nonatomic, assign) NSInteger lastStocks;

@end

