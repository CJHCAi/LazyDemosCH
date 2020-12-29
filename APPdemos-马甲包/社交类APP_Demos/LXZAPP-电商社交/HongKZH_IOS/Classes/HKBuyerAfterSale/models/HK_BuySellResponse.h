//
//Created by ESJsonFormatForMac on 18/09/05.
//

#import <Foundation/Foundation.h>

@class HK_SaleBaseData,HK_SaleLIstData,HK_SubListSaleData;
@interface HK_BuySellResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HK_SaleBaseData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HK_SaleBaseData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HK_SaleLIstData *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HK_SaleLIstData : NSObject

@property (nonatomic, copy) NSString *consignee;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, strong) NSArray<HK_SubListSaleData *> *subList;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, assign) NSInteger freightIntegral;

@property (nonatomic, copy) NSString *limitTime;

@property (nonatomic, assign) double integral;;

@property (nonatomic, copy) NSString *afterState;

@property (nonatomic, copy) NSString *orderNumber;

@property (nonatomic, copy) NSString *mediaUserId;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *name;

@end

@interface HK_SubListSaleData : NSObject

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

