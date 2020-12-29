//
//Created by ESJsonFormatForMac on 18/08/31.
//

#import <Foundation/Foundation.h>

@class HKSellerorderListData,HKSellerorderModel,SubModel;
@interface HKSellerorderListRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKSellerorderListData *data;

@property (nonatomic, copy) NSString* code;

@end
@interface HKSellerorderListData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKSellerorderModel *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKSellerorderModel : NSObject

@property (nonatomic, copy) NSString *consignee;

@property (nonatomic, strong) NSArray<SubModel *> *subList;

@property (nonatomic, copy) NSString *afterState;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *orderNumber;

@end

@interface SubModel : NSObject

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *activityPrice;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *colorName;

@property (nonatomic, copy) NSString *activityType;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *specName;

@property (nonatomic, copy) NSString *limitTime;

@property (nonatomic, copy) NSString *currentTime;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, assign) double integral;;

@property (nonatomic, copy) NSString *mediaUserId;

@property (nonatomic, copy) NSString *orderNumber;

@property (nonatomic, copy) NSString *skuId;

@end

