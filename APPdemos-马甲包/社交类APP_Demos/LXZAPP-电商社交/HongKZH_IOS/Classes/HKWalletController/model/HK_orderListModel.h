//
//Created by ESJsonFormatForMac on 18/08/27.
//

#import <Foundation/Foundation.h>

@class OrderData,OrderList,Sublist;
@interface HK_orderListModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) OrderData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface OrderData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<OrderList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface OrderList : NSObject

@property (nonatomic, copy) NSString *consignee;

@property (nonatomic, strong) NSArray<Sublist *> *subList;

@property (nonatomic, copy) NSString *confirmDate;

@property (nonatomic, copy) NSString *orderNumber;

@end

@interface Sublist : NSObject

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

