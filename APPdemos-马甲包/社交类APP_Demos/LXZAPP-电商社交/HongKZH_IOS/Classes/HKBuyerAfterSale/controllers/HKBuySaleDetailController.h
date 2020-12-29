//
//  HKBuySaleDetailController.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHKMyAfterSaleViewController.h"
#import "HK_BuySellResponse.h"

/**取消退款*/
typedef void(^CancelOrderBlock)(void);

@interface HKBuySaleDetailController : HK_BaseView<HKAfterBaseTableViewCellDelagate>

@property (nonatomic, strong)HK_SubListSaleData * mdoel;

@property (nonatomic, copy)CancelOrderBlock cancelBlock;

@end
