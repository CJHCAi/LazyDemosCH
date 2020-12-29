//
//  HK_UserDeliveryAddressListModel.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseModel.h"

@interface HK_UserDeliveryAddressListModel : BaseModel
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

- (NSString *)fullAddress;
@end
