//
//  HK_UserDeliveryAddressListModel.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_UserDeliveryAddressListModel.h"

@implementation HK_UserDeliveryAddressListModel

- (NSString *)fullAddress
{
    NSMutableString *s = [NSMutableString string];
    
    if (![self.provinceName isEmpty]&&self.provinceName.length) {
        
        [s appendString:self.provinceName];
    }
    if (![self.cityName isEmpty] && self.cityName.length) {
        [s appendString:self.cityName];
    }
    if (![self.areaName isEmpty] && self.areaName.length) {
        [s appendString:self.areaName];
    }
    if (![self.address isEmpty] && self.address.length) {
        [s appendString:self.address];
    }
    return s;
}
@end
