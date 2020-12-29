//
//Created by ESJsonFormatForMac on 18/08/27.
//

#import <Foundation/Foundation.h>

@class Hk_shopOrder,HK_shopOrderList,Hk_subOrderList;
@interface Hk_MyOrderDataModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) Hk_shopOrder *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface Hk_shopOrder : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HK_shopOrderList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HK_shopOrderList : NSObject
//支付截止时间
@property (nonatomic, copy) NSString *limitTime;

@property (nonatomic, strong) NSMutableArray<Hk_subOrderList *> *subList;
//当前时间
@property (nonatomic, copy) NSString *currentTime;

@property (nonatomic, copy) NSString *orderNumber;

@property (nonatomic, copy) NSString *mediaUserId;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, assign) double integral;;

@property (nonatomic, assign) NSInteger freightIntegral;

@property (nonatomic, copy) NSString *name;

#pragma mark 我的订单列表改版新增加参数
//******** ***********//
@property (nonatomic, copy) NSString *shopId;

@end

@interface Hk_subOrderList : NSObject

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

#pragma mark 我的订单列表改版新增加参数
@property (nonatomic, assign)NSInteger price;
@property (nonatomic, assign)NSInteger discount;
@end

