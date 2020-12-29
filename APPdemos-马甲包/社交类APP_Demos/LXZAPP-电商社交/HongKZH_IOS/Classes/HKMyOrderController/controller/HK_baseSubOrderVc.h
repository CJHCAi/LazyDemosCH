//
//  HK_baseSubOrderVc.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

typedef enum {
    HK_orderAll=0, //全部订单
    HK_orderWait=1, //等待付款
    HK_orderReceived=3,//等待收货
    HK_orderFinished=7,//已完成
    HK_orderCanceled=8 //已取消
} TradeShopType;

@interface HK_baseSubOrderVc : HK_BaseView

@property (nonatomic, copy)NSString * tradeString;

@end
