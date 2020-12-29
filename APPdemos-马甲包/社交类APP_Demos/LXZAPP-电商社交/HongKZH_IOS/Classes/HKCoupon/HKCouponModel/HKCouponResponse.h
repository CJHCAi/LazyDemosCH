//
//Created by ESJsonFormatForMac on 18/09/28.
//

#import <Foundation/Foundation.h>

@class HKCounData,HKCounList;
@interface HKCouponResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKCounData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKCounData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKCounList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKCounList : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, assign) NSInteger pintegral;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger discount;

@property (nonatomic, assign) double integral;;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, copy) NSString *couponId;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy)NSString *beginTime;
@property (nonatomic, copy)NSString *endTime;
@end

