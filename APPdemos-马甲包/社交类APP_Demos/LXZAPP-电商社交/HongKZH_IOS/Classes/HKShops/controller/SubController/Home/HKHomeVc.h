//
//  HKHomeVc.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "HKShopResponse.h"
@interface HKHomeVc : HK_BaseView
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, assign)BOOL isHome;
// 1.首页推荐..  2.商品详情 3.热销  4.上新..
@property (nonatomic, assign)NSInteger shopType;
@end
