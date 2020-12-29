//
//  HK_orderDetailVc.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "Hk_MyOrderDataModel.h"

/** 确认收货*/
typedef void(^ComfirmGoodsBlock)(void);
/**取消订单*/
typedef void(^CancelOrderBlock)(void);

@interface HK_orderDetailVc : HK_BaseView

@property (nonatomic, strong)Hk_subOrderList *listModel;

@property (nonatomic, strong)ComfirmGoodsBlock comfirmBlock;

@property (nonatomic, strong)CancelOrderBlock cancelBlock;

@end
