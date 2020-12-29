//
//Created by ESJsonFormatForMac on 18/09/01.
//

#import <Foundation/Foundation.h>

@class HKOrderInfoData,AddressModel,SubModellist;
@interface HKOrderFromInfoRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKOrderInfoData *data;

@property (nonatomic, copy) NSString* code;

@end
@interface HKOrderInfoData : NSObject

@property (nonatomic, copy) NSString *payTime;

@property (nonatomic, copy) NSString *sellTime;

@property (nonatomic, assign) double freightIntegral;

@property (nonatomic, copy) NSString *consignee;

@property (nonatomic, assign) double productIntegral;

@property (nonatomic, copy) NSString *orderNumber;

@property (nonatomic, copy) NSString *courierNumber;

@property (nonatomic, copy) NSString *payType;

@property (nonatomic, copy) NSString *afterState;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *currentTime;

@property (nonatomic, copy) NSString *limitTime;

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<SubModellist *> *subList;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, strong) NSArray *afterList;

@property (nonatomic, copy) NSString *courier;

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *provinceId;

@property (nonatomic, copy) NSString *deliverTime;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *confirmDate;

@property (nonatomic, copy) NSString *addressId;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *mediaUserId;

@property (nonatomic, strong) AddressModel *address;

@property (nonatomic, assign) double integral;;

@property (nonatomic,assign) CGFloat h;
@end

@interface AddressModel : NSObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *consignee;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *provinceId;

@property (nonatomic, copy) NSString *isDefault;

@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy)NSString *loginUid;
@end

@interface SubModellist : NSObject

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

