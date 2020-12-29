//
//  HKConfirmationOfOrderData.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKConfirmationOfOrderData.h"

@implementation HKConfirmationOfOrderData
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [getCartListData class]};
}
@end
