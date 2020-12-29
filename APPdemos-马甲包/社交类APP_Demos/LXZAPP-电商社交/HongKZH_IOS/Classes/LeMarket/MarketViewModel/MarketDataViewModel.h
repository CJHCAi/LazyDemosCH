//
//  MarketDataViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
@class MarketDataRespone,HKGameProductRespone,HKCouponResponse;
@interface MarketDataViewModel : HKBaseViewModel
+(void)myDataMarketSuccess:(void (^)(MarketDataRespone*respone))succes;
+(void)getCounponList:(void (^)(HKCouponResponse*respone))succes;
+(void)getGameProductRespone:(void (^)(HKGameProductRespone*respone))succes;
@end
