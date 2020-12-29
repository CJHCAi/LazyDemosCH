//
//  HKCollageDetailVc.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

typedef void(^cancelOrderBlock)(void);

@interface HKCollageDetailVc : HK_BaseView

@property (nonatomic, assign) BOOL isFromOrder;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) cancelOrderBlock block;
@end
