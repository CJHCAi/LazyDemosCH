//
//  HKMarketDataTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@class MarketDataRespone;
@interface HKMarketDataTableViewCell : BaseTableViewCell
@property (nonatomic, strong)MarketDataRespone *respone;
@end
