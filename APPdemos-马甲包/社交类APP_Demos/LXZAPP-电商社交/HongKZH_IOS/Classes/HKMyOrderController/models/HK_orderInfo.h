//
//Created by ESJsonFormatForMac on 18/08/29.
//

#import <Foundation/Foundation.h>

@class HK_orderDetailModel,orderAddressModel,orderSubMitModel;
@interface HK_orderInfo : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HK_orderDetailModel *data;

@property (nonatomic, assign) NSInteger code;

@end
//支付状态信息
@interface HK_orderDetailModel : NSObject

@property (nonatomic, copy) NSString *payTime;

@property (nonatomic, copy) NSString *sellTime;

@property (nonatomic, assign) NSInteger freightIntegral;

@property (nonatomic, copy) NSString *consignee;

@property (nonatomic, assign) NSInteger productIntegral;

@property (nonatomic, copy) NSString *orderNumber;
//快递单号
@property (nonatomic, copy) NSString *courierNumber;

@property (nonatomic, copy) NSString *payType;

@property (nonatomic, copy) NSString *afterState;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *currentTime;

@property (nonatomic, copy) NSString *limitTime;

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<orderSubMitModel *> *subList;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, strong) NSArray *afterList;
//快递公司
@property (nonatomic, copy) NSString *courier;

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *provinceId;

@property (nonatomic, copy) NSString *deliverTime;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *confirmDate;

@property (nonatomic, copy) NSString *addressId;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *mediaUserId;

@property (nonatomic, strong) orderAddressModel *address;

@property (nonatomic, assign) double integral;;

@end

@interface orderAddressModel : NSObject

@property (nonatomic, copy) NSString *consignee;

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *isDefault;

@property (nonatomic, copy) NSString *addressId;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *areaName;

@property (nonatomic, copy) NSString *provinceName;

@property (nonatomic, copy) NSString *provinceId;

@property (nonatomic, copy) NSString *cityId;

@end

@interface orderSubMitModel : NSObject

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

