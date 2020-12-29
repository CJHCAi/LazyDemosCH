//
//  HKConfirmationOfOrderRespone.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseModelRespone.h"
@class HKConfirmationOfOrderData;
@interface HKConfirmationOfOrderRespone : HKBaseModelRespone
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, strong)HKConfirmationOfOrderData *data;
@end
