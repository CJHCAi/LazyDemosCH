//
//  HKHKMyAfterSaleViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKAfterBaseTableViewCell.h"
@class HKOrderFromInfoRespone;
@interface HKHKMyAfterSaleViewController : HKBaseViewController<HKAfterBaseTableViewCellDelagate>
@property (nonatomic, copy)NSString *orderNumber;
@end
