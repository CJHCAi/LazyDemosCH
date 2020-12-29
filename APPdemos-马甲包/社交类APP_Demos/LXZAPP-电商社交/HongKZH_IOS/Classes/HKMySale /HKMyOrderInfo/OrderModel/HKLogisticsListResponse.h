//
//  HKLogisticsListResponse.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKLogisticsList;
@interface HKLogisticsListResponse : NSObject
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, copy)NSString *code;
@property (nonatomic, strong)HKLogisticsList *data;
@property (nonatomic,assign) BOOL responeSuc;
@end
