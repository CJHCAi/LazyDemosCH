//
//Created by ESJsonFormatForMac on 18/08/31.
//

#import <Foundation/Foundation.h>

@class addressDataModel;
@interface HK_OrderDeliverModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<addressDataModel *> *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface addressDataModel : NSObject

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

