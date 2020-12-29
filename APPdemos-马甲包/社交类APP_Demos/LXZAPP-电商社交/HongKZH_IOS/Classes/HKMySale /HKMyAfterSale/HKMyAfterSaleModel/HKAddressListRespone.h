//
//Created by ESJsonFormatForMac on 18/09/05.
//

#import <Foundation/Foundation.h>

@class HKAddressModel;
@interface HKAddressListRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<HKAddressModel *> *data;

@property (nonatomic, copy) NSString* code;
@property (nonatomic,assign) BOOL responeSuc;
@end
@interface HKAddressModel : NSObject

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

