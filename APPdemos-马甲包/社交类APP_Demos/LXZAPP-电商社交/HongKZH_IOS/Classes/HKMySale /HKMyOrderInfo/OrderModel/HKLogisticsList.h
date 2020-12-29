//
//  HKLogisticsList.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKLogisticsInfoModel;
@interface HKLogisticsList : NSObject
@property (nonatomic, copy)NSString *message;
@property (nonatomic,assign) int status;
@property(nonatomic, assign) int state;
@property (nonatomic, strong)NSArray<HKLogisticsInfoModel*> *data;
@end
