//
//  HKBurstingActivityShareModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKRLShareSendModel.h"
#define BKRCLocalMessageTypeIdentifier @"hkzh:burstingshare"
@interface HKBurstingActivityShareModel : HKRLShareSendModel
@property (nonatomic, copy)NSString *discount;//折扣
@property (nonatomic, copy)NSString *pintegral;//乐币
@property (nonatomic, copy)NSString *orderNumber;//订单号
@end
