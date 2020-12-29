//
//  HK_playRefundController.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
typedef enum {
    HK_orderReFund, //申请退款
    Hk_orderRefundAfter //申请售后
 
} UserOrderStatus;


@interface HK_playRefundController : HK_BaseView

@property (nonatomic, copy) NSString *orderNumber;

@property (nonatomic, assign) UserOrderStatus orderStatus;
//1.默认 2修改 --.详情过来是 1  从我的售后过来是2
@property (nonatomic, assign)NSString *types;

@end
