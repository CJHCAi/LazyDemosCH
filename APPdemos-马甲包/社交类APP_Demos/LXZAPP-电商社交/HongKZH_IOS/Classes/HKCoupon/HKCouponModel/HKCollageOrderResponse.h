//
//Created by ESJsonFormatForMac on 18/10/16.
//

#import <Foundation/Foundation.h>

@class HKCollageOrderData,HKCollageList;
@interface HKCollageOrderResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKCollageOrderData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKCollageOrderData : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *orderNumber;

@property (nonatomic, copy) NSString *currentTime;

@property (nonatomic, copy) NSString *beginTime;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger discount;

@property (nonatomic, assign) double integral;;

@property (nonatomic, strong) NSArray<HKCollageList *> *list;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, copy) NSString *createDate;
//订单结束时间 判断是否可以取消订单
@property (nonatomic, copy) NSString *endDate;

@end

@interface HKCollageList : NSObject

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *name;

@end

